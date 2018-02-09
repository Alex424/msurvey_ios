//
//  CarDescriptionViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarDescriptionViewController.h"
#import "Constants.h"   
#import "DataManager.h"

@interface CarDescriptionViewController () <UITextFieldDelegate>

@end

@implementation CarDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    descField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Description";

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    Car *car = [[DataManager sharedManager] getCarForBank:bank carNum:[DataManager sharedManager].currentCarNum];
    [DataManager sharedManager].currentCar = car;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d", (int32_t)[DataManager sharedManager].currentCarNum + 1, bank.numOfCar];
        
        if ([DataManager sharedManager].currentCarNum > 0) {
            self.backButton.hidden = YES;
            self.keyboardAccessoryView.leftButton.hidden = YES;
        }
    }
    
    descField.text = car.carNumber ? car.carNumber : @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [descField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSString *desc = descField.text;
    if (desc.length == 0) {
        [self showWarningAlert:@"Please input Car Descriptor!"];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    Car *car = [[DataManager sharedManager] createNewCarForBank:bank carNum:[DataManager sharedManager].currentCarNum carNumber:desc];
    [DataManager sharedManager].currentCar = car;
    
    [[DataManager sharedManager] saveChanges];

    [self performSegueWithIdentifier:UINavigationIDCarLicense sender:nil];
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
