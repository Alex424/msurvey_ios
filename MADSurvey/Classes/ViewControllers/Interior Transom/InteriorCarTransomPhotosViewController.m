//
//  InteriorCarTransomPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarTransomPhotosViewController.h"
#import "InteriorCarBackWallViewController.h"
#import "InteriorCarWallTypeViewController.h"
#import "Constants.h"
#import "PhotoSelectView.h"
#import "DataManager.h"

@interface InteriorCarTransomPhotosViewController ()

@end

@implementation InteriorCarTransomPhotosViewController

- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeIntTransom;
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
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    
    [DataManager sharedManager].needInstruction = NO;
    if (interiorCar.isThereBackDoor == 1) {
        if ([DataManager sharedManager].currentDoorStyle == 1) {
            if (interiorCar.backDoor) {
                [DataManager sharedManager].needInstruction = YES;
                [DataManager sharedManager].currentDoorStyle = 2;
                InteriorCarWallTypeViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarWallTypeViewController"];
                [self backToSpecificViewController:lvc];
            } else {
                [self performSegueWithIdentifier:UINavigationIDINteriorCarBackWallClone sender:nil];
            }
        } else if ([DataManager sharedManager].currentDoorStyle == 2) {
            InteriorCarBackWallViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarBackWallViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
        }
    } else if (interiorCar.isThereBackDoor == 2) {
        InteriorCarBackWallViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarBackWallViewController"];
        [self.navigationController pushViewController:lvc animated:YES];
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
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    
    Photo *photo = [super addNewPhoto:image];
    photo.interiorCar = interiorCar;
    [interiorCar addPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    
    return [interiorCar.photos array];
}

@end
