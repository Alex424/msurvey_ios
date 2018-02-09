//
//  CarCopStyleViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarCopStyleViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface CarCopStyleViewController ()
{
    NSInteger selectedStyle;
    NSInteger selectedHinging;
}

@end

@implementation CarCopStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)next:(id)sender {
    if (selectedStyle < 0) {
        return;
    }
    if (selectedHinging < 0) {
        return;
    }
    
    Cop *cop = [DataManager sharedManager].currentCop;
    
    if (selectedStyle == 0) {
        cop.options = CopStyleApplied;
        
        cop.swingPanelWidth = -1;
        cop.swingPanelHeight = -1;
    } else if (selectedStyle == 1) {
        cop.options = CopStyleSwing;
        
        cop.returnPanelHeight = -1;
        cop.returnPanelWidth = -1;
        cop.coverWidth = -1;
        cop.coverHeight = -1;
        cop.coverToOpening = -1;
    }
    
    if (selectedHinging == 2) {
        cop.returnHinging = CopHingingSideLeft;
    } else if (selectedHinging == 3) {
        cop.returnHinging = CopHingingSideRight;
    }
    
    [[DataManager sharedManager] saveChanges];
    
    if (selectedStyle == 0) {
        [self performSegueWithIdentifier:UINavigationIDCarCopAppliedMeasurements sender:nil];
    } else {
        [self performSegueWithIdentifier:UINavigationIDCarCopSwingMeasurements sender:nil];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkAction:(id)sender
{
    UIButton * btnSelected = (UIButton *) sender;

    UIImageView * imageSelected = checkImageViews[btnSelected.tag];
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    if (btnSelected.tag < 2) {
        [checkImageViews[1 - btnSelected.tag] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        selectedStyle = btnSelected.tag;
    } else {
        [checkImageViews[1 - (btnSelected.tag - 2) + 2] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        selectedHinging = btnSelected.tag;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car COP Style";

    Project *project = [DataManager sharedManager].selectedProject;
    Car *car = [DataManager sharedManager].currentCar;
    
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
    }
    carLabel.text = [NSString stringWithFormat:@"COP %d of %d - %@", (int32_t)[DataManager sharedManager].currentCopNum + 1, car.numberOfCops, car.carNumber];
    
    Cop *cop = [DataManager sharedManager].currentCop;
    
    if ([cop.options isEqualToString:CopStyleApplied]) {
        [checkImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedStyle = 0;
    } else if ([cop.options isEqualToString:CopStyleSwing]) {
        [checkImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedStyle = 1;
    } else {
        selectedStyle = -1;
    }
    
    if ([cop.returnHinging isEqualToString:CopHingingSideLeft]) {
        [checkImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedHinging = 2;
    } else if ([cop.returnHinging isEqualToString:CopHingingSideRight]) {
        [checkImageViews[3] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedHinging = 3;
    } else {
        selectedHinging = -1;
    }

    [self.navigationController setToolbarHidden:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(selectedIdx == UICellOther && indexPath.row == UICellOther)
//        return 130;
//    
    return 70; //130
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
