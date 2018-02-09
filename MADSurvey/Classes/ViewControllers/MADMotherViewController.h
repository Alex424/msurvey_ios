//
//  MADMotherViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 5/29/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MADNavigationView.h"
#import "Constants.h"
#import "HelpView.h"
#import "AppDelegate.h"

@class Lantern;

typedef NS_ENUM(NSUInteger, UIToolbarType) {
    UIToolbarTypeNormal,    // back & next
    UIToolbarTypeNoNext,    // only back
    UIToolbarTypeSave,      // back & save
    UIToolbarTypeSubmit,    // back & submit
    UIToolbarTypeAdd,       // back & add
    UIToolbarTypeCenterHelp, // back help next
    UIToolbarTypeCenterCamera,  // back cam next
};

@interface MADMotherViewController : UITableViewController
{
    IBOutletCollection(UILabel) NSArray *doorLabels;
    IBOutlet UILabel *titleLabel;
}

@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *editConstraints;

@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UIButton * nextButton;

@property (nonatomic) NSUInteger toolbarType;
@property (nonatomic, strong) MADNavigationView * keyboardAccessoryView;

- (IBAction)center:(id)sender;

- (void)layoutHeader;

- (void)showWarningAlert:(NSString *)message;

- (void)backToSpecificViewController:(UIViewController *)viewController;
- (void)backToSpecificViewController:(UIViewController *)viewController class:(Class)type;
- (void)backToSpecificClass:(Class)aClass;

- (NSString *)helpImageForLantern:(Lantern *)lantern;

- (void)updateToolbar;
- (void)setViewDescription:(NSString *)description;

- (NSArray *)textFields;
- (BOOL)isLastFocused;

@end
