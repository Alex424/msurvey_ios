//
//  CarDoorMeasurementsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarDoorMeasurementsViewController.h"
#import "Constants.h"
#import "HelpView.h"
#import "DataManager.h"

@interface CarDoorMeasurementsViewController () <UITextFieldDelegate>

@end

@implementation CarDoorMeasurementsViewController

- (IBAction)copyFromFront:(id)sender {
    Car *car = [DataManager sharedManager].currentCar;

    if (car.isThereRearDoor == 1) {
        openingHeightBackField.text = openingHeightFrontField.text;
        returnWidthBackField.text = returnWidthFrontField.text;
        strikeWidthBackField.text = strikeWidthFrontField.text;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([openingHeightFrontField isFirstResponder]) {
        [returnWidthFrontField becomeFirstResponder];
        return;
    } else if ([returnWidthFrontField isFirstResponder]) {
        [strikeWidthFrontField becomeFirstResponder];
        return;
    } else if ([strikeWidthFrontField isFirstResponder]) {
        if (strikeWidthFrontField.returnKeyType == UIReturnKeyNext) {
            [openingHeightBackField becomeFirstResponder];
            return;
        }
    } else if ([openingHeightBackField isFirstResponder]) {
        [returnWidthBackField becomeFirstResponder];
        return;
    } else if ([returnWidthBackField isFirstResponder]) {
        [strikeWidthBackField becomeFirstResponder];
        return;
    }

    double frontOpeningHeight = [openingHeightFrontField.text doubleValueCheckingEmpty];
    double rearOpeningHeight = [openingHeightBackField.text doubleValueCheckingEmpty];
    double frontReturnWidth = [returnWidthFrontField.text doubleValueCheckingEmpty];
    double rearReturnWidth = [returnWidthBackField.text doubleValueCheckingEmpty];
    double frontStrikeWidth = [strikeWidthFrontField.text doubleValueCheckingEmpty];
    double rearStrikeWidth = [strikeWidthBackField.text doubleValueCheckingEmpty];
    
    Car *car = [DataManager sharedManager].currentCar;

    if (frontOpeningHeight < 0) {
        [self showWarningAlert:@"Please input Front Door Opening Height!"];
        [openingHeightFrontField becomeFirstResponder];
        return;
    }
    
    if (frontReturnWidth < 0) {
        [self showWarningAlert:@"Please input Front Door Return Jamb Width!"];
        [returnWidthFrontField becomeFirstResponder];
        return;
    }
    
    if (frontStrikeWidth < 0) {
        [self showWarningAlert:@"Please input Front Door Strike Jamb Width!"];
        [strikeWidthFrontField becomeFirstResponder];
        return;
    }

    if (car.isThereRearDoor == 1) {
        if (rearOpeningHeight < 0) {
            [self showWarningAlert:@"Please input Back Door Opening Height!"];
            [openingHeightBackField becomeFirstResponder];
            return;
        }
        
        if (rearReturnWidth < 0) {
            [self showWarningAlert:@"Please input Back Door Return Jamb Width!"];
            [returnWidthBackField becomeFirstResponder];
            return;
        }
        
        if (rearStrikeWidth < 0) {
            [self showWarningAlert:@"Please input Back Door Strike Jamb Width!"];
            [strikeWidthBackField becomeFirstResponder];
            return;
        }
        
        car.rearDoorOpeningHeight = rearOpeningHeight;
        car.rearDoorSlideJambWidth = rearReturnWidth;
        car.rearDoorStrikeJambWidth = rearStrikeWidth;
    }
    car.frontDoorOpeningHeight = frontOpeningHeight;
    car.frontDoorSlideJambWidth = frontReturnWidth;
    car.frontDoorStrikeJambWidth = frontStrikeWidth;
    
    [[DataManager sharedManager] saveChanges];

    [self performSegueWithIdentifier:UINavigationIDCarHandrail sender:nil];
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Door Measurements" withImageName:@"img_help_28_car_door_measurements_help"];
}

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    
    copyButton.layer.cornerRadius = 5.0f;
    
    openingHeightFrontField.inputAccessoryView = self.keyboardAccessoryView;
    openingHeightBackField.inputAccessoryView = self.keyboardAccessoryView;
    returnWidthFrontField.inputAccessoryView = self.keyboardAccessoryView;
    returnWidthBackField.inputAccessoryView = self.keyboardAccessoryView;
    strikeWidthFrontField.inputAccessoryView = self.keyboardAccessoryView;
    strikeWidthBackField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Door Measurements";

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

    openingHeightFrontField.text = car.frontDoorOpeningHeight >= 0 ? [formatter stringFromNumber:@(car.frontDoorOpeningHeight)] : @"";
    returnWidthFrontField.text = car.frontDoorSlideJambWidth >= 0 ? [formatter stringFromNumber:@(car.frontDoorSlideJambWidth)] : @"";
    strikeWidthFrontField.text = car.frontDoorStrikeJambWidth >= 0 ? [formatter stringFromNumber:@(car.frontDoorStrikeJambWidth)] : @"";
    
    if (car.isThereRearDoor == 1) {
        openingHeightBackField.text = car.rearDoorOpeningHeight >= 0 ? [formatter stringFromNumber:@(car.rearDoorOpeningHeight)] : @"";
        returnWidthBackField.text = car.rearDoorSlideJambWidth >= 0 ? [formatter stringFromNumber:@(car.rearDoorSlideJambWidth)] : @"";
        strikeWidthBackField.text = car.rearDoorStrikeJambWidth >= 0 ? [formatter stringFromNumber:@(car.rearDoorStrikeJambWidth)] : @"";

        openingHeightBackField.hidden = NO;
        returnWidthBackField.hidden = NO;
        strikeWidthBackField.hidden = NO;
        
        copyButton.hidden = NO;
        backDoorLabel.hidden = NO;
        
        strikeWidthFrontField.returnKeyType = UIReturnKeyNext;
    } else {
        openingHeightBackField.hidden = YES;
        returnWidthBackField.hidden = YES;
        strikeWidthBackField.hidden = YES;
        
        copyButton.hidden = YES;
        backDoorLabel.hidden = YES;
        
        strikeWidthFrontField.returnKeyType = UIReturnKeyDone;
    }

    self.viewDescription = @"COPs\nCar Door Measurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [openingHeightFrontField becomeFirstResponder];
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
