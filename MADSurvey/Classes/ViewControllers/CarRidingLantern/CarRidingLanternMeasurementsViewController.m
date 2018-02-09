//
//  CarRidingLanternMeasurementsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarRidingLanternMeasurementsViewController.h"
#import "HelpView.h"
#import "DataManager.h"

@interface CarRidingLanternMeasurementsViewController ()

@end

@implementation CarRidingLanternMeasurementsViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    
    quantityField.inputAccessoryView = self.keyboardAccessoryView;
    coverWidthField.inputAccessoryView = self.keyboardAccessoryView;
    coverHeightField.inputAccessoryView = self.keyboardAccessoryView;
    coverDepthField.inputAccessoryView = self.keyboardAccessoryView;
    coverScrewWidthField.inputAccessoryView = self.keyboardAccessoryView;
    coverScrewHeightField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Riding Measurements";

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    Car *car = [DataManager sharedManager].currentCar;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car - %@", car.carNumber];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d - %@", (int32_t)[DataManager sharedManager].currentCarNum + 1, bank.numOfCar, car.carNumber];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    quantityField.text = car.numberPerCabCDI > 0 ? [NSString stringWithFormat:@"%d", car.numberPerCabCDI] : @"";
    coverWidthField.text = car.coverWidthCDI >= 0 ? [formatter stringFromNumber:@(car.coverWidthCDI)] : @"";
    coverHeightField.text = car.coverHeightCDI >= 0 ? [formatter stringFromNumber:@(car.coverHeightCDI)] : @"";
    coverDepthField.text = car.depthCDI >= 0 ? [formatter stringFromNumber:@(car.depthCDI)] : @"";
    coverScrewWidthField.text = car.coverScrewCenterWidthCDI >= 0 ? [formatter stringFromNumber:@(car.coverScrewCenterWidthCDI)] : @"";
    coverScrewHeightField.text = car.coverScrewCenterHeightCDI >= 0 ? [formatter stringFromNumber:@(car.coverScrewCenterHeightCDI)] : @"";

    self.viewDescription = @"COPs\nCar Riding Lantern Measurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [quantityField becomeFirstResponder];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[quantityField,
                            coverWidthField,
                            coverHeightField,
                            coverDepthField,
                            coverScrewWidthField,
                            coverScrewHeightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        NSInteger quantity = [quantityField.text integerValue];
        double width = [coverWidthField.text doubleValueCheckingEmpty];
        double height = [coverHeightField.text doubleValueCheckingEmpty];
        double depth = [coverDepthField.text doubleValueCheckingEmpty];
        double screwWidth = [coverScrewWidthField.text doubleValueCheckingEmpty];
        double screwHeight = [coverScrewHeightField.text doubleValueCheckingEmpty];
        
        if (quantity <= 0) {
            [self showWarningAlert:@"Please input Quantity Per car!"];
            [quantityField becomeFirstResponder];
            return;
        }
        if (width < 0) {
            [self showWarningAlert:@"Please input Width!"];
            [coverWidthField becomeFirstResponder];
            return;
        }
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [coverHeightField becomeFirstResponder];
            return;
        }
        if (depth < 0) {
            [self showWarningAlert:@"Please input Depth!"];
            [coverDepthField becomeFirstResponder];
            return;
        }
        if (screwWidth < 0) {
            [self showWarningAlert:@"Please input Screw Center Width!"];
            [coverScrewWidthField becomeFirstResponder];
            return;
        }
        if (screwHeight < 0) {
            [self showWarningAlert:@"Please input Screw Center Height!"];
            [coverScrewHeightField becomeFirstResponder];
            return;
        }
        
        Car *car = [DataManager sharedManager].currentCar;
        
        car.numberPerCabCDI = (int32_t)quantity;
        car.coverWidthCDI = width;
        car.coverHeightCDI = height;
        car.depthCDI = depth;
        car.coverScrewCenterWidthCDI = screwWidth;
        car.coverScrewCenterHeightCDI = screwHeight;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDCarRidingLanternNotes sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Riding Lantern" withImageName:@"img_help_34_car_riding_lantern_measurements_help"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
