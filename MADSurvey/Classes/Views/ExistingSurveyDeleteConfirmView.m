//
//  ExistingSurveyDeleteConfirmView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ExistingSurveyDeleteConfirmView.h"

#import "DataManager.h"
#import "Constants.h"

@implementation ExistingSurveyDeleteConfirmView

+ (ExistingSurveyDeleteConfirmView*) showOnView:(UIView*) view_ project:(Project *)project {
    if (view_ == nil) return nil;
    
    ExistingSurveyDeleteConfirmView * opView = (ExistingSurveyDeleteConfirmView*) [[[NSBundle mainBundle] loadNibNamed:@"ExistingSurveyDeleteConfirmView" owner:nil options:nil] firstObject];
    opView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view_ addSubview:opView];
    
    opView->nameLabel.text = project.name;
    opView->dateLabel.text = project.surveyDate;
    
    NSString *state;
    if ([project.status isEqualToString:StatusSubmitted]) {
        state = @"Submitted";
    } else {
        state = @"Not Submitted";
    }
    opView->stateLabel.text = state;

    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [view_ addConstraints:constraints];
    
    return opView;
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)yes:(id)sender {
    [self close:sender];
    if (self.yesBlock) {
        self.yesBlock();
        self.yesBlock = nil;
    }
}

- (IBAction)no:(id)sender {
    [self close:sender];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    confirmView.layer.cornerRadius = 8;    
}

@end
