//
//  ExistingSurveyDeleteConfirmView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^stop_survey_yes_block)(void);

@interface StopSurveyConfirmView : UIView
{
    IBOutlet UIView * confirmView;
}

@property (nonatomic) stop_survey_yes_block yesBlock;

- (IBAction)close:(id)sender;

- (IBAction)yes:(id)sender;
- (IBAction)no:(id)sender;

+ (StopSurveyConfirmView*) showOnView:(UIView*) view;

@end
