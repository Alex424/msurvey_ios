//
//  EditInteriorCarListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "EditInteriorCarListViewController.h"

#import "DataManager.h"
#import "EditListViewCell.h"
#import "DeleteItemConfirmView.h"
#import "EditBankListViewController.h"
#import "InteriorCarDescriptionViewController.h"
#import "MADInfoAlert.h"

@interface EditInteriorCarListViewController () <EditListViewCellDelegate>

@property (nonatomic, strong) NSArray *cars;

@end

@implementation EditInteriorCarListViewController

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
    
    self.cars = [[DataManager sharedManager] getAllInteriorCarsForProject:[DataManager sharedManager].selectedProject];
    [self.tableView reloadData];

    [DataManager sharedManager].addingType = None;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InteriorCar *car = self.cars[indexPath.row];
    
    EditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditListViewCell"];
    
    cell.title = [NSString stringWithFormat:@"Bank (%@)\nCab Interior%d (%@)", car.bank.name, (int)indexPath.row + 1, car.carDescription];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InteriorCar *car = self.cars[indexPath.row];
    
    [DataManager sharedManager].currentBankIndex = [[DataManager sharedManager].selectedProject.banks indexOfObject:car.bank];
    [DataManager sharedManager].currentInteriorCarNum = car.interiorCarNum;
    
    InteriorCarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarDescriptionViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}


- (void)next:(id)sender {
    [DataManager sharedManager].addingType = AddingInteriorCar;
    
    EditBankListViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditBankListViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - EditListViewCellDelegate

- (void)deleteItem:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    InteriorCar *car = self.cars[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"Bank (%@)", car.bank.name];
    NSString *subtitle = [NSString stringWithFormat:@"Cab Interior%d (%@)", (int)indexPath.row + 1, car.carDescription];
    
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
            
            [[DataManager sharedManager] deleteInteriorCar:car];
            [[DataManager sharedManager] saveChanges];
            
            self.cars = [[DataManager sharedManager] getAllInteriorCarsForProject:[DataManager sharedManager].selectedProject];
            [self.tableView reloadData];
        };
    }
}

@end
