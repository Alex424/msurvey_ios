//
//  MADInfoAlert.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADWarningAlert.h"
#import <Foundation/Foundation.h>

@implementation MADWarningAlert

+ (MADWarningAlert*) showOnView:(UIView*) view_ withTitle:(NSString*) title {
    if (view_ == nil) return nil;
    
    MADWarningAlert * opView = (MADWarningAlert*) [[[NSBundle mainBundle] loadNibNamed:@"MADWarningAlert" owner:nil options:nil] firstObject];
    opView.translatesAutoresizingMaskIntoConstraints = NO;
    
    opView.titleLabel.text = title;
    
    [view_ addSubview:opView];
    
    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [view_ addConstraints:constraints];
    
    [opView performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    
    return opView;
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    alertView.layer.cornerRadius = 8;
}

@end
