//
//  BankPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "BankPhotosViewController.h"
#import "FloorDescriptionViewController.h"
#import "CarDescriptionViewController.h"
#import "InteriorCarCountViewController.h"
#import "EditBankListViewController.h"
#import "MADInfoAlert.h"
#import "PhotoSelectView.h"
#import "DataManager.h"

@interface BankPhotosViewController ()

@end

@implementation BankPhotosViewController

- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeBank;
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Bank Photos";
    [self.navigationController setToolbarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:NO];
}

- (IBAction)next:(id)sender {
    if ([DataManager sharedManager].isEditing) {
        [self backToSpecificClass:[EditBankListViewController class]];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    if (project.hallStations == 1 || project.hallLanterns == 1) {
        [DataManager sharedManager].currentFloorNum = 0;
        FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
        lvc.fromBank = YES;
        [self.navigationController pushViewController:lvc animated:YES];
    } else {
        if (project.cops == 1) {
            [DataManager sharedManager].currentCarNum = 0;
            [DataManager sharedManager].currentCar = nil;
            
            CarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarDescriptionViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
        } else if (project.cabInteriors == 1) {
            [DataManager sharedManager].currentInteriorCarNum = 0;
            [DataManager sharedManager].currentInteriorCar = nil;
            
            InteriorCarCountViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarCountViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
        } else if (project.hallEntrances == 1) {
            [DataManager sharedManager].currentFloorNum = 0;
            FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
            lvc.fromBank = NO;
            [self.navigationController pushViewController:lvc animated:YES];
        }
    }
}

- (Photo *)addNewPhoto:(UIImage *)image {
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    Photo *photo = [super addNewPhoto:image];
    photo.bank = bank;
    [bank addPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    return [bank.photos array];
}

@end
