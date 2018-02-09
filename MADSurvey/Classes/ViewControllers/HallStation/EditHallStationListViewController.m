//
//  EditHallStationListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "EditHallStationListViewController.h"

#import "DataManager.h"
#import "EditListViewCell.h"
#import "DeleteItemConfirmView.h"
#import "HallStationDescriptionViewController.h"
#import "EditBankListViewController.h"
#import "MADInfoAlert.h"

@interface EditHallStationListViewController () <EditListViewCellDelegate>

@property (nonatomic, strong) NSArray *hallStations;

@end

@implementation EditHallStationListViewController

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
    
    self.hallStations = [[DataManager sharedManager] getAllHallStationsForProject:[DataManager sharedManager].selectedProject];
    [self.tableView reloadData];

    [DataManager sharedManager].addingType = None;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hallStations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HallStation *hallStation = self.hallStations[indexPath.row];
    
    EditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditListViewCell"];
    
    cell.title = [NSString stringWithFormat:@"Bank (%@) - Floor (%@)\nHall Station%d (%@)", hallStation.bank.name, hallStation.floorNumber, (int)indexPath.row + 1, hallStation.hallStationDescription];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HallStation *hallStation = self.hallStations[indexPath.row];

    [DataManager sharedManager].currentBankIndex = [[DataManager sharedManager].selectedProject.banks indexOfObject:hallStation.bank];
    [DataManager sharedManager].floorDescription = hallStation.floorNumber;
    [DataManager sharedManager].currentFloorNum = 0;
    [DataManager sharedManager].currentHallStationNum = hallStation.hallStationNum;
    
    HallStationDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HallStationDescriptionViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}


- (void)next:(id)sender {
    [DataManager sharedManager].addingType = AddingHallStation;
    
    EditBankListViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditBankListViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - EditListViewCellDelegate

- (void)deleteItem:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HallStation *hallStation = self.hallStations[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"Bank (%@)", hallStation.bank.name];
    NSString *subtitle = [NSString stringWithFormat:@"Floor (%@)", hallStation.floorNumber];
    NSString *description = hallStation.hallStationDescription;
    
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
            
            [[DataManager sharedManager] deleteHallStation:hallStation];
            [[DataManager sharedManager] saveChanges];
            
            self.hallStations = [[DataManager sharedManager] getAllHallStationsForProject:[DataManager sharedManager].selectedProject];
            [self.tableView reloadData];
        };
    }
}

@end
