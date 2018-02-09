//
//  HallStationPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationPhotosViewController.h"
#import "HallStationViewController.h"
#import "FloorDescriptionViewController.h"
#import "CarDescriptionViewController.h"
#import "InteriorCarCountViewController.h"
#import "SubmitProjectViewController.h"
#import "BankNameViewController.h"
#import "EditHallStationListViewController.h"
#import "FinalViewController.h"
#import "Constants.h"
#import "PhotoSelectView.h"
#import "DataManager.h"

@interface HallStationPhotosViewController ()

@end

@implementation HallStationPhotosViewController


- (IBAction)next:(id)sender {
    if ([DataManager sharedManager].isEditing) {
        [self backToSpecificClass:[EditHallStationListViewController class]];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    NSInteger currentHallStation = [DataManager sharedManager].currentHallStationNum;
    NSInteger numHallStations = bank.numOfRiser;

    if (numHallStations > currentHallStation + 1) {
        [DataManager sharedManager].currentHallStationNum ++;

        HallStationViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HallStationViewController"];
        if (currentHallStation == 0) {
            [self backToSpecificViewController:lvc class:[FloorDescriptionViewController class]];
        } else {
            [self backToSpecificViewController:lvc];
        }
    } else {
        if (project.hallLanterns == 1) {
            [self performSegueWithIdentifier:UINavigationIDHallStationLantern sender:nil];
        } else {
            NSInteger numFloors = project.numFloors;
            NSInteger currentFloor = [DataManager sharedManager].currentFloorNum;
            if (numFloors > currentFloor + 1) {
                [DataManager sharedManager].currentHallStationNum = 0;
                [DataManager sharedManager].currentHallStation = nil;
                [DataManager sharedManager].currentFloorNum ++;

                FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
                lvc.fromBank = YES;
                [self backToSpecificViewController:lvc];
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
                } else {
                    NSInteger numBanks = project.numBanks;
                    NSInteger currentBank = [DataManager sharedManager].currentBankIndex;
                    if (numBanks > currentBank + 1) {
                        [DataManager sharedManager].currentFloorNum = 0;
                        [DataManager sharedManager].currentBankIndex ++;
                        
                        BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
                        [self backToSpecificViewController:lvc];
                    } else {
                        FinalViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"FinalViewController"];
                        [self.navigationController pushViewController:lvc animated:YES];
                    }
                }
            }
        }
    }
}

- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeHallStation;
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Hall Station Photos";
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:NO];
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

- (Photo *)addNewPhoto:(UIImage *)image {
    HallStation *hallStation = [DataManager sharedManager].currentHallStation;
    
    Photo *photo = [super addNewPhoto:image];
    photo.hallStation = hallStation;
    [hallStation addPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    HallStation *hallStation = [DataManager sharedManager].currentHallStation;
    
    return [hallStation.photos array];
}

@end
