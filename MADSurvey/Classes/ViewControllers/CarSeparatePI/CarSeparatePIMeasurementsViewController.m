//
//  CarSeparatePIMeasurementsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarSeparatePIMeasurementsViewController.h"
#import "HelpView.h"
#import "DataManager.h"

@interface CarSeparatePIMeasurementsViewController () <UITextFieldDelegate>

@end

@implementation CarSeparatePIMeasurementsViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    
    quantityField.inputAccessoryView = self.keyboardAccessoryView;
    coverWidthField.inputAccessoryView = self.keyboardAccessoryView;
    coverHeightField.inputAccessoryView = self.keyboardAccessoryView;
    coverDepthField.inputAccessoryView = self.keyboardAccessoryView;
    coverScrewWidthField.inputAccessoryView = self.keyboardAccessoryView;
    coverScrewHeightField.inputAccessoryView = self.keyboardAccessoryView;
    spaceWidthField.inputAccessoryView = self.keyboardAccessoryView;
    spaceHeightField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Separated PI Measurements";

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

    quantityField.text = car.numberPerCabSPI > 0 ? [NSString stringWithFormat:@"%d", car.numberPerCabSPI] : @"";
    coverWidthField.text = car.coverWidthSPI >= 0 ? [formatter stringFromNumber:@(car.coverWidthSPI)] : @"";
    coverHeightField.text = car.coverHeightSPI >= 0 ? [formatter stringFromNumber:@(car.coverHeightSPI)] : @"";
    coverDepthField.text = car.depthSPI >= 0 ? [formatter stringFromNumber:@(car.depthSPI)] : @"";
    coverScrewWidthField.text = car.coverScrewCenterWidthSPI >= 0 ? [formatter stringFromNumber:@(car.coverScrewCenterWidthSPI)] : @"";
    coverScrewHeightField.text = car.coverScrewCenterHeightSPI >= 0 ? [formatter stringFromNumber:@(car.coverScrewCenterHeightSPI)] : @"";
    spaceWidthField.text = car.spaceAvailableWidthSPI >= 0 ? [formatter stringFromNumber:@(car.spaceAvailableWidthSPI)] : @"";
    spaceHeightField.text = car.spaceAvailableHeightSPI >= 0 ? [formatter stringFromNumber:@(car.spaceAvailableHeightSPI)] : @"";
    
    self.viewDescription = @"COPs\nCar Separate PI Measurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [quantityField becomeFirstResponder];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([quantityField isFirstResponder]) {
        [coverWidthField becomeFirstResponder];
    } else if ([coverWidthField isFirstResponder]) {
        [coverHeightField becomeFirstResponder];
    } else if ([coverHeightField isFirstResponder]) {
        [coverDepthField becomeFirstResponder];
    } else if ([coverDepthField isFirstResponder]) {
        [coverScrewWidthField becomeFirstResponder];
    } else if ([coverScrewWidthField isFirstResponder]) {
        [coverScrewHeightField becomeFirstResponder];
    } else if ([coverScrewHeightField isFirstResponder]) {
        [spaceWidthField becomeFirstResponder];
    } else if ([spaceWidthField isFirstResponder]) {
        [spaceHeightField becomeFirstResponder];
    } else {
        NSInteger quantity = [quantityField.text integerValue];
        double width = [coverWidthField.text doubleValueCheckingEmpty];
        double height = [coverHeightField.text doubleValueCheckingEmpty];
        double depth = [coverDepthField.text doubleValueCheckingEmpty];
        double screwWidth = [coverScrewWidthField.text doubleValueCheckingEmpty];
        double screwHeight = [coverScrewHeightField.text doubleValueCheckingEmpty];
        double spaceWidth = [spaceWidthField.text doubleValueCheckingEmpty];
        double spaceHeight = [spaceHeightField.text doubleValueCheckingEmpty];
        
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
        if (spaceWidth < 0) {
            [self showWarningAlert:@"Please input Space Available Width!"];
            [spaceWidthField becomeFirstResponder];
            return;
        }
        if (spaceHeight < 0) {
            [self showWarningAlert:@"Please input Space Available Height!"];
            [spaceHeightField becomeFirstResponder];
            return;
        }
        
        Car *car = [DataManager sharedManager].currentCar;
        
        car.numberPerCabSPI = (int32_t)quantity;
        car.coverWidthSPI = width;
        car.coverHeightSPI = height;
        car.depthSPI = depth;
        car.coverScrewCenterWidthSPI = screwWidth;
        car.coverScrewCenterHeightSPI = screwHeight;
        car.spaceAvailableWidthSPI = spaceWidth;
        car.spaceAvailableHeightSPI = spaceHeight;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDCarSeparatePINotes sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Separate PI Measurements" withImageName:@"img_help_37_car_cop_separatepi_measurements_help"];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
