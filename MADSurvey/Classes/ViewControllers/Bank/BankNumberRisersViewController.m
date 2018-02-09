//
//  BankNumberRisersViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "BankNumberRisersViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface BankNumberRisersViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField * bankNumberRisersField;
}

@end

@implementation BankNumberRisersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    bankNumberRisersField.inputAccessoryView = self.keyboardAccessoryView;
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [bankNumberRisersField becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Bank Number Risers";
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    indexLabel.text = [NSString stringWithFormat:@"Bank %d of %d", (int32_t)[DataManager sharedManager].currentBankIndex + 1, project.numBanks];
    
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if (bank.numOfRiser > 0) {
        bankNumberRisersField.text = [NSString stringWithFormat:@"%d", bank.numOfRiser];
    } else {
        bankNumberRisersField.text = @"";
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([bankNumberRisersField.text integerValue] <= 0) {
        [self showWarningAlert:@"Please input risers count!"];
        [bankNumberRisersField becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    bank.numOfRiser = (int32_t)[bankNumberRisersField.text integerValue];
    
    [[DataManager sharedManager] saveChanges];

    [self performSegueWithIdentifier:UINavigationIDBankNotes sender:nil];
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
