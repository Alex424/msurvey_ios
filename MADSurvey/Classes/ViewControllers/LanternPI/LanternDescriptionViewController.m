//
//  LanternDescriptionViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LanternDescriptionViewController.h"
#import "Constants.h"
#import "DataManager.h"

typedef NS_ENUM(NSUInteger, UICellLanternDesc) {
    UICellPI,
    UICellLantern,
    UICellCombo,
    UICellNoSelected
};

@interface LanternDescriptionViewController () <UITextFieldDelegate>
{
    NSInteger selectedIdx;
}

@end

@implementation LanternDescriptionViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSString *desc;
    switch (selectedIdx) {
        case 0:
            desc = LanternDescPositionIndicator;
            break;
        case 1:
            desc = LanternDescLantern;
            break;
        default:
            desc = LanternDescPILanternCombo;
            break;
    }
    
    if ([DataManager sharedManager].needToGoBack) {
        [DataManager sharedManager].needToGoBack = NO;
        
        [DataManager sharedManager].currentLantern.lanternDescription = desc;
        [[DataManager sharedManager] saveChanges];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (![DataManager sharedManager].currentLantern) {
            Project *project = [DataManager sharedManager].selectedProject;
            Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

            [DataManager sharedManager].currentLantern = [[DataManager sharedManager] createNewLanternForBank:bank lanternNum:[DataManager sharedManager].currentLanternNum floorNumber:[DataManager sharedManager].floorDescription];
        }

        [DataManager sharedManager].currentLantern.lanternDescription = desc;
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDLanternMounting sender:nil];
    }
}

-(IBAction)checkAction:(id)sender
{
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = checkImageViews[btnSelected.tag];
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    selectedIdx = btnSelected.tag;
    
    // all next
    [self next:sender];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lantern Description";
    
    for (UIImageView * comboImageView in checkImageViews) {
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
        hallStationLabel.text = [NSString stringWithFormat:@"Lantern / PI - %d of %d", (int32_t)[DataManager sharedManager].currentLanternNum + 1, (int32_t)[DataManager sharedManager].lanternCount];
    }
    
    Lantern *lantern;
    if (![DataManager sharedManager].needToGoBack) {
        lantern = [[DataManager sharedManager] getLanternForBank:bank lanternNum:[DataManager sharedManager].currentLanternNum floorNumber:[DataManager sharedManager].floorDescription];
        [DataManager sharedManager].currentLantern = lantern;
    } else {
        lantern = [DataManager sharedManager].currentLantern;
    }
    
    selectedIdx = -1;
    if (lantern) {
        if ([lantern.lanternDescription isEqualToString:LanternDescLantern]) {
            selectedIdx = 1;
        } else if ([lantern.lanternDescription isEqualToString:LanternDescPILanternCombo]) {
            selectedIdx = 2;
        } else if ([lantern.lanternDescription isEqualToString:LanternDescPositionIndicator]) {
            selectedIdx = 0;
        }
        
        if (selectedIdx >= 0) {
            [checkImageViews[selectedIdx] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        }
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
