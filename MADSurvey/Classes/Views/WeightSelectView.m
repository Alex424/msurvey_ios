//
//  WeightSelectView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "WeightSelectView.h"

@implementation WeightSelectView

+ (WeightSelectView*) showOnView:(UIView*) view_ {
    if (view_ == nil) return nil;
    
    WeightSelectView * opView = (WeightSelectView*) [[[NSBundle mainBundle] loadNibNamed:@"WeightSelectView" owner:nil options:nil] firstObject];
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

- (IBAction)kg:(id)sender {
    [self close:sender];
    if (self.kgBlock) {
        self.kgBlock();
        self.kgBlock = nil;
    }
}

- (IBAction)lbs:(id)sender {
    [self close:sender];
    if (self.lbsBlock) {
        self.lbsBlock();
        self.lbsBlock = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    selectView.layer.cornerRadius = 8;
}

@end
