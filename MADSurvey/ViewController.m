//
//  ViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 5/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ViewController.h"
#import "MADMainCell.h"
#import "Constants.h"
#import <MessageUI/MessageUI.h>

#import "DataManager.h"

#define MAIN_TABLE_REUSE_ID         @"MADMainCell"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuTableView.backgroundColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];
    
    // check if the guide is shown
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:KeyIsInfoShown] boolValue] == NO) {
        [self info:nil];
    }
    
    infoFormView.layer.cornerRadius = 8.0f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [madLabel setFont:[UIFont boldSystemFontOfSize:madLabel.font.pointSize + 12]];
        for (UILabel * infoLabel in infoLabels) {
            CGFloat fontSize = infoLabel.font.pointSize;
            fontSize += 12;
            [infoLabel setFont:[UIFont systemFontOfSize:fontSize]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
    
    [DataManager sharedManager].isEditing = NO;
    [DataManager sharedManager].addingType = None;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)info:(id)sender {
    infoView.hidden = NO;
    infoView.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        infoView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)closeInfo:(id)sender {
    infoView.alpha = 1;
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        infoView.alpha = 0;
    } completion:^(BOOL finished) {
        infoView.hidden = YES;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:KeyIsInfoShown] boolValue] == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:KeyIsInfoShown];
            [self performSegueWithIdentifier:UINavigationIDMainSetting sender:nil];
        }
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MADMainCell * cell = (MADMainCell*)[tableView dequeueReusableCellWithIdentifier:MAIN_TABLE_REUSE_ID forIndexPath:indexPath];
    UIView * sBackView = [[UIView alloc] init];
    sBackView.backgroundColor = UIListSelectionColor;
    cell.selectedBackgroundView = sBackView;
    cell.cellType = indexPath.row;
    
    cell.backgroundColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];
    cell.contentView.backgroundColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [DataManager sharedManager].selectedProject = nil;
    
    switch (indexPath.row) {
        case UICellTypeMainNew:
        {
            [self performSegueWithIdentifier:UINavigationIDMainNew sender:nil];
        }
            break;
        case UICellTypeMainExisting:
        {
            [self performSegueWithIdentifier:UINavigationIDMainExisting sender:nil];
        }
            break;
        case UICellTypeMainSetting:
        {
            [self performSegueWithIdentifier:UINavigationIDMainSetting sender:nil];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)gotoMap:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://maps.google.com/maps?q=115`City View Dr. Etobicoke, Ontario, M9W 5A8, Canada"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://maps.google.com/maps?q=115 City View Dr. Etobicoke, Ontario, M9W 5A8, Canada"]];
    }
}

- (IBAction)gotoDial:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://1-866-967-8500"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://1-866-967-8500"]];
    }
}

- (IBAction)gotoSafari:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://www.madelevator.com"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.madelevator.com"]];
    }
}

- (IBAction)gotoEmail:(id)sender {
    MFMailComposeViewController * mvc = [[MFMailComposeViewController alloc] init];
    [mvc setSubject:@""];
    [mvc setToRecipients:@[@"customerservice@madelevator.com"]];
    if (mvc)
        [self presentViewController:mvc animated:YES completion:nil];
}

@end
