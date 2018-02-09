//
//  ProjectNumberFloorsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ProjectNumberFloorsViewController.h"

#import "BankNameViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface ProjectNumberFloorsViewController ()<UITextFieldDelegate>
{
    IBOutlet UITextField * numberFloorsField;
}


@end

@implementation ProjectNumberFloorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [numberFloorsField becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([numberFloorsField.text integerValue] <= 0) {
        [self showWarningAlert:@"Please input floors count!"];
        [numberFloorsField becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    project.numFloors = (int32_t)[numberFloorsField.text integerValue];
    
    [[DataManager sharedManager] saveChanges];
    
    if (project.lobbyPanels == 0) {
        project.numLobbyPanels = 0;

        [DataManager sharedManager].currentBankIndex = 0;
        
        BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
        [self.navigationController pushViewController:lvc animated:YES];
    } else {
        [self performSegueWithIdentifier:UINavigationIDProjectNumberLobbyPanels sender:nil];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Number of Floors";
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    if (project.numFloors <= 0) {
        numberFloorsField.text = @"";
    } else {
        numberFloorsField.text = [NSString stringWithFormat:@"%d", project.numFloors];
    }
}


#pragma textfield delgate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = self.keyboardAccessoryView;
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
