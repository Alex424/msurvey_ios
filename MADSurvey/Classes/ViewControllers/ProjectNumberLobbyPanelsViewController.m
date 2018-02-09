//
//  ProjectNumberLobbyPanelsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ProjectNumberLobbyPanelsViewController.h"
#import "Constants.h"
#import "LobbyLocationViewController.h"
#import "BankNameViewController.h"
#import "DataManager.h"

@interface ProjectNumberLobbyPanelsViewController ()<UITextFieldDelegate>
{
    IBOutlet UITextField * numberPanelsField;

}

@end

@implementation ProjectNumberLobbyPanelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [numberPanelsField becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([numberPanelsField.text integerValue] <= 0) {
        [self showWarningAlert:@"Please input LobbyPanels count!"];
        [numberPanelsField becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    project.numLobbyPanels = (int32_t)[numberPanelsField.text integerValue];
    
    [[DataManager sharedManager] saveChanges];
    
    if (project.lobbyPanels == 1) {
        [DataManager sharedManager].currentLobbyIndex = 0;

        LobbyLocationViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"LobbyLocationViewController"];
        [self.navigationController pushViewController:lvc animated:YES];
    } else {
        [DataManager sharedManager].currentBankIndex = 0;

        BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Number of Panels";
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    if (project.numLobbyPanels <= 0) {
        numberPanelsField.text = @"";
    } else {
        numberPanelsField.text = [NSString stringWithFormat:@"%d", project.numLobbyPanels];
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
