//
//  CarMeasurementsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarMeasurementsViewController.h"
#import "Constants.h"
#import "HelpView.h"
#import "DataManager.h"

@interface CarMeasurementsViewController () <UITextFieldDelegate>

@end

@implementation CarMeasurementsViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNormal;
    [super viewDidLoad];
    
    heightFromFloorField.inputAccessoryView = self.keyboardAccessoryView;
    distFromWallField.inputAccessoryView = self.keyboardAccessoryView;
    distFromReturnField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Handrail Measurement";

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

    heightFromFloorField.text = car.handRailHeightFromFloor >= 0 ? [formatter stringFromNumber:@(car.handRailHeightFromFloor)] : @"";
    distFromWallField.text = car.handRailDistanceFromWall >= 0 ? [formatter stringFromNumber:@(car.handRailDistanceFromWall)] : @"";
    distFromReturnField.text = car.handRailDistanceFromReturn >= 0 ? [formatter stringFromNumber:@(car.handRailDistanceFromReturn)] : @"";
    
    self.viewDescription = @"COPs\nHandrail Measurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [heightFromFloorField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([heightFromFloorField isFirstResponder]) {
        [distFromWallField becomeFirstResponder];
    } else if ([distFromWallField isFirstResponder]) {
        [distFromReturnField becomeFirstResponder];
    } else {
        double heightFromFloor = [heightFromFloorField.text doubleValueCheckingEmpty];
        double distFromWall = [distFromWallField.text doubleValueCheckingEmpty];
        double distFromReturn = [distFromReturnField.text doubleValueCheckingEmpty];
        
        if (heightFromFloor < 0) {
            [self showWarningAlert:@"Please input Height from floor!"];
            [heightFromFloorField becomeFirstResponder];
            return;
        }
        if (distFromWall < 0) {
            [self showWarningAlert:@"Please input Distance from wall!"];
            [distFromWallField becomeFirstResponder];
            return;
        }
        if (distFromReturn < 0) {
            [self showWarningAlert:@"Please input Distance from return!"];
            [distFromReturnField becomeFirstResponder];
            return;
        }
        
        Car *car = [DataManager sharedManager].currentCar;
        
        car.handRailHeightFromFloor = heightFromFloor;
        car.handRailDistanceFromWall = distFromWall;
        car.handRailDistanceFromReturn = distFromReturn;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDCarNotes sender:nil];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
