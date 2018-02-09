//
//  ExistingSurveyDeleteConfirmView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;

typedef void (^ex_survey_delete_yes_block)(void);

@interface SubmitConfirmView : UIView
{
    IBOutlet UIView * confirmView;

    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *stateLabel;
    IBOutlet UILabel *emailLabel;
    IBOutlet UISwitch *reportSwitch;
}

@property (nonatomic) ex_survey_delete_yes_block yesBlock;

- (IBAction)close:(id)sender;

- (IBAction)yes:(id)sender;
- (IBAction)no:(id)sender;

+ (SubmitConfirmView*) showOnView:(UIView*) view project:(Project *)project;

@end
