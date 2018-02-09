//
//  InteriorCarFloorHeightViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarFloorHeightViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarFloorHeightViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    IBOutlet UITextField * heightField;
}
@end

@implementation InteriorCarFloorHeightViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeCenterHelp;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    
    
    
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    
    [heightField becomeFirstResponder];
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car Floor Height";

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

    heightField.text = interiorCar.carFloorHeight >= 0 ? [formatter stringFromNumber:@(interiorCar.carFloorHeight)] : @"";
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    double height = [heightField.text doubleValueCheckingEmpty];
    if (height < 0) {
        [self showWarningAlert:@"Please input Floor Height!"];
        [heightField becomeFirstResponder];
        return;
    }
    
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    interiorCar.carFloorHeight = height;
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDInteriorCarCeilingExhaustFan sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior" withImageName:@"img_help_40_interior_car_floor_height_help"];
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
    return  YES;
}

@end
