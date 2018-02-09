//
//  InteriorCarSignleSideMeasurementViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarSignleSideMeasurementViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarSignleSideMeasurementViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    IBOutlet UITextField * widthField;
    IBOutlet UITextField * heightField;
    IBOutlet UITextField * returnSideDepthField;
    IBOutlet UITextField * slamSideDepthField;
//    IBOutlet UITextField * slideWallWidthField;
    IBOutlet UITextField * doorWidthField;
    IBOutlet UITextField * doorHeightField;
    
}
@end

@implementation InteriorCarSignleSideMeasurementViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeCenterHelp;

    [super viewDidLoad];
    
    widthField.inputAccessoryView = self.keyboardAccessoryView;
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    returnSideDepthField.inputAccessoryView = self.keyboardAccessoryView;
    slamSideDepthField.inputAccessoryView = self.keyboardAccessoryView;
//    slideWallWidthField.inputAccessoryView = self.keyboardAccessoryView;
    doorHeightField.inputAccessoryView = self.keyboardAccessoryView;
    doorWidthField.inputAccessoryView = self.keyboardAccessoryView;
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
    NSArray *textFields = @[widthField, heightField, returnSideDepthField, slamSideDepthField, /*slideWallWidthField, */doorWidthField, doorHeightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double width = [widthField.text doubleValueCheckingEmpty];
        double height = [heightField.text doubleValueCheckingEmpty];
        double returnSideDepth = [returnSideDepthField.text doubleValueCheckingEmpty];
        double slamSideDepth = [slamSideDepthField.text doubleValueCheckingEmpty];
    //    double slideWallWidth = [slideWallWidthField.text doubleValue];
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
        
        if (returnSideDepth < 0) {
            [self showWarningAlert:@"Please input Return Side Wall Depth!"];
            [returnSideDepthField becomeFirstResponder];
            return;
        }
        
        if (slamSideDepth < 0) {
            [self showWarningAlert:@"Please input Slam Side Wall Depth!"];
            [slamSideDepthField becomeFirstResponder];
            return;
        }
        
    //    if (slideWallWidth <= 0) {
    //        [self showWarningAlert:@"Please input Slide Wall Width!"];
    //        [slideWallWidthField becomeFirstResponder];
    //        return;
    //    }
        
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
        door.returnSideWallDepth = returnSideDepth;
        door.slamSideWallDepth = slamSideDepth;
    //    door.slideWallWidth = slideWallWidth;
        door.doorOpeningWidth = doorWidth;
        door.doorOpeningHeight = doorHeight;
        
        [[DataManager sharedManager] saveChanges];

        [self performSegueWithIdentifier:UINavigationIDNoSlamPostType sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_interior_car_single_side_measurements"];
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
    returnSideDepthField.text = door.returnSideWallDepth >= 0 ? [formatter stringFromNumber:@(door.returnSideWallDepth)] : @"";
    slamSideDepthField.text = door.slamSideWallDepth >= 0 ? [formatter stringFromNumber:@(door.slamSideWallDepth)] : @"";
//    slideWallWidthField.text = door.slideWallWidth > 0 ? [formatter stringFromNumber:@(door.slideWallWidth)] : @"";
    doorWidthField.text = door.doorOpeningWidth >= 0 ? [formatter stringFromNumber:@(door.doorOpeningWidth)] : @"";
    doorHeightField.text = door.doorOpeningHeight >= 0 ? [formatter stringFromNumber:@(door.doorOpeningHeight)] : @"";

    self.viewDescription = @"Cab Interior\nSingle Side Measurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [widthField becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
