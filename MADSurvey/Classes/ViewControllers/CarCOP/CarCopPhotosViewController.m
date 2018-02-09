//
//  CarCopPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarCopPhotosViewController.h"
#import "CarCopNameViewController.h"
#import "PhotoSelectView.h"
#import "Constants.h"
#import "DataManager.h"

@interface CarCopPhotosViewController ()

@end

@implementation CarCopPhotosViewController

- (IBAction)next:(id)sender {
    NSInteger currentCop = [DataManager sharedManager].currentCopNum;
    Car *car = [DataManager sharedManager].currentCar;
    NSInteger numCops = car.numberOfCops;
    if (numCops > currentCop + 1) {
        [DataManager sharedManager].currentCopNum ++;
        
        CarCopNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarCopNameViewController"];
        [self backToSpecificViewController:lvc];
    } else {
        [self performSegueWithIdentifier:UINavigationIDCarCopToCarRiding sender:nil];
    }
}

- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeCarCOP;
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car COP Photos";
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
    Cop *cop = [DataManager sharedManager].currentCop;
    
    Photo *photo = [super addNewPhoto:image];
    photo.cop = cop;
    [cop addPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    Cop *cop = [DataManager sharedManager].currentCop;
    
    return [cop.photos array];
}

@end
