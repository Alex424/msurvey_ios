//
//  InteriorCarDoorTypeViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarDoorTypeViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarDoorTypeViewController ()

@end

@implementation InteriorCarDoorTypeViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeNoNext;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];

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
    
    if (door.carDoorType == 2) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else if (door.carDoorType == 1) {
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    }
    
    [DataManager sharedManager].currentDoorType = door.carDoorType;
}

-(IBAction)comboAction:(id)sender
{
    [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];

    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = comboImageViews[btnSelected.tag];
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    if (btnSelected.tag == 0) {
        door.carDoorType = 2;
    } else if (btnSelected.tag == 1) {
        door.carDoorType = 1;
    }
    
    [DataManager sharedManager].currentDoorType = door.carDoorType;
    [[DataManager sharedManager] saveChanges];
    
    [self performSelector:@selector(next:) withObject:[NSNumber numberWithInteger:btnSelected.tag] afterDelay:0.1];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([DataManager sharedManager].currentCenterOpening == 2) {
        [self performSegueWithIdentifier:UINavigationIDInteriorCarDoorOpeningDirection sender:nil];
    } else {
        if ([[DataManager sharedManager].currentInteriorCarDoor.wallType isEqualToString:FivePiece]) {
            [self performSegueWithIdentifier:UINavigationIDInteriorDoorTypeLTransom sender:nil];
        } else {
            if ([DataManager sharedManager].currentDoorType == 1) {
                [self performSegueWithIdentifier:UINavigationIDInteriorCarDoorTypeToTransom2s sender:nil];
            } else if ([DataManager sharedManager].currentDoorType == 2) {
                [self performSegueWithIdentifier:UINavigationIDInteriorCarDoorTypeToTransom1s sender:nil];
            }
        }
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
