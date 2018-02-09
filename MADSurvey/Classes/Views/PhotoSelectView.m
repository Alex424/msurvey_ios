//
//  PhotoSelectView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "PhotoSelectView.h"

@implementation PhotoSelectView

+ (PhotoSelectView*) showOnView:(UIView*) view_ {
    if (view_ == nil) return nil;
    
    PhotoSelectView * opView = (PhotoSelectView*) [[[NSBundle mainBundle] loadNibNamed:@"PhotoSelectView" owner:nil options:nil] firstObject];
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

- (IBAction)camera:(id)sender {
    [self close:sender];
    if (self.cameraBlock) {
        self.cameraBlock();
        self.cameraBlock = nil;
    }
}

- (IBAction)gallery:(id)sender {
    [self close:sender];
    if (self.galleryBlock) {
        self.galleryBlock();
        self.galleryBlock = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    selectView.layer.cornerRadius = 8;
}

@end
