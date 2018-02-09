//
//  LanternNumberViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LanternNumberViewController.h"
#import "Constants.h"
#import "DataManager.h"
#import "FloorDescriptionViewController.h"
#import "CarDescriptionViewController.h"
#import "InteriorCarCountViewController.h"
#import "HallEntranceDoorTypeViewController.h"
#import "BankNameViewController.h"
#import "SubmitProjectViewController.h"
#import "LanternDescriptionViewController.h"
#import "FinalViewController.h"

@interface LanternNumberViewController ()

@end

@implementation LanternNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    numberField.inputAccessoryView = self.keyboardAccessoryView;

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
    floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
    
    NSInteger lanternNumber = [[DataManager sharedManager] getLanternCountPerFloor:bank floorNumber:[DataManager sharedManager].floorDescription];
    
    numberField.text = (lanternNumber > 0) ? [NSString stringWithFormat:@"%d", (int)lanternNumber] : @"";
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lantern/PI";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [numberField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if (numberField.text.length == 0) {
        [self showWarningAlert:@"Please input Lantern Number!"];
        [numberField becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    NSInteger number = [numberField.text integerValue];
    if (number == 0) {
        [[DataManager sharedManager] createNewLanternForBank:bank lanternNum:EmptyLanternRecordID floorNumber:[DataManager sharedManager].floorDescription];
        if (project.numFloors > [DataManager sharedManager].currentFloorNum + 1) {
            [DataManager sharedManager].currentFloorNum ++;
            
            FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
            lvc.fromBank = YES;
            [self backToSpecificViewController:lvc];
        } else {
            if (project.cops == 1) {
                CarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarDescriptionViewController"];
                [self.navigationController pushViewController:lvc animated:YES];
            } else if (project.cabInteriors == 1) {
                InteriorCarCountViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarCountViewController"];
                [self.navigationController pushViewController:lvc animated:YES];
            } else if (project.hallEntrances == 1) {
                HallEntranceDoorTypeViewController *lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"HallEntranceDoorTypeViewController"];
                [self.navigationController pushViewController:lvc animated:YES];
            } else {
                if (project.numBanks > [DataManager sharedManager].currentBankIndex + 1) {
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
    } else {
        [DataManager sharedManager].currentLanternNum = 0;
        [DataManager sharedManager].currentLantern = nil;
        [DataManager sharedManager].lanternCount = number;
        
        NSInteger lanternNum = [[DataManager sharedManager] getLanternCountPerFloor:bank floorNumber:[DataManager sharedManager].floorDescription];
        if (lanternNum == 0 && [DataManager sharedManager].currentFloorNum == 0) {
            LanternDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LanternDescriptionViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
        } else {
            [self performSegueWithIdentifier:UINavigationIDLanternNumMain sender:nil];
        }
    }
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
