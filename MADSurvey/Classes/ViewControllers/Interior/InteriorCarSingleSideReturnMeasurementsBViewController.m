//
//  InteriorCarSingleSideReturnMeasurementsBViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarSingleSideReturnMeasurementsBViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarSingleSideReturnMeasurementsBViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    IBOutlet UITextField * aField;
    IBOutlet UITextField * bField;
    IBOutlet UITextField * cField;
    IBOutlet UITextField * heightField;
}

@end

@implementation InteriorCarSingleSideReturnMeasurementsBViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    aField.inputAccessoryView = self.keyboardAccessoryView;
    bField.inputAccessoryView = self.keyboardAccessoryView;
    cField.inputAccessoryView = self.keyboardAccessoryView;
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[aField, bField, cField, heightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double a = [aField.text doubleValueCheckingEmpty];
        double b = [bField.text doubleValueCheckingEmpty];
        double c = [cField.text doubleValueCheckingEmpty];
        double height = [heightField.text doubleValueCheckingEmpty];
        
        if (a < 0) {
            [self showWarningAlert:@"Please input A!"];
            [aField becomeFirstResponder];
            return;
        }
        
        if (b < 0) {
            [self showWarningAlert:@"Please input B!"];
            [bField becomeFirstResponder];
            return;
        }
        
        if (c < 0) {
            [self showWarningAlert:@"Please input C!"];
            [cField becomeFirstResponder];
            return;
        }
        
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [heightField becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        
        door.leftSideA = a;
        door.leftSideB = b;
        door.leftSideC = c;
        door.frontReturnMeasurementsHeight = height;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCarDoorSingleSideBToDoorType sender:nil];
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

    aField.text = door.leftSideA >= 0 ? [formatter stringFromNumber:@(door.leftSideA)] : @"";
    bField.text = door.leftSideB >= 0 ? [formatter stringFromNumber:@(door.leftSideB)] : @"";
    cField.text = door.leftSideC >= 0 ? [formatter stringFromNumber:@(door.leftSideC)] : @"";
    
    heightField.text = door.frontReturnMeasurementsHeight >= 0 ? [formatter stringFromNumber:@(door.frontReturnMeasurementsHeight)] : @"";

    if ([DataManager sharedManager].currentDoorStyle == 2) {
        self.viewDescription = @"Cab Interior\nSingle Side Back Return Measurements";
    } else {
        self.viewDescription = @"Cab Interior\nSingle Side Front Return Measurements";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [aField becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_46_interior_car_single_side_return_measurements_b_help"];
}

@end
