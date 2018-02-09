//
//  CarSeparatePIPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarSeparatePIPhotosViewController.h"
#import "PhotoSelectView.h"
#import "Constants.h"
#import "DataManager.h"
#import "InteriorCarDescriptionViewController.h"
#import "CarDescriptionViewController.h"
#import "InteriorCarCountViewController.h"
#import "FloorDescriptionViewController.h"
#import "BankNameViewController.h"
#import "SubmitProjectViewController.h"
#import "EditCarListViewController.h"
#import "FinalViewController.h"

@interface CarSeparatePIPhotosViewController ()

@end

@implementation CarSeparatePIPhotosViewController


- (IBAction)next:(id)sender {
    if ([DataManager sharedManager].isEditing) {
        [self backToSpecificClass:[EditCarListViewController class]];
        return;
    }

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    NSInteger currentCar = [DataManager sharedManager].currentCarNum;
    NSInteger numCars = bank.numOfCar;
    if (numCars > currentCar + 1) {
        [DataManager sharedManager].currentCarNum ++;
        
        CarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarDescriptionViewController"];
        [self backToSpecificViewController:lvc];
    } else {
        if (project.cabInteriors == 1) {
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


- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeCarSeparate;
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Separated PI Photo";
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
    Car *car = [DataManager sharedManager].currentCar;
    
    Photo *photo = [super addNewPhoto:image];
    photo.spiCar = car;
    [car addSpiPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    Car *car = [DataManager sharedManager].currentCar;
    
    return [car.spiPhotos array];
}

@end
