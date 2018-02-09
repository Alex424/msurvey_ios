//
//  MADNavigationController.m
//  MADSurvey
//
//  Created by seniorcoder on 5/29/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADNavigationController.h"
#import "NewSurveyViewController.h"
#import "ExistingSurveysViewController.h"
#import "SettingsViewController.h"
#import "DataManager.h"
#import "StopSurveyConfirmView.h"
#import "SubmitProjectViewController.h"

#define NAV_TITLE_FONT_SIZE         22
#define NAV_SUBTITLE_FONT_SIZE      12

@interface MADNavigationController ()
{
    UILabel * _titleLabel;
}
@end

@implementation MADNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    
    UIButton * logoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoImageView addTarget:self action:@selector(stopSurvey:) forControlEvents:UIControlEventTouchUpInside];
    [logoImageView setImage:[UIImage imageNamed:@"img_header_logo"] forState:UIControlStateNormal];
    logoImageView.adjustsImageWhenHighlighted = NO;
    logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationBar addSubview:logoImageView];
    
    NSMutableArray * constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[logoImageView(==36)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logoImageView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[logoImageView(==36)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(logoImageView)]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navigationBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.navigationBar addConstraints:constraints];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont systemFontOfSize:NAV_TITLE_FONT_SIZE]];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.lineBreakMode = NSLineBreakByClipping;
    [self.navigationBar addSubview:_titleLabel];
    
    constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_titleLabel(>=100,<=300)]-(>=76)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navigationBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.navigationBar addConstraints:constraints];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_back"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageNamed:@"navbar_shadow"]];
    
    [self.toolbar setShadowImage:[UIImage imageNamed:@"toolbar_shadow"] forToolbarPosition:UIBarPositionBottom];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:@""];
    self.topViewController.title = @"";
    
    if (![DataManager sharedManager].selectedProject || [self.topViewController isKindOfClass:[SubmitProjectViewController class]]) {
        _titleLabel.text = title;
    } else {
        _titleLabel.text = [[DataManager sharedManager].selectedProject.name stringByAppendingFormat:@"%@\n%@", [DataManager sharedManager].isEditing ? @":Edit" : @"", title];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)stopSurvey:(id)sender {
    [self.view endEditing:NO];
    
    StopSurveyConfirmView *conView = [StopSurveyConfirmView showOnView:self.view];
    if (conView) {
        conView.yesBlock = ^(void) {
            [self popToRootViewControllerAnimated:YES];
        };
    }
}


- (void)expandTitle:(BOOL)expand {
    _titleLabel.numberOfLines = expand ? 0 : 1;
    
    NSArray *lines = [_titleLabel.text componentsSeparatedByString:@"\n"];
    if (lines.count == 0) {
        return;
    }
    
    if (!expand) {
        _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_titleLabel.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:NAV_TITLE_FONT_SIZE]}];
        return;
    }

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[[lines firstObject] stringByAppendingString:@"\n"] attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:NAV_SUBTITLE_FONT_SIZE]}];
    if (lines.count > 1) {
        [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[lines[1] stringByAppendingString:@"\n"] attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:NAV_SUBTITLE_FONT_SIZE]}]];
        if (lines.count > 2) {
            [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:lines[2] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:NAV_SUBTITLE_FONT_SIZE]}]];
        }
    }
    
    _titleLabel.attributedText = text;
}

@end
