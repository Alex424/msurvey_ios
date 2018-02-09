//
//  CarCopNameViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarCopNameViewController.h"
#import "DataManager.h"

@interface CarCopNameViewController () <UITextFieldDelegate>

@end

@implementation CarCopNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nameField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car COP Name";

    Project *project = [DataManager sharedManager].selectedProject;
    Car *car = [DataManager sharedManager].currentCar;

    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        if ([DataManager sharedManager].currentCopNum > 0) {
            self.backButton.hidden = YES;
            self.keyboardAccessoryView.leftButton.hidden = YES;
        }
    }
    carLabel.text = [NSString stringWithFormat:@"COP %d of %d - %@", (int32_t)[DataManager sharedManager].currentCopNum + 1, car.numberOfCops, car.carNumber];
    
    Cop *cop = [[DataManager sharedManager] getCopForCar:car copNum:[DataManager sharedManager].currentCopNum];
    [DataManager sharedManager].currentCop = cop;
    
    if (cop.copName) {
        nameField.text = cop.copName;
    } else if ([DataManager sharedManager].currentCopNum == 0) {
        nameField.text = @"MAIN COP";
    } else {
        nameField.text = [NSString stringWithFormat:@"AUX COP %d", (int)[DataManager sharedManager].currentCopNum];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [nameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSString *name = nameField.text;
    
    if (name.length == 0) {
        [self showWarningAlert:@"Please input Car COP Name!"];
        [nameField becomeFirstResponder];
        return;
    }
    
    Cop *cop = [DataManager sharedManager].currentCop;
    if (!cop) {
        Car *car = [DataManager sharedManager].currentCar;
        Cop *firstCop = [[DataManager sharedManager] getCopForCar:car copNum:0];

        cop = [[DataManager sharedManager] createNewCopForCar:car copNum:[DataManager sharedManager].currentCopNum copName:name];
        if (firstCop) {
            cop.options = firstCop.options;
            cop.returnHinging = firstCop.returnHinging;
            
            cop.returnPanelWidth = firstCop.returnPanelWidth;
            cop.returnPanelHeight = firstCop.returnPanelHeight;
            cop.coverWidth = firstCop.coverWidth;
            cop.coverHeight = firstCop.coverHeight;
            cop.coverToOpening = firstCop.coverToOpening;
            cop.coverAff = firstCop.coverAff;
            
            cop.swingPanelWidth = firstCop.swingPanelWidth;
            cop.swingPanelHeight = firstCop.swingPanelHeight;
            cop.coverAff = firstCop.coverAff;
            
            cop.notes = firstCop.notes;
        }

        [DataManager sharedManager].currentCop = cop;
    } else {
        cop.copName = name;
    }
        
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDCarCopStyle sender:nil];
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
    if (textField == nameField) {
        [self next:nil];
    }
    
    return YES;
}

@end
