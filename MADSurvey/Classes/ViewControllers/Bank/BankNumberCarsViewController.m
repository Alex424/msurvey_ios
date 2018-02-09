//
//  BankNumberCarsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "BankNumberCarsViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface BankNumberCarsViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField * bankNumberCarsField;
}
@end

@implementation BankNumberCarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    bankNumberCarsField.inputAccessoryView = self.keyboardAccessoryView;

}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [bankNumberCarsField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Bank Number Cars";
    
    Project *project = [DataManager sharedManager].selectedProject;

    indexLabel.text = [NSString stringWithFormat:@"Bank %d of %d", (int32_t)[DataManager sharedManager].currentBankIndex + 1, project.numBanks];

    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    if (bank.numOfCar > 0) {
        bankNumberCarsField.text = [NSString stringWithFormat:@"%d", bank.numOfCar];
    } else {
        bankNumberCarsField.text = @"";
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([bankNumberCarsField.text integerValue] <= 0) {
        [self showWarningAlert:@"Please input cars count!"];
        [bankNumberCarsField becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    bank.numOfCar = (int32_t)[bankNumberCarsField.text integerValue];
    
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDBankNumberRisers sender:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
