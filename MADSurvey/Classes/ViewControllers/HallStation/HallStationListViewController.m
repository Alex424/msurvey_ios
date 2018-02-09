//
//  HallStationListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationListViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallStationListViewController ()
{
    NSMutableArray * stations;
}
@end

@implementation HallStationListViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;

    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Hall Station List";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
    }
    
    stations = [NSMutableArray array];
    
    NSInteger index = 0;
    for (HallStation *hallStation in bank.hallStations) {
        NSString *row = [NSString stringWithFormat:@"%d - %@(%@)", (int)index + 1, hallStation.floorNumber, hallStation.hallStationDescription];
        [stations addObject:row];
        
        index ++;
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return stations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExistingHallStationCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor =     UIListSelectionColor;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"     %@", (NSString*)stations[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    [DataManager sharedManager].currentHallStation = [[DataManager sharedManager] createNewHallStationForBank:bank sameAs:bank.hallStations[indexPath.row]];
    [[DataManager sharedManager] saveChanges];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:UINavigationIDHallStationExistingListSameAsMeasure sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
