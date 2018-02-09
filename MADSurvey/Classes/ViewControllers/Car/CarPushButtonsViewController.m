//
//  CarPushButtonsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarPushButtonsViewController.h"
#import "Constants.h"
#import "HelpView.h"
#import "DataManager.h"

@interface CarPushButtonsViewController () <UITextFieldDelegate>

@end

@implementation CarPushButtonsViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    buttonNoField.inputAccessoryView = self.keyboardAccessoryView;
    floorMarkingField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Push Buttons";

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
    
    buttonNoField.text = car.numberOfOpenings > 0 ? [NSString stringWithFormat:@"%d", car.numberOfOpenings] : @"";
    floorMarkingField.text = car.floorMarkings ? car.floorMarkings : @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [buttonNoField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([buttonNoField isFirstResponder]) {
        [floorMarkingField becomeFirstResponder];
    } else {
        NSInteger buttonNo = [buttonNoField.text integerValue];
        NSString *floorMarking = floorMarkingField.text;
        
        if (buttonNo <= 0) {
            [self showWarningAlert:@"Please input Number Of PushButtons!"];
            [buttonNoField becomeFirstResponder];
            return;
        }
        
        if (floorMarking.length == 0) {
            [self showWarningAlert:@"Please input Floor Marking!"];
            [floorMarkingField becomeFirstResponder];
            return;
        }
        
        Car *car = [DataManager sharedManager].currentCar;
        car.numberOfOpenings = (int32_t)buttonNo;
        car.floorMarkings = floorMarking;

        [self performSegueWithIdentifier:UINavigationIDCarDoorMeasurements sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Push Buttons" withImageName:@"img_help_27_car_pushbuttons_help"];
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
