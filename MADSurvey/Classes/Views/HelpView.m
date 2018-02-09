//
//  HelpView.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HelpView.h"
#import "Constants.h"

@interface HelpView () <UIScrollViewDelegate> {
    UIImageView *helpImageView;
}

@end

@implementation HelpView

+ (HelpView*) showOnView:(UIView*) view_ withTitle:(NSString *)title withImageName:(NSString *)imageName {
    if (view_ == nil) return nil;
    
    HelpView * opView = (HelpView*) [[[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:nil options:nil] firstObject];
    opView->helpImageView.image = [UIImage imageNamed:imageName];
    opView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // check if the guide is shown
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:KeyIsHelpGuideShown] boolValue] == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:KeyIsHelpGuideShown];
    } else {
        opView.guideView.hidden = YES;
    }
    
    [view_ addSubview:opView];
    
    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[opView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(opView)]];
    [view_ addConstraints:constraints];
    
    opView.titleLabel.text = title;
    [view_ layoutIfNeeded];
    [opView resizeImageView];
    
    return opView;
}

- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)guideTapped:(id)sender {
    self.guideView.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        tipLabel.font = [UIFont systemFontOfSize:28.0f];
    }
    
    formView.layer.cornerRadius = 8.0f;
    formView.layer.borderColor = [UIColor whiteColor].CGColor;
    formView.layer.borderWidth = 8.0f;
    formView.clipsToBounds = YES;
    
    helpImageView = [[UIImageView alloc] init];
    
    [helpScrollView addSubview:helpImageView];
}

- (void)resizeImageView {
    if (!helpImageView.image) {
        return;
    }
    
    [helpImageView setFrame:helpScrollView.bounds];
    [helpScrollView setContentSize:helpImageView.bounds.size];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return helpImageView;
}

@end
