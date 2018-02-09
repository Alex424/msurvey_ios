//
//  MADMotherViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 5/29/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "MADNavigationController.h"

@interface MADMotherViewController () <UIScrollViewDelegate>
{
    BOOL didLayout;
    BOOL isAppearing;
    BOOL hadFocus;
}
@end

@implementation MADMotherViewController

- (void)setToolbarType:(NSUInteger)toolbarType {
    _toolbarType = toolbarType;
    
    if (_toolbarType == UIToolbarTypeNoNext) {
        
    }
}

- (void)configToolbarWithType:(UIToolbarType) type {
    _toolbarType = type;

    // check type and change toolbars
    
    UIButton * centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    centerButton.backgroundColor = [UIColor clearColor];
    centerButton.layer.cornerRadius = 6.0f;
    [centerButton setFrame:CGRectMake(0, 0, 44, 44)];
    [centerButton addTarget:self action:@selector(center:) forControlEvents:UIControlEventTouchUpInside];
    [centerButton setImage:[UIImage imageNamed:@"ic_help_red_btn"] forState:UIControlStateNormal];
    
    UIBarButtonItem * centerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:centerButton];
    
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor whiteColor];
    backButton.layer.cornerRadius = 6.0f;
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, 80, 36)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"ic_grey_left_indicator"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    self.backButton = backButton;
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    if (_toolbarType == UIToolbarTypeNoNext) {
        UIBarButtonItem * spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolbarItems = @[backBarButtonItem, spaceBarButtonItem];

    } else {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.backgroundColor = [UIColor whiteColor];
        _nextButton.layer.cornerRadius = 6.0f;
        
        CGFloat width = 80;
        CGFloat offset = 20;
        
        if (_toolbarType == UIToolbarTypeSave) {
            [_nextButton setTitle:@"Save" forState:UIControlStateNormal];
        } else if (_toolbarType == UIToolbarTypeSubmit) {
            [_nextButton setTitle:@"Submit" forState:UIControlStateNormal];
            width = 100;
            offset = 25;
        } else if (_toolbarType == UIToolbarTypeAdd) {
            [_nextButton setTitle:@"Add" forState:UIControlStateNormal];
            width = 70;
            offset = 10;
        } else {
            [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
        }
        
        [_nextButton setFrame:CGRectMake(0, 0, width, 36)];
        [_nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setImage:[UIImage imageNamed:@"ic_grey_right_indicator"] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nextButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, - width - offset)];
        [_nextButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        
        UIBarButtonItem * nextBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_nextButton];
        
        UIBarButtonItem * spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
        if (_toolbarType == UIToolbarTypeCenterHelp) {
            UIBarButtonItem * spaceBarButtonItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

            self.toolbarItems = @[backBarButtonItem, spaceBarButtonItem, centerBarButtonItem, spaceBarButtonItem1, nextBarButtonItem];
        } else {
            self.toolbarItems = @[backBarButtonItem, spaceBarButtonItem, nextBarButtonItem];
        }
        
    }
    
    self.keyboardAccessoryView = (MADNavigationView*)[[[NSBundle mainBundle] loadNibNamed:@"MADNavigationView" owner:self options:nil] firstObject];
    self.keyboardAccessoryView.leftButton.layer.cornerRadius = 6.0f;
    self.keyboardAccessoryView.rightButton.layer.cornerRadius = 6.0f;
    
    [self.keyboardAccessoryView.leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    [self.keyboardAccessoryView.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -90)];
    [self.keyboardAccessoryView.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    [self.keyboardAccessoryView.leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardAccessoryView.rightButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardAccessoryView.centerButton addTarget:self action:@selector(center:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_toolbarType == UIToolbarTypeNoNext) {
        //self.keyboardAccessoryView.rightButton.hidden = YES;
    } else {
        if (_toolbarType == UIToolbarTypeSave) {
            [self.keyboardAccessoryView.rightButton setTitle:@"Save" forState:UIControlStateNormal];
        } else if (_toolbarType == UIToolbarTypeSubmit) {
            [self.keyboardAccessoryView.rightButton setTitle:@"Submit" forState:UIControlStateNormal];
        } else if (_toolbarType == UIToolbarTypeAdd) {
            [self.keyboardAccessoryView.rightButton setTitle:@"Add" forState:UIControlStateNormal];
        } else if (_toolbarType == UIToolbarTypeCenterHelp) {
            self.keyboardAccessoryView.centerButton.backgroundColor = [UIColor clearColor];
            self.keyboardAccessoryView.centerButton.hidden = NO;
            [self.keyboardAccessoryView.centerButton setImage:[UIImage imageNamed:@"ic_help_red_btn"] forState:UIControlStateNormal];
        }
    }
    
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"gray"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)layoutHeader {
    UIView * header = self.tableView.tableHeaderView;
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    header.frame = CGRectMake(0, 0, header.frame.size.width, height);
    self.tableView.tableHeaderView = header;
}

- (void)viewDidLoad {
    
    self.tableView.backgroundColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];
    self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];
    
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];

    [self configToolbarWithType:self.toolbarType];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!didLayout) {
        [self layoutHeader];
        didLayout = YES;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    
}

