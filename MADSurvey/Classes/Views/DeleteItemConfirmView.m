//
//  StopSurveyConfirmView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "DeleteItemConfirmView.h"

@implementation DeleteItemConfirmView

+ (DeleteItemConfirmView*) showOnView:(UIView*) view_ title:(NSString *)title subtitle:(NSString *)subtitle description:(NSString *)description {
    if (view_ == nil) return nil;
    
    DeleteItemConfirmView * opView = (DeleteItemConfirmView*) [[[NSBundle mainBundle] loadNibNamed:@"DeleteItemConfirmView" owner:nil options:nil] firstObject];
    opView.translatesAutoresizingMaskIntoConstraints = NO;
    
    opView->titleLabel.text = title;
    opView->subtitleLabel.text = subtitle;
    opView->descriptionLabel.text = description;
    
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
