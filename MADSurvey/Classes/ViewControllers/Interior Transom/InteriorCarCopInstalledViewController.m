//
//  InteriorCarCopInstalledViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarCopInstalledViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarCopInstalledViewController ()

@end

@implementation InteriorCarCopInstalledViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeNoNext;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.title = @"Interior Car Structure";
    
    [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car - %@", interiorCar.carDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d - %@", (int32_t)[DataManager sharedManager].currentInteriorCarNum + 1, bank.numOfInteriorCar, interiorCar.carDescription];
    }
    
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    
    if ([door.isThereNewCop isEqualToString:IsThereNewCopYes]) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else if ([door.isThereNewCop isEqualToString:IsThereNewCopNo]) {
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else if ([door.isThereNewCop isEqualToString:IsThereNewCopDontKnow]) {
        [comboImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    }
}

-(IBAction)comboAction:(id)sender
{
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = comboImageViews[btnSelected.tag];
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    if (btnSelected.tag == 0) {
        door.isThereNewCop = IsThereNewCopYes;
    } else if(btnSelected.tag == 1) {
        door.isThereNewCop = IsThereNewCopNo;
    } else {
        door.isThereNewCop = IsThereNewCopDontKnow;
    }
    [[DataManager sharedManager] saveChanges];
    
    [self performSelector:@selector(next:) withObject:nil afterDelay:0.1];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;

    if ([door.isThereNewCop isEqualToString:IsThereNewCopYes]) {
//        if ([DataManager sharedManager].currentCenterOpening == 1) {
//            [self performSegueWithIdentifier:UINavigationIDInteriorCarCopInstalledToAuxCopReturn sender:nil];
//        } else {
            [self performSegueWithIdentifier:UINavigationIDInteriorCarMainCopReturn sender:nil];
//        }
    } else if ([door.isThereNewCop isEqualToString:IsThereNewCopNo]) {
        [self performSegueWithIdentifier:UINavigationIDInteriorCarCopInstalledToTransomNotes sender:nil];
    } else if ([door.isThereNewCop isEqualToString:IsThereNewCopDontKnow]) {
        [self performSegueWithIdentifier:UINavigationIDInteriorCarCopInstalledToTransomNotes sender:nil];
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

@end
