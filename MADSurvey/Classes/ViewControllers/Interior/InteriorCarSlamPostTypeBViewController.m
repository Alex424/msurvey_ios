//
//  InteriorCarSlamPostTypeBViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarSlamPostTypeBViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarSlamPostTypeBViewController ()
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UITextField * aField;
    IBOutlet UITextField * bField;
    IBOutlet UITextField * cField;
    IBOutlet UITextField * dField;
    IBOutlet UITextField * eField;
//    IBOutlet UITextField * fField;
    IBOutlet UITextField * gField;
    IBOutlet UITextField * hField;

}

@end

@implementation InteriorCarSlamPostTypeBViewController

//InteriorCarSlamPostTypeBViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    aField.inputAccessoryView = self.keyboardAccessoryView;
    bField.inputAccessoryView = self.keyboardAccessoryView;
    cField.inputAccessoryView = self.keyboardAccessoryView;
    dField.inputAccessoryView = self.keyboardAccessoryView;
    eField.inputAccessoryView = self.keyboardAccessoryView;
//    fField.inputAccessoryView = self.keyboardAccessoryView;
    gField.inputAccessoryView = self.keyboardAccessoryView;
    hField.inputAccessoryView = self.keyboardAccessoryView;
    
    [aField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[aField, bField, cField, dField, eField, /*fField, */gField, hField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double a = [aField.text doubleValueCheckingEmpty];
        double b = [bField.text doubleValueCheckingEmpty];
        double c = [cField.text doubleValueCheckingEmpty];
        double d = [dField.text doubleValueCheckingEmpty];
        double e = [eField.text doubleValueCheckingEmpty];
//        double f = [fField.text doubleValueCheckingEmpty];
        double g = [gField.text doubleValueCheckingEmpty];
        double h = [hField.text doubleValueCheckingEmpty];
        
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
        if (d < 0) {
            [self showWarningAlert:@"Please input D!"];
            [dField becomeFirstResponder];
            return;
        }
        if (e < 0) {
            [self showWarningAlert:@"Please input E!"];
            [eField becomeFirstResponder];
            return;
        }
//        if (f < 0) {
//            [self showWarningAlert:@"Please input F!"];
//            [fField becomeFirstResponder];
//            return;
//        }
        if (g < 0) {
            [self showWarningAlert:@"Please input G!"];
            [gField becomeFirstResponder];
            return;
        }
        if (h < 0) {
            [self showWarningAlert:@"Please input H!"];
            [hField becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        
        door.slamPostMeasurementsA = a;
        door.slamPostMeasurementsB = b;
        door.slamPostMeasurementsC = c;
        door.slamPostMeasurementsD = d;
        door.slamPostMeasurementsE = e;
//        door.slamPostMeasurementsF = f;
        door.slamPostMeasurementsG = g;
        door.slamPostMeasurementsH = h;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCarTypeBToFront sender:nil];
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car Slam Post Type";
    
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

    aField.text = door.slamPostMeasurementsA >= 0 ? [formatter stringFromNumber:@(door.slamPostMeasurementsA)] : @"";
    bField.text = door.slamPostMeasurementsB >= 0 ? [formatter stringFromNumber:@(door.slamPostMeasurementsB)] : @"";
    cField.text = door.slamPostMeasurementsC >= 0 ? [formatter stringFromNumber:@(door.slamPostMeasurementsC)] : @"";
    dField.text = door.slamPostMeasurementsD >= 0 ? [formatter stringFromNumber:@(door.slamPostMeasurementsD)] : @"";
    eField.text = door.slamPostMeasurementsE >= 0 ? [formatter stringFromNumber:@(door.slamPostMeasurementsE)] : @"";
//    fField.text = door.slamPostMeasurementsF >= 0 ? [formatter stringFromNumber:@(door.slamPostMeasurementsF)] : @"";
    gField.text = door.slamPostMeasurementsG >= 0 ? [formatter stringFromNumber:@(door.slamPostMeasurementsG)] : @"";
    hField.text = door.slamPostMeasurementsH >= 0 ? [formatter stringFromNumber:@(door.slamPostMeasurementsH)] : @"";

    if ([DataManager sharedManager].currentDoorStyle == 2) {
        self.viewDescription = @"Cab Interior\nBack Door Slam Post Measurements";
    } else {
        self.viewDescription = @"Cab Interior\nFront Door Slam Post Measurements";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_45_interior_car_slam_post_type_b_help"];
}

@end
