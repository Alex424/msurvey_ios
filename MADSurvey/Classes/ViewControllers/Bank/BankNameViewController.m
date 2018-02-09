//
//  BankNameViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "BankNameViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface BankNameViewController () <UITextFieldDelegate>
{
    IBOutlet UITextView * bankNameTxtView;
}

@end

@implementation BankNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    bankNameTxtView.layer.cornerRadius = 8.0f;
    bankNameTxtView.inputAccessoryView = self.keyboardAccessoryView;
    [bankNameTxtView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Bank Name";

    Project *project = [DataManager sharedManager].selectedProject;
    
    indexLabel.text = [NSString stringWithFormat:@"Bank %d of %d", (int32_t)[DataManager sharedManager].currentBankIndex + 1, project.numBanks];
    
    if (project.banks.count > [DataManager sharedManager].currentBankIndex) {
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        bankNameTxtView.text = bank.name ? bank.name : @"";
    }
    
    if (![DataManager sharedManager].isEditing && [DataManager sharedManager].currentBankIndex > 0) {
        self.backButton.hidden = YES;
        self.keyboardAccessoryView.leftButton.hidden = YES;
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if (bankNameTxtView.text.length == 0) {
        [self showWarningAlert:@"Please input Bank Name!"];
        [bankNameTxtView becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;

    Bank *bank;
    if (project.banks.count > [DataManager sharedManager].currentBankIndex) {
        bank = project.banks[[DataManager sharedManager].currentBankIndex];
    } else {
        bank = [[DataManager sharedManager] createNewBankForProject:project];
    }
    
    bank.name = bankNameTxtView.text;
    
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDBankNumberCars sender:nil];
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
