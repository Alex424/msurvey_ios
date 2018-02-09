//
//  ExistingSurveyDeleteConfirmView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "SubmitConfirmView.h"

#import "DataManager.h"
#import "Constants.h"
#import "Settings.h"

@implementation SubmitConfirmView

+ (SubmitConfirmView*) showOnView:(UIView*) view_ project:(Project *)project {
    if (view_ == nil) return nil;
    
    SubmitConfirmView * opView = (SubmitConfirmView*) [[[NSBundle mainBundle] loadNibNamed:@"SubmitConfirmView" owner:nil options:nil] firstObject];
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
    opView->emailLabel.text = [Settings sharedSettings].yourEmail;
    opView->reportSwitch.on = [Settings sharedSettings].reportByEmail;

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
    [Settings sharedSettings].reportByEmail = reportSwitch.on;
    [[Settings sharedSettings] saveSettings];
    
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
