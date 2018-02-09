//
//  MADInfoAlert.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADInfoAlert.h"

@implementation MADInfoAlert

+ (MADInfoAlert*) showOnView:(UIView*) view_ withTitle:(NSString*) title subTitle:(NSString*)subtitle description:(NSString*) desc {
    if (view_ == nil) return nil;
    
    MADInfoAlert * opView = (MADInfoAlert*) [[[NSBundle mainBundle] loadNibNamed:@"MADInfoAlert" owner:nil options:nil] firstObject];
    opView.translatesAutoresizingMaskIntoConstraints = NO;
    
    opView.titleLabel.text = title;
    opView.subtitleLabel.text = subtitle;
    opView.descLabel.text = desc;
    
    [view_ addSubview:opView];
    
    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [view_ addConstraints:constraints];
    
    return opView;
}

- (IBAction)ok:(id)sender {
    [self removeFromSuperview];
    
    if (self.okBlock) {
        self.okBlock();
        self.okBlock = nil;
    }
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
    
    if (self.closeBlock) {
        self.closeBlock();
        self.closeBlock = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    alertView.layer.cornerRadius = 8;
}

@end
