//
//  SettingsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController () <UITextFieldDelegate>

@end

@implementation SettingsViewController

- (IBAction)unitInch:(id)sender {
    UIButton * b = (UIButton*) sender;
    b.selected = !b.selected;
    
    unitCentiButton.selected = NO;
}

- (IBAction)unitCenti:(id)sender {
    UIButton * b = (UIButton*) sender;
    b.selected = !b.selected;    

    unitInchButton.selected = NO;
}

- (void)viewDidLoad {
    // set the toolbartype here
    self.toolbarType = UIToolbarTypeSave;

    [super viewDidLoad];
    
    unitInchButton.imageSelected = [UIImage imageNamed:@"ic_checkbox_tick_checked"];
    unitCentiButton.imageSelected = [UIImage imageNamed:@"ic_checkbox_tick_checked"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Settings";
    
    Settings *settings = [Settings sharedSettings];
    
    nameField.text = settings.yourName;
    emailField.text = settings.yourEmail;
    companyField.text = settings.yourCompany;
    phoneField.text = settings.yourPhone;
    stateField.text = settings.yourState;
    
    if (settings.units == ProjectSettingUnitsInches) {
        unitInchButton.selected = YES;
        unitCentiButton.selected = NO;
    } else {
        unitInchButton.selected = NO;
        unitCentiButton.selected = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [nameField becomeFirstResponder];
}

#pragma textfield delgate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = self.keyboardAccessoryView;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == nameField) {
        [emailField becomeFirstResponder];
    } else if (textField == emailField) {
        [companyField becomeFirstResponder];
    } else if (textField == companyField) {
        [phoneField becomeFirstResponder];
    } else if (textField == phoneField) {
        [stateField becomeFirstResponder];
    } else if (textField == stateField) {
        [stateField resignFirstResponder];
    }
    
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

- (IBAction)next:(id)sender {
    Settings *settings = [Settings sharedSettings];
    
    settings.yourName = nameField.text;
    settings.yourEmail = emailField.text;
    settings.yourCompany = companyField.text;
    settings.yourPhone = phoneField.text;
    settings.yourState = stateField.text;
    if (unitInchButton.selected) {
        settings.units = ProjectSettingUnitsInches;
    } else {
        settings.units = ProjectSettingUnitsCentimeters;
    }
    
    [settings saveSettings];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
