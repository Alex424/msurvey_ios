//
//  HallEntrancePhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallEntrancePhotosViewController.h"
#import "Constants.h"
#import "PhotoSelectView.h"
#import "DataManager.h"
#import "HallEntranceViewController.h"
#import "FloorDescriptionViewController.h"
#import "BankNameViewController.h"
#import "EditHallEntranceListViewController.h"

@interface HallEntrancePhotosViewController ()

@end

@implementation HallEntrancePhotosViewController

- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeHallEntrance;
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:NO];
}

- (IBAction)next:(id)sender {
    if ([DataManager sharedManager].isEditing) {
        [self backToSpecificClass:[EditHallEntranceListViewController class]];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    NSInteger carNum = [DataManager sharedManager].currentHallEntranceCarNum;

    if (bank.numOfCar > [DataManager sharedManager].currentHallEntranceCarNum + 1) {
        [DataManager sharedManager].currentHallEntranceCarNum ++;
        
        HallEntranceViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"HallEntranceViewController"];
        if (carNum == 0) {
            [self backToSpecificViewController:lvc class:[FloorDescriptionViewController class]];
        } else {
            [self backToSpecificViewController:lvc];
        }
    } else if (project.numFloors > [DataManager sharedManager].currentFloorNum + 1) {
        [self performSegueWithIdentifier:UINavigationIDHallEntranceSkipRest sender:nil];
    } else if (project.numBanks > [DataManager sharedManager].currentBankIndex + 1) {
        [DataManager sharedManager].currentHallEntranceCarNum = 0;
        [DataManager sharedManager].currentFloorNum = 0;
        [DataManager sharedManager].currentBankIndex ++;
        
        BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
        [self backToSpecificViewController:lvc];
    } else {
        [self performSegueWithIdentifier:UINavigationIDFinal sender:nil];
    }
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
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
    
    Photo *photo = [super addNewPhoto:image];
    photo.hallEntrance = hallEntrance;
    [hallEntrance addPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
    
    return [hallEntrance.photos array];
}

@end
