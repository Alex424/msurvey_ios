//
//  HallEntranceViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/27/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallEntranceViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallEntranceViewController ()

@end

@implementation HallEntranceViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car";
    
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
        carNumberLabel.text = [NSString stringWithFormat:@"Car %d of %d", (int32_t)[DataManager sharedManager].currentHallEntranceCarNum + 1, bank.numOfCar];
        
        if ([DataManager sharedManager].currentHallEntranceCarNum > 0) {
            self.backButton.hidden = YES;
            self.keyboardAccessoryView.leftButton.hidden = YES;
        }
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender
{
    //[self performSegueWithIdentifier:UINavigationIDProjectNumberBanks sender:nil];
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
    
    if (btnSelected.tag == UICellSameAs) {
        [self performSegueWithIdentifier:UINavigationIDHallEntranceExisting sender:nil];
    } else if (btnSelected.tag == UICellUnique) {
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
        if (hallEntrance) {
            [[DataManager sharedManager] deleteHallEntrance:hallEntrance];
            [[DataManager sharedManager] saveChanges];
        }
        
        [self performSegueWithIdentifier:UINavigationIDHallEntranceCopyToDoorType sender:nil];
    } else {
        // same as last
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        
        HallEntrance *hallEntrance = [bank.hallEntrances lastObject];
        [[DataManager sharedManager] createNewHallEntranceForBank:bank sameAs:hallEntrance];
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDHallEntranceCopyToDoorType sender:nil];
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
