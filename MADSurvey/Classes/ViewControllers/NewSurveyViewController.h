//
//  NewSurveyViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 5/31/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface NewSurveyViewController : MADMotherViewController
{
    IBOutlet UITextField * projNoField;
    IBOutlet UITextField * projNameField;
    IBOutlet UITextField * companyNameField;
    IBOutlet UITextField * companyContactField;
    IBOutlet UITextField * surveyDateField;
    
    IBOutlet UIDatePicker * datePicker;
    IBOutlet UIView *datePickerView;
}

@end
