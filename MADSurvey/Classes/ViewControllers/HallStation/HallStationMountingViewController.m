//
//  HallStationMountingViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationMountingViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallStationMountingViewController ()

@end

@implementation HallStationMountingViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Hall Station Mounting";
    
    for (UIImageView * comboImageView in comboImageViews) {
        [comboImageView setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    }

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor - %@", [DataManager sharedManager].floorDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
        hallStationLabel.text = [NSString stringWithFormat:@"Hall Station - %d of %d", (int32_t)[DataManager sharedManager].currentHallStationNum + 1, bank.numOfRiser];
    }
    
    if ([[DataManager sharedManager].currentHallStation.mount isEqualToString:FlushMount]) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else if ([[DataManager sharedManager].currentHallStation.mount isEqualToString:SurfaceMount]) {
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender
{
    if ([DataManager sharedManager].needToGoBack) {
        [DataManager sharedManager].needToGoBack = NO;
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:UINavigationIDHallStationMountingMaterial sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)comboAction:(id)sender
{
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = comboImageViews[btnSelected.tag];
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    if (btnSelected.tag == UICellFlash) {
        [DataManager sharedManager].currentHallStation.mount = FlushMount;
    } else if (btnSelected.tag == UICellSurface) {
        [DataManager sharedManager].currentHallStation.mount = SurfaceMount;
    }
         
    [[DataManager sharedManager] saveChanges];

     [self next:nil];
}

@end
