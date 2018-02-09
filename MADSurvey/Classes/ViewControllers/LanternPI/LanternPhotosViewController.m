//
//  LanternPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LanternPhotosViewController.h"
#import "LanternViewController.h"
#import "LanternNumberViewController.h"
#import "FloorDescriptionViewController.h"
#import "InteriorCarCountViewController.h"
#import "BankNameViewController.h"
#import "SubmitProjectViewController.h"
#import "EditLanternListViewController.h"
#import "FinalViewController.h"
#import "DataManager.h"
#import "Constants.h"
#import "PhotoSelectView.h"

@interface LanternPhotosViewController ()

@end

@implementation LanternPhotosViewController


- (IBAction)next:(id)sender {
    if ([DataManager sharedManager].isEditing) {
        [self backToSpecificClass:[EditLanternListViewController class]];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;

    NSInteger currentLantern = [DataManager sharedManager].currentLanternNum;
    NSInteger numLanterns = [DataManager sharedManager].lanternCount;
    
    if (numLanterns > currentLantern + 1) {
        [DataManager sharedManager].currentLanternNum ++;
        
        LanternViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LanternViewController"];
        if (currentLantern == 0) {
            [self backToSpecificViewController:lvc class:[LanternNumberViewController class]];
        } else {
            [self backToSpecificViewController:lvc];
        }
    } else {
        NSInteger numFloors = project.numFloors;
        NSInteger currentFloor = [DataManager sharedManager].currentFloorNum;
        if (numFloors > currentFloor + 1) {
            [DataManager sharedManager].currentFloorNum ++;
            FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
            lvc.fromBank = YES;
            [self backToSpecificViewController:lvc];
        } else {
            if (project.cops == 1) {
                [DataManager sharedManager].currentCopNum = 0;
                [DataManager sharedManager].currentCop = nil;

                [self performSegueWithIdentifier:UINavigationIDLanternCar sender:nil];
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

- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeLantern;
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lantern Photos";
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
    Lantern *lantern = [DataManager sharedManager].currentLantern;
    
    Photo *photo = [super addNewPhoto:image];
    photo.lantern = lantern;
    [lantern addPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    Lantern *lantern = [DataManager sharedManager].currentLantern;
    
    return [lantern.photos array];
}

@end
