//
//  InteriorCarFrontReturnMeasurementsOtherViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarFrontReturnMeasurementsOtherViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarFrontReturnMeasurementsOtherViewController ()

@end

@implementation InteriorCarFrontReturnMeasurementsOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    otherTextView.inputAccessoryView = self.keyboardAccessoryView;
    
    otherTextView.layer.cornerRadius = 8.0f;

}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if (otherTextView.text.length == 0) {
        [self showWarningAlert:@"Please input measurement!"];
        return;
    }
    
    
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    door.otherFrontReturnMeasurements = otherTextView.text;
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDInteriorOtherTransom sender:nil];
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
    otherTextView.text = door.otherFrontReturnMeasurements ? door.otherFrontReturnMeasurements : @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [otherTextView becomeFirstResponder];
}

@end
