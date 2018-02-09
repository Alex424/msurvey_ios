//
//  InteriorCarCenterReturnMeasurementsAViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarCenterReturnMeasurementsAViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarCenterReturnMeasurementsAViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    IBOutlet UITextField * leftAField;
    IBOutlet UITextField * leftBField;
    IBOutlet UITextField * leftCField;
    IBOutlet UITextField * leftDField;
    IBOutlet UITextField * leftFField;
    
    IBOutlet UITextField * rightAField;
    IBOutlet UITextField * rightBField;
    IBOutlet UITextField * rightCField;
    IBOutlet UITextField * rightDField;
    IBOutlet UITextField * rightFField;
    
    IBOutlet UITextField * heightField;
}

@end

@implementation InteriorCarCenterReturnMeasurementsAViewController

//InteriorCarCenterReturnMeasurementsAViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    
    leftAField.inputAccessoryView = self.keyboardAccessoryView;
    leftBField.inputAccessoryView = self.keyboardAccessoryView;
    leftCField.inputAccessoryView = self.keyboardAccessoryView;
    leftDField.inputAccessoryView = self.keyboardAccessoryView;
    leftFField.inputAccessoryView = self.keyboardAccessoryView;
    
    rightAField.inputAccessoryView = self.keyboardAccessoryView;
    rightBField.inputAccessoryView = self.keyboardAccessoryView;
    rightCField.inputAccessoryView = self.keyboardAccessoryView;
    rightDField.inputAccessoryView = self.keyboardAccessoryView;
    rightFField.inputAccessoryView = self.keyboardAccessoryView;
    
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[leftAField, leftBField, leftCField, leftDField, leftFField, rightAField, rightBField, rightCField, rightDField, rightFField, heightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double la = [leftAField.text doubleValueCheckingEmpty];
        double lb = [leftBField.text doubleValueCheckingEmpty];
        double lc = [leftCField.text doubleValueCheckingEmpty];
        double ld = [leftDField.text doubleValueCheckingEmpty];
        double le = [leftFField.text doubleValueCheckingEmpty];
        double ra = [rightAField.text doubleValueCheckingEmpty];
        double rb = [rightBField.text doubleValueCheckingEmpty];
        double rc = [rightCField.text doubleValueCheckingEmpty];
        double rd = [rightDField.text doubleValueCheckingEmpty];
        double re = [rightFField.text doubleValueCheckingEmpty];
        double height = [heightField.text doubleValueCheckingEmpty];
        
        if (la < 0) {
            [self showWarningAlert:@"Please input Left Side A!"];
            [leftAField becomeFirstResponder];
            return;
        }
        
        if (lb < 0) {
            [self showWarningAlert:@"Please input Left Side B!"];
            [leftBField becomeFirstResponder];
            return;
        }
        
        if (lc < 0) {
            [self showWarningAlert:@"Please input Left Side C!"];
            [leftCField becomeFirstResponder];
            return;
        }
        
        if (ld < 0) {
            [self showWarningAlert:@"Please input Left Side D!"];
            [leftDField becomeFirstResponder];
            return;
        }
        
        if (le < 0) {
            [self showWarningAlert:@"Please input Left Side E!"];
            [leftFField becomeFirstResponder];
            return;
        }

        if (ra < 0) {
            [self showWarningAlert:@"Please input Right Side A!"];
            [rightAField becomeFirstResponder];
            return;
        }
        
        if (rb < 0) {
            [self showWarningAlert:@"Please input Right Side B!"];
            [rightBField becomeFirstResponder];
            return;
        }
        
        if (rc < 0) {
            [self showWarningAlert:@"Please input Right Side C!"];
            [rightCField becomeFirstResponder];
            return;
        }
        
        if (rd < 0) {
            [self showWarningAlert:@"Please input Right Side D!"];
            [rightDField becomeFirstResponder];
            return;
        }
        
        if (re < 0) {
            [self showWarningAlert:@"Please input Right Side E!"];
            [rightFField becomeFirstResponder];
            return;
        }

        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [heightField becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        
        door.leftSideA = la;
        door.leftSideB = lb;
        door.leftSideC = lc;
        door.leftSideD = ld;
        door.leftSideE = le;
        door.rightSideA = ra;
        door.rightSideB = rb;
        door.rightSideC = rc;
        door.rightSideD = rd;
        door.rightSideE = re;
        door.frontReturnMeasurementsHeight = height;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCenterATransom sender:nil];
    }
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

    leftAField.text = door.leftSideA >= 0 ? [formatter stringFromNumber:@(door.leftSideA)] : @"";
    leftBField.text = door.leftSideB >= 0 ? [formatter stringFromNumber:@(door.leftSideB)] : @"";
    leftCField.text = door.leftSideC >= 0 ? [formatter stringFromNumber:@(door.leftSideC)] : @"";
    leftDField.text = door.leftSideD >= 0 ? [formatter stringFromNumber:@(door.leftSideD)] : @"";
    leftFField.text = door.leftSideE >= 0 ? [formatter stringFromNumber:@(door.leftSideE)] : @"";
    
    rightAField.text = door.rightSideA >= 0 ? [formatter stringFromNumber:@(door.rightSideA)] : @"";
    rightBField.text = door.rightSideB >= 0 ? [formatter stringFromNumber:@(door.rightSideB)] : @"";
    rightCField.text = door.rightSideC >= 0 ? [formatter stringFromNumber:@(door.rightSideC)] : @"";
    rightDField.text  = door.rightSideD >= 0 ? [formatter stringFromNumber:@(door.rightSideD)] : @"";
    rightFField.text = door.rightSideE >= 0 ? [formatter stringFromNumber:@(door.rightSideE)] : @"";
    
    heightField.text = door.frontReturnMeasurementsHeight >= 0 ? [formatter stringFromNumber:@(door.frontReturnMeasurementsHeight)] : @"";

    if ([DataManager sharedManager].currentDoorStyle == 2) {
        self.viewDescription = @"Cab Interior\nCenter Back Return Measurements";
    } else {
        self.viewDescription = @"Cab Interior\nCenter Front Return Measurements";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [leftAField becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_46_interior_car_center_return_measurements_a_help"];
}

@end
