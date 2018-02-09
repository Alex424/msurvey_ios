//
//  ExistingSurveyOperationsView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;

typedef void (^ex_survey_operation_remove_block)(void);
typedef void (^ex_survey_operation_edit_block)(void);
typedef void (^ex_survey_operation_submit_block)(void);

@interface ExistingSurveyOperationsView : UIView
{
    IBOutlet UIView * operationView;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *stateLabel;
}

@property (nonatomic) ex_survey_operation_remove_block removeBlock;
@property (nonatomic) ex_survey_operation_edit_block editBlock;
@property (nonatomic) ex_survey_operation_submit_block submitBlock;

- (IBAction)close:(id)sender;

- (IBAction)edit:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)submit:(id)sender;

+ (ExistingSurveyOperationsView*) showOnView:(UIView*) view project:(Project *)project;

@end
