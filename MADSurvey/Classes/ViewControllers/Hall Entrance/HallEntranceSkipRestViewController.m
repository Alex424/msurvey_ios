//
//  HallEntranceSkipRestViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallEntranceSkipRestViewController.h"
#import "Constants.h"
#import "DataManager.h"
#import "HallEntranceViewController.h"
#import "FloorDescriptionViewController.h"
#import "BankNameViewController.h"
#import "EditHallEntranceListViewController.h"
#import "SkipRestConfirmView.h"

@interface HallEntranceSkipRestViewController () {
    BOOL skip;
}

@end

@implementation HallEntranceSkipRestViewController

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

    [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    Project *project = [DataManager sharedManager].selectedProject;
    
    if (!skip && project.numFloors > [DataManager sharedManager].currentFloorNum + 1) {
        [DataManager sharedManager].currentHallEntranceCarNum = 0;
        [DataManager sharedManager].currentFloorNum ++;
        
        FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
        [self backToSpecificViewController:lvc];
    } else if (project.numBanks > [DataManager sharedManager].currentBankIndex + 1) {
        [DataManager sharedManager].currentHallEntranceCarNum = 0;
        [DataManager sharedManager].currentFloorNum = 0;
        [DataManager sharedManager].currentBankIndex ++;
        
        BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
        [self backToSpecificViewController:lvc];
    } else {
        [self performSegueWithIdentifier:UINavigationIDFinal2 sender:nil];
    }
}

- (IBAction)comboAction:(id)sender {
    UIButton *btnSelected = (UIButton *)sender;
    UIImageView *imageSelected = comboImageViews[btnSelected.tag];
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    if (btnSelected.tag == 0) {
        SkipRestConfirmView *view = [SkipRestConfirmView showOnView:self.navigationController.view];
        view.yesBlock = ^{
            skip = YES;
            [self performSelector:@selector(next:) withObject:nil afterDelay:0.1];
        };
        view.noBlock = ^{
            [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        };
    } else if(btnSelected.tag == 1) {
        skip = NO;
        [self performSelector:@selector(next:) withObject:nil afterDelay:0.1];
    }
}

@end
