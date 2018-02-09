//
//  ExistingSurveyCell.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ExistingSurveyCell.h"
#import "Project+CoreDataClass.h"
#import "Constants.h"

@implementation ExistingSurveyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setProject:(Project *)project {
    _project = project;
    
    projNameLabel.text = project.name;
    submitDateLabel.text = project.surveyDate;
    
    NSString *state;
    if ([project.status isEqualToString:StatusSubmitted]) {
        state = @"Submitted";
        submitStateLabel.textColor = [UIColor whiteColor];
    } else {
        state = @"Not Submitted";
        submitStateLabel.textColor = UIListSelectionColor;
    }
    submitStateLabel.text = state;
}

@end
