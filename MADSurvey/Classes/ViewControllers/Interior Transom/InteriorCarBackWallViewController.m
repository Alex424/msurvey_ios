//
//  InteriorCarBackWallViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarBackWallViewController.h"
#import "Constants.h"
#import "DataManager.h"
#import "InteriorCarDescriptionViewController.h"
#import "FloorDescriptionViewController.h"
#import "BankNameViewController.h"
#import "FinalViewController.h"
#import "EditInteriorCarListViewController.h"

@interface InteriorCarBackWallViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UITextField * heightField;
    IBOutlet UITextField * widthField;
}
@end

@implementation InteriorCarBackWallViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    widthField.inputAccessoryView = self.keyboardAccessoryView;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car Back Wall";

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car - %@", interiorCar.carDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d - %@", (int32_t)[DataManager sharedManager].currentInteriorCarNum + 1, bank.numOfInteriorCar, interiorCar.carDescription];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    heightField.text = interiorCar.rearWallHeight >= 0 ? [formatter stringFromNumber:@(interiorCar.rearWallHeight)] :  @"";
    widthField.text = interiorCar.rearWallWidth >= 0 ? [formatter stringFromNumber:@(interiorCar.rearWallWidth)] : @"";
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [heightField becomeFirstResponder];
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([heightField isFirstResponder]) {
        [widthField becomeFirstResponder];
    } else {
        double height = [heightField.text doubleValueCheckingEmpty];
        double width = [widthField.text doubleValueCheckingEmpty];
        
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [heightField becomeFirstResponder];
            return;
        }
        if (width < 0) {
            [self showWarningAlert:@"Please input Width!"];
            [widthField becomeFirstResponder];
            return;
        }
        
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
        
        interiorCar.rearWallHeight = height;
        interiorCar.rearWallWidth = width;
        
        [[DataManager sharedManager] saveChanges];
        
        if ([DataManager sharedManager].isEditing) {
            [self backToSpecificClass:[EditInteriorCarListViewController class]];
            return;
        }
        
        NSInteger interiorCarCount = bank.numOfInteriorCar;

        if (interiorCarCount > [DataManager sharedManager].currentInteriorCarNum + 1) {
            [DataManager sharedManager].currentInteriorCarNum ++;
            
            InteriorCarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarDescriptionViewController"];
            [self backToSpecificViewController:lvc];
        } else {
            if (project.hallEntrances == 1) {
                FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
                lvc.fromBank = NO;
                [self.navigationController pushViewController:lvc animated:YES];
                return;
            } else {
                if (project.numBanks > [DataManager sharedManager].currentBankIndex + 1) {
                    [DataManager sharedManager].currentInteriorCarNum = 0;
                    [DataManager sharedManager].currentInteriorCar = nil;
                    [DataManager sharedManager].currentBankIndex ++;
                    
                    BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
                    [self backToSpecificViewController:lvc];
                } else {
                    FinalViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"FinalViewController"];
                    [self.navigationController pushViewController:lvc animated:YES];
                    return;
                }
            }
        }
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Interior Car Measurements" withImageName:@"img_help_52_interior_car_back_wall_help"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
