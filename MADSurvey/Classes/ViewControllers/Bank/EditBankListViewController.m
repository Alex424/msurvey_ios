//
//  EditBankListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "EditBankListViewController.h"

#import "DataManager.h"
#import "EditListViewCell.h"
#import "DeleteItemConfirmView.h"
#import "BankNameViewController.h"
#import "FloorDescriptionViewController.h"
#import "CarDescriptionViewController.h"
#import "InteriorCarDescriptionViewController.h"
#import "MADInfoAlert.h"

@interface EditBankListViewController () <EditListViewCellDelegate> {
    BOOL isFirstAppear;
}

@property (nonatomic, strong) NSArray *banks;

@end

@implementation EditBankListViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeAdd;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isFirstAppear = YES;
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

    self.banks = [[DataManager sharedManager].selectedProject.banks array];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFirstAppear) {
        // this is called immediately after add a bank
        switch ([DataManager sharedManager].addingType) {
            case None:
                break;
            case AddingHallStation:
            case AddingLantern:
            case AddingCar:
            case AddingInteriorCar:
            case AddingHallEntrance: {
                [MADInfoAlert showOnView:self.tableView.superview
                               withTitle:@"Instruction"
                                subTitle:@""
                             description:@"Add a new bank or select one of existing banks you would like to add an item into."];
                break;
            }
        }
        
        isFirstAppear = NO;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.banks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Bank *bank = self.banks[indexPath.row];
    
    EditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditListViewCell"];
    
    cell.title = [NSString stringWithFormat:@"Bank%d (%@)", (int)indexPath.row + 1, bank.name];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [DataManager sharedManager].currentBankIndex = indexPath.row;
    
    switch ([DataManager sharedManager].addingType) {
        case None: {
            BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
            break;
        }
        case AddingHallStation:
        case AddingLantern:
        case AddingHallEntrance: {
            [DataManager sharedManager].currentFloorNum = 0;
            FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
            break;
        }
        case AddingCar: {
            [DataManager sharedManager].currentCarNum = [[DataManager sharedManager] getMaxCarNumForBank:self.banks[indexPath.row]] + 1;

            CarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarDescriptionViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
            break;
        }
        case AddingInteriorCar: {
            [DataManager sharedManager].currentInteriorCarNum = [[DataManager sharedManager] getMaxInteriorCarNumForBank:self.banks[indexPath.row]] + 1;
            
            InteriorCarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarDescriptionViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
            break;
        }
    }
}


- (void)next:(id)sender {
    [DataManager sharedManager].currentBankIndex = self.banks.count;
    
    BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - EditListViewCellDelegate

- (void)deleteItem:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Bank *bank = self.banks[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"Bank %d", (int)indexPath.row + 1];
    NSString *subtitle = bank.name;
    
    DeleteItemConfirmView *view = [DeleteItemConfirmView
                                   showOnView:self.navigationController.view
                                   title:title
                                   subtitle:subtitle
                                   description:@""];
    if (view) {
        view.yesBlock = ^{
            // show info alert
            [MADInfoAlert showOnView:self.tableView.superview
                           withTitle:title
                            subTitle:subtitle
                         description:@"Item successfully deleted from device"];
            
            [[DataManager sharedManager] deleteBank:bank];
            [[DataManager sharedManager] saveChanges];
            
            self.banks = [[DataManager sharedManager].selectedProject.banks array];

            [self.tableView reloadData];
        };
    }
}

@end
