//
//  ProjectNumberBanksViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ProjectNumberBanksViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface ProjectNumberBanksViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField * numberBanksField;
}

@end

@implementation ProjectNumberBanksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Number of Elevator banks";
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    if (project.numBanks <= 0) {
        numberBanksField.text = @"";
    } else {
        numberBanksField.text = [NSString stringWithFormat:@"%d", project.numBanks];
    }
    
    [numberBanksField becomeFirstResponder];

}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([numberBanksField.text integerValue] <= 0) {
        [self showWarningAlert:@"Please input banks count!"];
        [numberBanksField becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    project.numBanks = (int32_t)[numberBanksField.text integerValue];
    
    [[DataManager sharedManager] saveChanges];

    [self performSegueWithIdentifier:UINavigationIDProjectNumberFloors sender:nil];
}

#pragma textfield delgate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = self.keyboardAccessoryView;
    
    return YES;
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