- (IBAction)center:(id)sender {
    
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


- (void)showWarningAlert:(NSString *)message {
    [Common showWarningAlert:message];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];
    cell.contentView.backgroundColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];
}


- (void)backToSpecificViewController:(UIViewController *)viewController {
    [self backToSpecificViewController:viewController class:[viewController class]];
}

- (void)backToSpecificViewController:(UIViewController *)viewController class:(Class)type {
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    for (UIViewController *vc in [self.navigationController.viewControllers reverseObjectEnumerator]) {
        if ([vc isKindOfClass:type]) {
            NSInteger index = [viewControllers indexOfObject:vc];
            [viewControllers removeObjectsInRange:NSMakeRange(index, viewControllers.count - index)];
            break;
        }
    }
    
    [viewControllers addObject:viewController];
    
    [self.navigationController.visibleViewController viewWillDisappear:NO];
    [self.navigationController.visibleViewController viewDidDisappear:NO];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}


- (void)backToSpecificClass:(Class)aClass {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:aClass]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}


- (NSString *)helpImageForLantern:(Lantern *)lantern {
    if ([lantern.lanternDescription isEqualToString:LanternDescLantern]) {
        return @"img_help_21_lantern_only_help";
    } else if ([lantern.lanternDescription isEqualToString:LanternDescPILanternCombo]) {
        return @"img_help_21_lantern_pi_combo_help";
    } else if ([lantern.lanternDescription isEqualToString:LanternDescPositionIndicator]) {
        return @"img_help_21_position_indicator_only";
    }
    
    return @"";
}


- (void)updateToolbar {
    [self configToolbarWithType:_toolbarType];
}


- (void)viewWillAppear:(BOOL)animated {
    isAppearing = YES;
    
    [super viewWillAppear:animated];
    
    if ([DataManager sharedManager].currentDoorStyle == 2) {
        for (UILabel *label in doorLabels) {
            label.text = [label.text stringByReplacingOccurrencesOfString:@"Front" withString:@"Back"];
            label.text = [label.text stringByReplacingOccurrencesOfString:@"front" withString:@"back"];
            label.text = [label.text stringByReplacingOccurrencesOfString:@"FRONT" withString:@"BACK"];
        }
    } else if ([DataManager sharedManager].currentDoorStyle == 1) {
        for (UILabel *label in doorLabels) {
            label.text = [label.text stringByReplacingOccurrencesOfString:@"Back" withString:@"Front"];
            label.text = [label.text stringByReplacingOccurrencesOfString:@"back" withString:@"front"];
            label.text = [label.text stringByReplacingOccurrencesOfString:@"BACK" withString:@"FRONT"];
        }
    }
    
    if ([DataManager sharedManager].isEditing) {
        for (NSLayoutConstraint *constraint in self.editConstraints) {
            constraint.constant = 0;
        }
        [self.view layoutIfNeeded];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    isAppearing = NO;
    
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [(MADNavigationController *)(self.navigationController) expandTitle:NO];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isAppearing) {
        return;
    }
    
    if (!titleLabel) {
        [(MADNavigationController *)(self.navigationController) expandTitle:NO];
        return;
    }
    
    CGRect frame = [scrollView convertRect:titleLabel.bounds fromView:titleLabel];
    [(MADNavigationController *)(self.navigationController) expandTitle:(frame.origin.y + frame.size.height < scrollView.contentOffset.y)];
}


- (void)setViewDescription:(NSString *)description {
    self.navigationController.title = description;
    
    [self scrollViewDidScroll:self.tableView];
}

@end
