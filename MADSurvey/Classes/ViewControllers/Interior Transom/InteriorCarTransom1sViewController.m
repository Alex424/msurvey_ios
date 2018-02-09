//
//  InteriorCarTransom1sViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarTransom1sViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarTransom1sViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UITextField * heightField;
    IBOutlet UITextField * widthField;
    IBOutlet UITextField * leftField;
    IBOutlet UITextField * centerField;
    IBOutlet UITextField * rightField;
}

@end

@implementation InteriorCarTransom1sViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    widthField.inputAccessoryView = self.keyboardAccessoryView;
    leftField.inputAccessoryView = self.keyboardAccessoryView;
    centerField.inputAccessoryView = self.keyboardAccessoryView;
    rightField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[heightField, widthField, leftField, centerField, rightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double height = [heightField.text doubleValueCheckingEmpty];
        double width = [widthField.text doubleValueCheckingEmpty];
        double left = [leftField.text doubleValueCheckingEmpty];
        double center = [centerField.text doubleValueCheckingEmpty];
        double right = [rightField.text doubleValueCheckingEmpty];
        
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
        if (left < 0) {
            [self showWarningAlert:@"Please input Left!"];
            [leftField becomeFirstResponder];
            return;
        }
        if (center < 0) {
            [self showWarningAlert:@"Please input Center!"];
            [centerField becomeFirstResponder];
            return;
        }
        if (right < 0) {
            [self showWarningAlert:@"Please input Right!"];
            [rightField becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;

        door.transomMeasurementsHeight = height;
        door.transomMeasurementsWidth = width;
        door.transomMeasurementsLeft = left;
        door.transomMeasurementsCenter = center;
        door.transomMeasurementsRight = right;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCarTransomProfile1s sender:nil];
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

    heightField.text = door.transomMeasurementsHeight >= 0 ? [formatter stringFromNumber:@(door.transomMeasurementsHeight)] : @"";
    widthField.text = door.transomMeasurementsWidth >= 0 ? [formatter stringFromNumber:@(door.transomMeasurementsWidth)] : @"";
    leftField.text = door.transomMeasurementsLeft >= 0 ? [formatter stringFromNumber:@(door.transomMeasurementsLeft)] : @"";
    centerField.text = door.transomMeasurementsCenter >= 0 ? [formatter stringFromNumber:@(door.transomMeasurementsCenter)] : @"";
    rightField.text = door.transomMeasurementsRight >= 0 ? [formatter stringFromNumber:@(door.transomMeasurementsRight)] : @"";

    if ([DataManager sharedManager].currentDoorStyle == 2) {
        self.viewDescription = @"Cab Interior\nCar Back TRANSOM Measurements";
    } else {
        self.viewDescription = @"Cab Interior\nCar Front TRANSOM Measurements";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [heightField becomeFirstResponder];
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_48_interior_car_transom_2s_help"];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
