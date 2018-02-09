//
//  ExistingSurveyOperationsView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ExistingSurveyOperationsView.h"

#import "DataManager.h"
#import "Constants.h"

@implementation ExistingSurveyOperationsView

+ (ExistingSurveyOperationsView*) showOnView:(UIView*) view_ project:(Project *)project {
    if (view_ == nil) return nil;
    
    ExistingSurveyOperationsView * opView = (ExistingSurveyOperationsView*) [[[NSBundle mainBundle] loadNibNamed:@"ExistingSurveyOperationsView" owner:nil options:nil] firstObject];
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

- (IBAction)edit:(id)sender {
    [self close:sender];

    if (_editBlock != nil) {
        self.editBlock();
        self.editBlock = nil;
    }
}

- (IBAction)remove:(id)sender {
    [self close:sender];
    
    if (_removeBlock != nil) {
        self.removeBlock();
        self.removeBlock = nil;
    }
}

- (IBAction)submit:(id)sender {
    [self close:sender];
    
    if (_submitBlock != nil) {
        self.submitBlock();
        self.submitBlock = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    operationView.layer.cornerRadius = 8;
}

@end
