//
//  SettingsViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"
#import "OptionButton.h"

@interface SettingsViewController : MADMotherViewController
{
    IBOutlet UITextField * nameField;
    IBOutlet UITextField * emailField;
    IBOutlet UITextField * companyField;
    IBOutlet UITextField * phoneField;
    IBOutlet UITextField * stateField;
    
    IBOutlet OptionButton *unitInchButton;
    IBOutlet OptionButton *unitCentiButton;
}

- (IBAction)unitInch:(id)sender;
- (IBAction)unitCenti:(id)sender;

@end
