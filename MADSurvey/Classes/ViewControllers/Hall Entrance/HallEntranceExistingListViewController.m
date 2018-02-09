//
//  HallEntranceExistingListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/27/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallEntranceExistingListViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallEntranceExistingListViewController ()
{
    IBOutlet UILabel *bankLabel;
    
    NSMutableArray * hallEntrances;
}

@end

@implementation HallEntranceExistingListViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lantern List";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
    }
    
    hallEntrances = [NSMutableArray array];
    
    NSInteger index = 0;
    for (HallEntrance *hallEntrance in bank.hallEntrances) {
        NSString *doorType = @"";
        switch (hallEntrance.doorType) {
            case 3:
                doorType = @"Center";
                break;
            case 2:
                doorType = @"Single Speed";
                break;
            case 1:
                doorType = @"2 Speed";
                break;
        }

        NSString *row = [NSString stringWithFormat:@"%d - %@ (%@)", (int)index + 1, hallEntrance.floorDescription, doorType];
        [hallEntrances addObject:row];
        
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
    return hallEntrances.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExistingHallEntranceCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor =     UIListSelectionColor;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"     %@", (NSString *)hallEntrances[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    [[DataManager sharedManager] createNewHallEntranceForBank:bank sameAs:bank.hallEntrances[indexPath.row]];
    [[DataManager sharedManager] saveChanges];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:UINavigationIDHallEntranceExistingToDoorType sender:nil];
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
