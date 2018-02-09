//
//  InteriorCarMeasurementViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarMeasurementViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarMeasurementViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UITextField * widthField;
    IBOutlet UITextField * heightField;
    IBOutlet UITextField * sideWidthField;
    IBOutlet UITextField * sideAuxField;
    IBOutlet UITextField * doorWidthField;
    IBOutlet UITextField * doorHeightField;
}

@end

@implementation InteriorCarMeasurementViewController

- (void)viewDidLoad {

    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    widthField.inputAccessoryView = self.keyboardAccessoryView;
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    sideWidthField.inputAccessoryView = self.keyboardAccessoryView;
    sideAuxField.inputAccessoryView = self.keyboardAccessoryView;
    doorWidthField.inputAccessoryView = self.keyboardAccessoryView;
    doorHeightField.inputAccessoryView = self.keyboardAccessoryView;

    self.viewDescription = @"Cab Interior\nCenter Measurements";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[widthField, heightField, sideWidthField, sideAuxField, doorWidthField, doorHeightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double width = [widthField.text doubleValueCheckingEmpty];
        double height = [heightField.text doubleValueCheckingEmpty];
        double sideWidth = [sideWidthField.text doubleValueCheckingEmpty];
        double sideAux = [sideAuxField.text doubleValueCheckingEmpty];
        double doorWidth = [doorWidthField.text doubleValueCheckingEmpty];
        double doorHeight = [doorHeightField.text doubleValueCheckingEmpty];
        
        if (width < 0) {
            [self showWarningAlert:@"Please input Width!"];
            [widthField becomeFirstResponder];
            return;
        }
        
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [heightField becomeFirstResponder];
            return;
        }
        
        if (sideWidth < 0) {
            [self showWarningAlert:@"Please input Side Wall Main Width!"];
            [sideWidthField becomeFirstResponder];
            return;
        }
        
        if (sideAux < 0) {
            [self showWarningAlert:@"Please input Side Wall Aux Width!"];
            [sideAuxField becomeFirstResponder];
            return;
        }
        
        if (doorWidth < 0) {
            [self showWarningAlert:@"Please input Door Opening Width!"];
            [doorWidthField becomeFirstResponder];
            return;
        }
        
        if (doorHeight < 0) {
            [self showWarningAlert:@"Please input Door Opening Height!"];
            [doorHeightField becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;

        door.width = width;
        door.height = height;
        door.sideWallAuxWidth = sideAux;
        door.sideWallMainWidth = sideWidth;
        door.doorOpeningWidth = doorWidth;
        door.doorOpeningHeight = doorHeight;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCarCenterMeasurementFrontReturnType sender:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [widthField becomeFirstResponder];
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_44_interior_car_center_measurement_help"];
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

    widthField.text = door.width >= 0 ? [formatter stringFromNumber:@(door.width)] : @"";
    heightField.text = door.height >= 0 ? [formatter stringFromNumber:@(door.height)] : @"";
    sideWidthField.text = door.sideWallMainWidth >= 0 ? [formatter stringFromNumber:@(door.sideWallMainWidth)] : @"";
    sideAuxField.text = door.sideWallAuxWidth >= 0 ? [formatter stringFromNumber:@(door.sideWallAuxWidth)] : @"";
    doorWidthField.text = door.doorOpeningWidth >= 0 ? [formatter stringFromNumber:@(door.doorOpeningWidth)] : @"";
    doorHeightField.text = door.doorOpeningHeight >= 0 ? [formatter stringFromNumber:@(door.doorOpeningHeight)] : @"";
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
