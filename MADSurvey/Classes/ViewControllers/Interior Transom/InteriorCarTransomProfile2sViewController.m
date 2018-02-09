//
//  InteriorCarTransomProfile2sViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarTransomProfile2sViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarTransomProfile2sViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UITextField * heightField;
    IBOutlet UITextField * depthField;
    IBOutlet UITextField * returnField;
    IBOutlet UITextField * colField;
    IBOutlet UITextField * col1Field;
}

@end

@implementation InteriorCarTransomProfile2sViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    depthField.inputAccessoryView = self.keyboardAccessoryView;
    returnField.inputAccessoryView = self.keyboardAccessoryView;
    colField.inputAccessoryView = self.keyboardAccessoryView;
    col1Field.inputAccessoryView = self.keyboardAccessoryView;
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[heightField, depthField, returnField, colField, col1Field];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double height = [heightField.text doubleValueCheckingEmpty];
        double depth = [depthField.text doubleValueCheckingEmpty];
        double returnVal = [returnField.text doubleValueCheckingEmpty];
        double col = [colField.text doubleValueCheckingEmpty];
        double col2 = [col1Field.text doubleValueCheckingEmpty];
        
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [heightField becomeFirstResponder];
            return;
        }
        if (depth < 0) {
            [self showWarningAlert:@"Please input Depth!"];
            [depthField becomeFirstResponder];
            return;
        }
        if (returnVal < 0) {
            [self showWarningAlert:@"Please input Return!"];
            [returnField becomeFirstResponder];
            return;
        }
        if (col < 0) {
            [self showWarningAlert:@"Please input Colonnade!"];
            [colField becomeFirstResponder];
            return;
        }
        if (col2 < 0) {
            [self showWarningAlert:@"Please input Colonnade2!"];
            [col1Field becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        
        door.transomProfileHeight = height;
        door.transomProfileDepth = depth;
        door.transomProfileReturn = returnVal;
        door.transomProfileColonnade = col;
        door.transomProfileColonnade2 = col2;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInterior2sCarCopInstalled sender:nil];
    }
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
    
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    heightField.text = door.transomProfileHeight >= 0 ? [formatter stringFromNumber:@(door.transomProfileHeight)] : @"";
    depthField.text = door.transomProfileDepth >= 0 ? [formatter stringFromNumber:@(door.transomProfileDepth)] : @"";
    returnField.text = door.transomProfileReturn >= 0 ? [formatter stringFromNumber:@(door.transomProfileReturn)] : @"";
    colField.text = door.transomProfileColonnade >= 0 ? [formatter stringFromNumber:@(door.transomProfileColonnade)] : @"";
    col1Field.text = door.transomProfileColonnade2 >= 0 ? [formatter stringFromNumber:@(door.transomProfileColonnade2)] : @"";

    if ([DataManager sharedManager].currentDoorStyle == 2) {
        self.viewDescription = @"Cab Interior\nCar Back TRANSOM Profile";
    } else {
        self.viewDescription = @"Cab Interior\nCar Front TRANSOM Profile";
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [heightField becomeFirstResponder];
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_49_interior_car_transom_profile_2s_help"];
}

@end
