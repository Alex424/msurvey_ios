//
//  InteriorCarCountViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 7/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarCountViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarCountViewController () <UITextFieldDelegate>

@end

@implementation InteriorCarCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    carCountTextField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [carCountTextField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car Count";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
    }

    carCountTextField.text = bank.numOfInteriorCar > 0 ? [NSString stringWithFormat:@"%d", bank.numOfInteriorCar] : @"";
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSInteger count = [carCountTextField.text integerValue];
    if (count <= 0) {
        [self showWarningAlert:@"Please input Number of Elevator Cars!"];
        [carCountTextField becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    bank.numOfInteriorCar = (int32_t)count;
    
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDInteriorCarDescription sender:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
