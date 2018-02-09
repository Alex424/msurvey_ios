//
//  InteriorCarCeilingEscapeHatchLocationViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarCeilingEscapeHatchLocationViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarCeilingEscapeHatchLocationViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UITextField * hatchLocationField;

    IBOutlet UITextField *leftWallField;
    IBOutlet UITextField *backWallField;
    IBOutlet UITextField *widthField;
    IBOutlet UITextField *lengthField;
}
@end

@implementation InteriorCarCeilingEscapeHatchLocationViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    hatchLocationField.inputAccessoryView = self.keyboardAccessoryView;
    leftWallField.inputAccessoryView = self.keyboardAccessoryView;
    backWallField.inputAccessoryView = self.keyboardAccessoryView;
    widthField.inputAccessoryView = self.keyboardAccessoryView;
    lengthField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[hatchLocationField, leftWallField, backWallField, widthField, lengthField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        [self.view endEditing:YES];

        if (hatchLocationField.text.length == 0) {
            [self showWarningAlert:@"Please input Escape Hatch Location!"];
            [hatchLocationField becomeFirstResponder];
            return;
        }
        
        InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
        interiorCar.escapeHatchLocation = hatchLocationField.text;
        interiorCar.escapeHatchToLeftWall = [leftWallField.text doubleValueCheckingEmpty];
        interiorCar.escapeHatchToBackWall = [backWallField.text doubleValueCheckingEmpty];
        interiorCar.escapeHatchWidth = [widthField.text doubleValueCheckingEmpty];
        interiorCar.escapeHatchLength = [lengthField.text doubleValueCheckingEmpty];
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCarType sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Escape Hatch Location" withImageName:@"img_help_interior_car_ceiling_escape_hatch_location"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    hatchLocationField.text = interiorCar.escapeHatchLocation ? interiorCar.escapeHatchLocation : @"";

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;
    
    leftWallField.text = interiorCar.escapeHatchToLeftWall >= 0 ? [formatter stringFromNumber:@(interiorCar.escapeHatchToLeftWall)] : @"";
    backWallField.text = interiorCar.escapeHatchToBackWall >= 0 ? [formatter stringFromNumber:@(interiorCar.escapeHatchToBackWall)] : @"";
    widthField.text = interiorCar.escapeHatchWidth >= 0 ? [formatter stringFromNumber:@(interiorCar.escapeHatchWidth)] : @"";
    lengthField.text = interiorCar.escapeHatchLength >= 0 ? [formatter stringFromNumber:@(interiorCar.escapeHatchLength)] : @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [hatchLocationField becomeFirstResponder];
    
    self.viewDescription = @"Cab Interior\nEscape Hatch Location";
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
