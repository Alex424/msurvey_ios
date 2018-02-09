//
//  LanternViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LanternViewController.h"
#import "Constants.h"
#import "DataManager.h"

typedef NS_ENUM(NSUInteger, UICellCombo) {
    UICellUnique,
    UICellSameAsLast,
    UICellSameAs
};


@interface LanternViewController ()

@end

@implementation LanternViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lantern";
    
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
        lanternLabel.text = [NSString stringWithFormat:@"Lantern / PI - %d of %d", (int32_t)[DataManager sharedManager].currentLanternNum + 1, (int32_t)[DataManager sharedManager].lanternCount];
        
        if ([DataManager sharedManager].currentLanternNum > 0) {
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
        [self performSegueWithIdentifier:UINavigationIDLanternMainList sender:nil];
    } else if (btnSelected.tag == UICellUnique) {
        [DataManager sharedManager].currentLantern = nil;

        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        Lantern *lantern = [[DataManager sharedManager] getLanternForBank:bank lanternNum:[DataManager sharedManager].currentLanternNum floorNumber:[DataManager sharedManager].floorDescription];
        if (lantern) {
            [[DataManager sharedManager] deleteLantern:lantern];
            [[DataManager sharedManager] saveChanges];
        }

        [self performSegueWithIdentifier:UINavigationIDLanternDesc sender:nil];
    } else {
        // same as last
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

        [DataManager sharedManager].currentLantern = [[DataManager sharedManager] createNewLanternForBank:bank sameAs:nil];
        [[DataManager sharedManager] saveChanges];

        [self performSegueWithIdentifier:UINavigationIDLanternSameAsLastSameAsMeasurement sender:nil];
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
