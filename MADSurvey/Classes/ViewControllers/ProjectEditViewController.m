//
//  ProjectEditViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ProjectEditViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface ProjectEditViewController ()

@end

@implementation ProjectEditViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeSubmit;
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
    
    [DataManager sharedManager].isEditing = YES;
    [DataManager sharedManager].addingType = None;
    
    self.viewDescription = @"";
}

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditSubmit sender:nil];
}

- (IBAction)onProjectDetails:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditDetails sender:nil];
}

- (IBAction)onLobby:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditLobbies sender:nil];
}

- (IBAction)onBank:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditBanks sender:nil];
}

- (IBAction)onHallStation:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditHallStations sender:nil];
}

- (IBAction)onLantern:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditLanterns sender:nil];
}

- (IBAction)onElevatorCars:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditCars sender:nil];
}

- (IBAction)onCabInteriors:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditInteriorCars sender:nil];
}

- (IBAction)onHallEntrances:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDEditHallEntrances sender:nil];
}

@end
