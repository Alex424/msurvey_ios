//
//  EditLanternListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "EditLanternListViewController.h"

#import "DataManager.h"
#import "EditListViewCell.h"
#import "DeleteItemConfirmView.h"
#import "LanternDescriptionViewController.h"
#import "EditBankListViewController.h"
#import "MADInfoAlert.h"

@interface EditLanternListViewController () <EditListViewCellDelegate>

@property (nonatomic, strong) NSArray *lanterns;

@end

@implementation EditLanternListViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeAdd;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.toolbarType = UIToolbarTypeAdd;
    [self updateToolbar];
    [self.navigationController setToolbarHidden:NO];
    
    self.lanterns = [[DataManager sharedManager] getAllLanternsForProject:[DataManager sharedManager].selectedProject];
    [self.tableView reloadData];

    [DataManager sharedManager].addingType = None;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lanterns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Lantern *lantern = self.lanterns[indexPath.row];
    
    EditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditListViewCell"];
    
    cell.title = [NSString stringWithFormat:@"Bank (%@) - Floor (%@)\nLantern%d (%@)", lantern.bank.name, lantern.floorNumber, (int)indexPath.row + 1, lantern.lanternDescription];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Lantern *lantern = self.lanterns[indexPath.row];
    
    [DataManager sharedManager].currentBankIndex = [[DataManager sharedManager].selectedProject.banks indexOfObject:lantern.bank];
    [DataManager sharedManager].floorDescription = lantern.floorNumber;
    [DataManager sharedManager].currentFloorNum = 0;
    [DataManager sharedManager].currentLanternNum = lantern.lanternNum;
    
    LanternDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LanternDescriptionViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}


- (void)next:(id)sender {
    [DataManager sharedManager].addingType = AddingLantern;
    
    EditBankListViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditBankListViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - EditListViewCellDelegate

- (void)deleteItem:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Lantern *lantern = self.lanterns[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"Bank (%@)", lantern.bank.name];
    NSString *subtitle = [NSString stringWithFormat:@"Floor (%@)", lantern.floorNumber];
    NSString *description = lantern.lanternDescription;
    
    DeleteItemConfirmView *view = [DeleteItemConfirmView
                                   showOnView:self.navigationController.view
                                   title:title
                                   subtitle:subtitle
                                   description:description];
    if (view) {
        view.yesBlock = ^{
            // show info alert
            [MADInfoAlert showOnView:self.tableView.superview
                           withTitle:[title stringByAppendingFormat:@" - %@", subtitle]
                            subTitle:description
                         description:@"Item successfully deleted from device"];
            
            [[DataManager sharedManager] deleteLantern:lantern];
            [[DataManager sharedManager] saveChanges];
            
            self.lanterns = [[DataManager sharedManager] getAllLanternsForProject:[DataManager sharedManager].selectedProject];
            [self.tableView reloadData];
        };
    }
}

@end
