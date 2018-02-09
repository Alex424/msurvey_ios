//
//  HallStationViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallStationViewController ()

@end

@implementation HallStationViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Hall Station";
 
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
        
        if ([DataManager sharedManager].currentHallStationNum > 0) {
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
        [self performSegueWithIdentifier:UINavigationIDHallStationExistingList sender:nil];
    } else if (btnSelected.tag == UICellUnique) {
        [DataManager sharedManager].currentHallStation = nil;
        
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        HallStation *hallStation = [[DataManager sharedManager] getHallStationForBank:bank hallStationNum:[DataManager sharedManager].currentHallStationNum floorNumber:[DataManager sharedManager].floorDescription];
        if (hallStation) {
            [[DataManager sharedManager] deleteHallStation:hallStation];
            [[DataManager sharedManager] saveChanges];
        }

        [self performSegueWithIdentifier:UINavigationIDHallStationNewDescription sender:nil];
    } else {
        // same as last
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

        [DataManager sharedManager].currentHallStation = [[DataManager sharedManager] createNewHallStationForBank:bank sameAs:nil];
        [[DataManager sharedManager] saveChanges];

        [self performSegueWithIdentifier:UINavigationIDHallStationExistingListSameAsLast sender:nil];
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
