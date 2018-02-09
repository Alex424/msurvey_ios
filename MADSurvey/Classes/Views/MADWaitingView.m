//
//  HelpView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADWaitingView.h"
#import "Constants.h"

@interface MADWaitingView ()

@end

@implementation MADWaitingView

+ (MADWaitingView *)showOnView:(UIView *)view_ withTitle:(NSString *)title {
    if (view_ == nil) return nil;
    
    MADWaitingView * opView = (MADWaitingView *) [[[NSBundle mainBundle] loadNibNamed:@"MADWaitingView" owner:nil options:nil] firstObject];
    opView->titleLabel.text = title;
    opView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view_ addSubview:opView];
    
    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [view_ addConstraints:constraints];
    
    [view_ layoutIfNeeded];
    
    return opView;
}

- (void)dismiss {
    [self removeFromSuperview];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
    coverView.layer.cornerRadius = 8.0f;
    coverView.clipsToBounds = YES;
}

@end
