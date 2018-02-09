//
//  InteriorCarCenterReturnMeasurementsBViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarCenterReturnMeasurementsBViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarCenterReturnMeasurementsBViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    IBOutlet UITextField * leftAfield;
    IBOutlet UITextField * leftBfield;
    IBOutlet UITextField * leftCfield;
    
    IBOutlet UITextField * rightAfield;
    IBOutlet UITextField * rightBfield;
    IBOutlet UITextField * rightCfield;
    
    IBOutlet UITextField * heightfield;
    
}

@end

@implementation InteriorCarCenterReturnMeasurementsBViewController

//InteriorCarCenterReturnMeasurementsBViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    leftAfield.inputAccessoryView = self.keyboardAccessoryView;
    leftBfield.inputAccessoryView = self.keyboardAccessoryView;
    leftCfield.inputAccessoryView = self.keyboardAccessoryView;
    rightAfield.inputAccessoryView = self.keyboardAccessoryView;
    rightBfield.inputAccessoryView = self.keyboardAccessoryView;
    rightCfield.inputAccessoryView = self.keyboardAccessoryView;
    heightfield.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[leftAfield, leftBfield, leftCfield, rightAfield, rightBfield, rightCfield, heightfield];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double la = [leftAfield.text doubleValueCheckingEmpty];
        double lb = [leftBfield.text doubleValueCheckingEmpty];
        double lc = [leftCfield.text doubleValueCheckingEmpty];
        double ra = [rightAfield.text doubleValueCheckingEmpty];
        double rb = [rightBfield.text doubleValueCheckingEmpty];
        double rc = [rightCfield.text doubleValueCheckingEmpty];
        double height = [heightfield.text doubleValueCheckingEmpty];
        
        if (la < 0) {
            [self showWarningAlert:@"Please input Left Side A!"];
            [leftAfield becomeFirstResponder];
            return;
        }
        
        if (lb < 0) {
            [self showWarningAlert:@"Please input Left Side B!"];
            [leftBfield becomeFirstResponder];
            return;
        }
        
        if (lc < 0) {
            [self showWarningAlert:@"Please input Left Side C!"];
            [leftCfield becomeFirstResponder];
            return;
        }
        
        if (ra < 0) {
            [self showWarningAlert:@"Please input Right Side A!"];
            [rightAfield becomeFirstResponder];
            return;
        }
        
        if (rb < 0) {
            [self showWarningAlert:@"Please input Right Side B!"];
            [rightBfield becomeFirstResponder];
            return;
        }
        
        if (rc < 0) {
            [self showWarningAlert:@"Please input Right Side C!"];
            [rightCfield becomeFirstResponder];
            return;
        }
        
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [heightfield becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        
        door.leftSideA = la;
        door.leftSideB = lb;
        door.leftSideC = lc;
        door.rightSideA = ra;
        door.rightSideB = rb;
        door.rightSideC = rc;
        door.frontReturnMeasurementsHeight = height;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCenterBTransom sender:nil];
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

    leftAfield.text = door.leftSideA >= 0 ? [formatter stringFromNumber:@(door.leftSideA)] : @"";
    leftBfield.text = door.leftSideB >= 0 ? [formatter stringFromNumber:@(door.leftSideB)] : @"";
    leftCfield.text = door.leftSideC >= 0 ? [formatter stringFromNumber:@(door.leftSideC)] : @"";
    
    rightAfield.text = door.rightSideA >= 0 ? [formatter stringFromNumber:@(door.rightSideA)] : @"";
    rightBfield.text = door.rightSideB >= 0 ? [formatter stringFromNumber:@(door.rightSideB)] : @"";
    rightCfield.text = door.rightSideC >= 0 ? [formatter stringFromNumber:@(door.rightSideC)] : @"";
    
    heightfield.text = door.frontReturnMeasurementsHeight >= 0 ? [formatter stringFromNumber:@(door.frontReturnMeasurementsHeight)] : @"";

    if ([DataManager sharedManager].currentDoorStyle == 2) {
        self.viewDescription = @"Cab Interior\nCenter Back Return Measurements";
    } else {
        self.viewDescription = @"Cab Interior\nCenter Front Return Measurements";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [leftAfield becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_46_interior_car_center_return_measurements_b_help"];
}

@end
