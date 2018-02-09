//
//  FloorDescriptionViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "FloorDescriptionViewController.h"
#import "Constants.h"
#import "MADInfoAlert.h"
#import "DataManager.h"
#import "HallEntranceDoorTypeViewController.h"
#import "HallEntranceViewController.h"
#import "LanternViewController.h"
#import "LanternDescriptionViewController.h"

@interface FloorDescriptionViewController ()

@end

@implementation FloorDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    descriptionField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([DataManager sharedManager].currentFloorNum == 0) {
        MADInfoAlert *alert = [MADInfoAlert showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Instruction" subTitle:@"" description:@"Go to the top floor and start entering data for each Hall Station and lantern per floor."];
        
        alert.okBlock = ^{
            [descriptionField becomeFirstResponder];
        };
        alert.closeBlock = ^{
            [descriptionField becomeFirstResponder];
        };
    } else {
        [descriptionField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if (descriptionField.text.length == 0) {
        [self showWarningAlert:@"Please input Floor Descriptor!"];
        [descriptionField becomeFirstResponder];
        return;
    }
    
    [descriptionField resignFirstResponder];
    
    DataManager *manager = [DataManager sharedManager];
    manager.floorDescription = descriptionField.text;

    Project *project = manager.selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    if (manager.isEditing) {
        switch (manager.addingType) {
            case AddingHallStation: {
                manager.currentHallStationNum = [manager getMaxHallStationNumForBank:bank floorNumber:manager.floorDescription] + 1;
                
                if (bank.hallStations.count == 0) {
                    [self performSegueWithIdentifier:UINavigationIDHallStationDescription sender:nil];
                } else {
                    // Go to Hall Station
                    [self performSegueWithIdentifier:UINavigationIDHallStation sender:nil];
                }
                break;
            }
            case AddingLantern: {
                manager.currentLanternNum = [manager getMaxLanternNumForBank:bank floorNumber:manager.floorDescription] + 1;
                
                if (bank.lanterns.count == 0) {
                    LanternDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LanternDescriptionViewController"];
                    [self.navigationController pushViewController:lvc animated:YES];
                } else {
                    LanternViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LanternViewController"];
                    [self.navigationController pushViewController:lvc animated:YES];
                }
                break;
            }
            case AddingHallEntrance: {
                manager.currentHallEntranceCarNum = [manager getMaxHallEntranceCarNumForBank:bank floorNumber:manager.floorDescription] + 1;
                
                if (bank.hallEntrances.count > 0) {
                    HallEntranceViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"HallEntranceViewController"];
                    [self.navigationController pushViewController:lvc animated:YES];
                } else {
                    HallEntranceDoorTypeViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"HallEntranceDoorTypeViewController"];
                    [self.navigationController pushViewController:lvc animated:YES];
                }
                break;
            }
            default:
                break;
        }
        
        return;
    }
    
    if (!self.fromBank) {
        manager.currentHallEntranceCarNum = 0;
        
        // Go to Hall Entrance Door Type
        if (bank.hallEntrances.count > 0) {
            HallEntranceViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"HallEntranceViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
        } else {
            HallEntranceDoorTypeViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"HallEntranceDoorTypeViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
        }
    } else {
        manager.currentHallStationNum = 0;
        manager.currentHallStation = nil;

        if (project.hallStations == 1) {
            if (manager.currentHallStationNum == 0 && manager.currentFloorNum == 0) {
                // Go to Hall Station Description
                [self performSegueWithIdentifier:UINavigationIDHallStationDescription sender:nil];
            } else {
                // Go to Hall Station
                [self performSegueWithIdentifier:UINavigationIDHallStation sender:nil];
            }
        } else if (project.hallLanterns == 1) {
            //  Go to Lantern Number
            [self performSegueWithIdentifier:UINavigationIDLanternNumber sender:nil];
        } else {
            @throw [NSException new];
        }
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Floor Description";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int)[DataManager sharedManager].currentBankIndex + 1, bank.name];
    floorRecordLabel.text = [NSString stringWithFormat:@"Floor Record %d of %d", (int)[DataManager sharedManager].currentFloorNum + 1, project.numFloors];
//    
//    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
//    
//    NSArray *floorNumbers1 = [[DataManager sharedManager] floorNumbersForHallStations:bank];
//    NSArray *floorNumbers2 = [[DataManager sharedManager] floorNumbersForLanterns:bank];
//    NSArray *floorNumbers = (floorNumbers1.count > floorNumbers2.count) ? floorNumbers1 : floorNumbers2;
//    NSArray *floorNumbers3 = [[DataManager sharedManager] floorNumbersForHallEntrances:bank];
//    if (floorNumbers3.count > floorNumbers.count) {
//        floorNumbers = floorNumbers3;
//    }
//    
//    if (floorNumbers.count > [DataManager sharedManager].currentFloorNum) {
//        descriptionField.text = floorNumbers[[DataManager sharedManager].currentFloorNum];
//    }
    
    if (![DataManager sharedManager].isEditing && [DataManager sharedManager].currentFloorNum > 0) {
        self.backButton.hidden = YES;
        self.keyboardAccessoryView.leftButton.hidden = YES;
    }
    descriptionField.text = @"";
}

#pragma textfield delgate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
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
