//
//  HallEntranceDoorTypeViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallEntranceDoorTypeViewController.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallEntranceDoorTypeViewController () {
    NSInteger doorType;
}

@end

@implementation HallEntranceDoorTypeViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.navigationController.title = @"Interior Car Structure";
    
    [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor - %@", [DataManager sharedManager].floorDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
        carNumberLabel.text = [NSString stringWithFormat:@"Car %d of %d", (int32_t)[DataManager sharedManager].currentHallEntranceCarNum + 1, bank.numOfCar];
    }

    HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
    if (hallEntrance) {
        NSInteger index = -1;
        switch (hallEntrance.doorType) {
            case HallInstranceDoorType2s:
                index = 2;
                break;
            case HallInstranceDoorType1s:
                index = 1;
                break;
            case HallInstranceDoorTypeCenter:
                index = 0;
                break;
        }
        
        doorType = index;
        
        if (index >= 0) {
            [comboImageViews[index] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        }
    } else {
        doorType = -1;
    }
}

- (IBAction)comboAction:(id)sender
{
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = comboImageViews[btnSelected.tag];
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    doorType = btnSelected.tag;
    
    [self performSelector:@selector(next:) withObject:nil afterDelay:0.1];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
    if (!hallEntrance) {
        hallEntrance = [[DataManager sharedManager] createNewHallEntranceForBank:bank];
    }
    
    switch (doorType) {
        case 0:
            hallEntrance.doorType = HallInstranceDoorTypeCenter;
            break;
        case 1:
            hallEntrance.doorType = HallInstranceDoorType1s;
            break;
        case 2:
            hallEntrance.doorType = HallInstranceDoorType2s;
            break;
    }
    
    [[DataManager sharedManager] saveChanges];
    
    if (doorType == 0) {
        [self performSegueWithIdentifier:UINavigationIDDoorTypeNormal sender:nil];
    } else {
        [self performSegueWithIdentifier:UINavigationIDDoorTypeDontKnow sender:nil];
    }
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
