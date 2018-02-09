//
//  CarRidingLanternPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarRidingLanternPhotosViewController.h"
#import "PhotoSelectView.h"
#import "Constants.h"
#import "DataManager.h"

@interface CarRidingLanternPhotosViewController ()

@end

@implementation CarRidingLanternPhotosViewController

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDCarRidingToPI sender:nil];
}

- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeCarRiding;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Riding Lantern Photos";
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
    photo.cdiCar = car;
    [car addCdiPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    Car *car = [DataManager sharedManager].currentCar;
    
    return [car.cdiPhotos array];
}

@end
