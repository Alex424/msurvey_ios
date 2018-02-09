//
//  EditCarListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "EditCarListViewController.h"

#import "DataManager.h"
#import "EditListViewCell.h"
#import "DeleteItemConfirmView.h"
#import "EditBankListViewController.h"
#import "CarDescriptionViewController.h"
#import "MADInfoAlert.h"

@interface EditCarListViewController () <EditListViewCellDelegate>

@property (nonatomic, strong) NSArray *cars;

@end

@implementation EditCarListViewController

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
    
    self.cars = [[DataManager sharedManager] getAllCarsForProject:[DataManager sharedManager].selectedProject];
    [self.tableView reloadData];

    [DataManager sharedManager].addingType = None;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Car *car = self.cars[indexPath.row];
    
    EditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditListViewCell"];
    
    cell.title = [NSString stringWithFormat:@"Bank (%@)\nCar%d (%@)", car.bank.name, (int)indexPath.row + 1, car.carNumber];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Car *car = self.cars[indexPath.row];
    
    [DataManager sharedManager].currentBankIndex = [[DataManager sharedManager].selectedProject.banks indexOfObject:car.bank];
    [DataManager sharedManager].currentCarNum = car.carNum;
    
    CarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarDescriptionViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}


- (void)next:(id)sender {
    [DataManager sharedManager].addingType = AddingCar;
    
    EditBankListViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditBankListViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - EditListViewCellDelegate

- (void)deleteItem:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Car *car = self.cars[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"Bank (%@)", car.bank.name];
    NSString *subtitle = [NSString stringWithFormat:@"Car%d (%@)", (int)indexPath.row + 1, car.carNumber];
    
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
            
            [[DataManager sharedManager] deleteCar:car];
            [[DataManager sharedManager] saveChanges];
            
            self.cars = [[DataManager sharedManager] getAllCarsForProject:[DataManager sharedManager].selectedProject];
            [self.tableView reloadData];
        };
    }
}

@end
