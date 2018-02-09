//
//  InteriorCarCeilingExhaustFanLocationViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarCeilingExhaustFanLocationViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarCeilingExhaustFanLocationViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UITextField * locationField;
    
    IBOutlet UITextField *leftWallField;
    IBOutlet UITextField *backWallField;
    IBOutlet UITextField *widthField;
    IBOutlet UITextField *lengthField;
}
@end

@implementation InteriorCarCeilingExhaustFanLocationViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeCenterHelp;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationField.inputAccessoryView = self.keyboardAccessoryView;
    leftWallField.inputAccessoryView = self.keyboardAccessoryView;
    backWallField.inputAccessoryView = self.keyboardAccessoryView;
    widthField.inputAccessoryView = self.keyboardAccessoryView;
    lengthField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Interior Car Ceiling Exhaust Fan Location";
    
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
    
    locationField.text = interiorCar.exhaustFanLocation ? interiorCar.exhaustFanLocation : @"";

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;
    
    leftWallField.text = interiorCar.exhaustToLeftWall >= 0 ? [formatter stringFromNumber:@(interiorCar.exhaustToLeftWall)] : @"";
    backWallField.text = interiorCar.exhaustToBackWall >= 0 ? [formatter stringFromNumber:@(interiorCar.exhaustToBackWall)] : @"";
    widthField.text = interiorCar.exhaustWidth >= 0 ? [formatter stringFromNumber:@(interiorCar.exhaustWidth)] : @"";
    lengthField.text = interiorCar.exhaustLength >= 0 ? [formatter stringFromNumber:@(interiorCar.exhaustLength)] : @"";

    self.viewDescription = @"Cab Interior\nExhaust Fan Location";
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [locationField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[locationField, leftWallField, backWallField, widthField, lengthField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        [self.view endEditing:YES];

        if (locationField.text.length == 0) {
            [self showWarningAlert:@"Please input Exhaust Fan Location!"];
            [locationField becomeFirstResponder];
            return;
        }
        
        InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
        interiorCar.exhaustFanLocation = locationField.text;
        interiorCar.exhaustToLeftWall = [leftWallField.text doubleValueCheckingEmpty];
        interiorCar.exhaustToBackWall = [backWallField.text doubleValueCheckingEmpty];
        interiorCar.exhaustWidth = [widthField.text doubleValueCheckingEmpty];
        interiorCar.exhaustLength = [lengthField.text doubleValueCheckingEmpty];
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCarCeilingFrameType sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Exhaust Fan Location" withImageName:@"img_help_interior_car_ceiling_exhaust_fan_location"];
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
