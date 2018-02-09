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

@interface ExistingSurveyDeleteConfirmView : UIView
{
    IBOutlet UIView * confirmView;

    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *stateLabel;
}

@property (nonatomic) ex_survey_delete_yes_block yesBlock;

- (IBAction)close:(id)sender;

- (IBAction)yes:(id)sender;
- (IBAction)no:(id)sender;

+ (ExistingSurveyDeleteConfirmView*) showOnView:(UIView*) view project:(Project *)project;

@end
