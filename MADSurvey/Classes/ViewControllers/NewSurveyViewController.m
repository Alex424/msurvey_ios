//
//  NewSurveyViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 5/31/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "NewSurveyViewController.h"
#import "Constants.h"
#import "DataManager.h"
#import "Settings.h"

@interface NewSurveyViewController () <UITextFieldDelegate>

@end

@implementation NewSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    surveyDateField.inputView = datePickerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *title;
    Project *project = [DataManager sharedManager].selectedProject;
    if (project == nil) {
        title = @"New Survey\nProject Details";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        [datePicker setDate:[NSDate date]];
        surveyDateField.text = [formatter stringFromDate:datePicker.date];
        
        companyNameField.text = [Settings sharedSettings].yourCompany;
        companyContactField.text = [Settings sharedSettings].yourEmail;
    } else {
        title = @"Project Details";

        projNoField.text = project.no ? [NSString stringWithFormat:@"%d", project.no] : @"";
        projNameField.text = project.name;
        companyNameField.text = project.companyName;
        companyContactField.text = project.companyContact;
        surveyDateField.text = project.surveyDate;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        [datePicker setDate:[formatter dateFromString:project.surveyDate]];
    }
    
    self.navigationController.title = title;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [projNoField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    if ([projNoField isFirstResponder]) {
        [projNameField becomeFirstResponder];
    } else if ([projNameField isFirstResponder]) {
        [companyNameField becomeFirstResponder];
    } else if ([companyNameField isFirstResponder]) {
        [companyContactField becomeFirstResponder];
    } else if ([companyContactField isFirstResponder]) {
        [surveyDateField becomeFirstResponder];
    } else {
        NSString *no = projNoField.text;
        NSString *name = projNameField.text;
        NSString *companyName = companyNameField.text;
        NSString *companyContact = companyContactField.text;
        NSString *surveyDate = surveyDateField.text;
        
    //    if (no.length == 0) {
    //        [self showWarningAlert:@"Please input project No!"];
    //        [projNoField becomeFirstResponder];
    //        return;
    //    }
        if (name.length == 0) {
            [self showWarningAlert:@"Please input project Name!"];
            [projNameField becomeFirstResponder];
            return;
        }
        
        Project *project = [DataManager sharedManager].selectedProject;
    //    if (!project || project.no != [no integerValue]) {
    //        if ([[DataManager sharedManager] checkDuplicateProjectNo:[no integerValue]]) {
    //            [self showWarningAlert:@"Please input another project No!"];
    //            [projNoField becomeFirstResponder];
    //            return;
    //        }
    //    }
        
        if (!project) {
            project = [[DataManager sharedManager] createNewProject];
            [DataManager sharedManager].selectedProject = project;
        }

        project.no = (int32_t)[no integerValue];
        project.name = name;
        project.companyName = companyName;
        project.companyContact = companyContact;
        project.surveyDate = surveyDate;
        project.scaleUnit = ([Settings sharedSettings].units == ProjectSettingUnitsInches) ? @"inch" : @"centimeter";
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDProjectsItemsSurvey sender:nil];
    }
}

#pragma textfield delgate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.inputAccessoryView = self.keyboardAccessoryView;
    return YES;
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


- (IBAction)didSelectDate:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    surveyDateField.text = [formatter stringFromDate:datePicker.date];
}

@end
