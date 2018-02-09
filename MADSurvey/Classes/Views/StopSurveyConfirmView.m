//
//  StopSurveyConfirmView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "StopSurveyConfirmView.h"

@implementation StopSurveyConfirmView

+ (StopSurveyConfirmView*) showOnView:(UIView*) view_ {
    if (view_ == nil) return nil;
    
    StopSurveyConfirmView * opView = (StopSurveyConfirmView*) [[[NSBundle mainBundle] loadNibNamed:@"StopSurveyConfirmView" owner:nil options:nil] firstObject];
    opView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view_ addSubview:opView];
    
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
