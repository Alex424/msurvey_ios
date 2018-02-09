//
//  CarLicenseViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface CarLicenseViewController : MADMotherViewController  <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    IBOutlet UITextField * installNoField;
    IBOutlet UITextField * capacityNoField;
    IBOutlet UITextField * peopleNoField;
    
    IBOutlet UIButton * weightButton;
}

- (IBAction)kg:(id)sender;

@end
