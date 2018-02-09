//
//  EditHallEntranceListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "EditHallEntranceListViewController.h"

#import "DataManager.h"
#import "EditListViewCell.h"
#import "DeleteItemConfirmView.h"
#import "HallEntranceDoorTypeViewController.h"
#import "EditBankListViewController.h"
#import "MADInfoAlert.h"

@interface EditHallEntranceListViewController () <EditListViewCellDelegate>

@property (nonatomic, strong) NSArray *hallEntrances;

@end

@implementation EditHallEntranceListViewController

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
    
    self.hallEntrances = [[DataManager sharedManager] getAllHallEntrancesForProject:[DataManager sharedManager].selectedProject];
    [self.tableView reloadData];

    [DataManager sharedManager].addingType = None;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hallEntrances.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HallEntrance *hallEntrance = self.hallEntrances[indexPath.row];
    
    EditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditListViewCell"];
    
    NSString *str = @"";
    switch (hallEntrance.doorType) {
        case 3:
            str = @"Center";
            break;
        case 2:
            str = @"Single Speed";
            break;
        case 1:
            str = @"2 Speed";
            break;
        default:
            break;
    }
    cell.title = [NSString stringWithFormat:@"Bank (%@) - Floor (%@)\nHall Entrance%d (%@)", hallEntrance.bank.name, hallEntrance.floorDescription, (int)indexPath.row + 1, str];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HallEntrance *hallEntrance = self.hallEntrances[indexPath.row];
    
    [DataManager sharedManager].currentBankIndex = [[DataManager sharedManager].selectedProject.banks indexOfObject:hallEntrance.bank];
    [DataManager sharedManager].floorDescription = hallEntrance.floorDescription;
    [DataManager sharedManager].currentFloorNum = hallEntrance.floorNum;
    [DataManager sharedManager].currentHallEntranceCarNum = hallEntrance.carNum;
    
    HallEntranceDoorTypeViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"HallEntranceDoorTypeViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}


- (void)next:(id)sender {
    [DataManager sharedManager].addingType = AddingHallEntrance;
    
    EditBankListViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditBankListViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - EditListViewCellDelegate

- (void)deleteItem:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HallEntrance *hallEntrance = self.hallEntrances[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"Bank (%@)", hallEntrance.bank.name];
    NSString *subtitle = [NSString stringWithFormat:@"Floor (%@)", hallEntrance.floorDescription];
    NSString *description = @"";
    switch (hallEntrance.doorType) {
        case 3:
            description = @"Center";
            break;
        case 2:
            description = @"Single Speed";
            break;
        case 1:
            description = @"2 Speed";
            break;
        default:
            break;
    }

    DeleteItemConfirmView *view = [DeleteItemConfirmView
                                   showOnView:self.navigationController.view
                                   title:title
                                   subtitle:subtitle
                                   description:description];
    if (view) {
        view.yesBlock = ^{
            // show info alert
            [MADInfoAlert showOnView:self.tableView.superview
                           withTitle:title
                            subTitle:[subtitle stringByAppendingFormat:@"\n%@", description]
                         description:@"Item successfully deleted from device"];
            
            [[DataManager sharedManager] deleteHallEntrance:hallEntrance];
            [[DataManager sharedManager] saveChanges];
            
            self.hallEntrances = [[DataManager sharedManager] getAllHallEntrancesForProject:[DataManager sharedManager].selectedProject];
            [self.tableView reloadData];
        };
    }
}

@end
