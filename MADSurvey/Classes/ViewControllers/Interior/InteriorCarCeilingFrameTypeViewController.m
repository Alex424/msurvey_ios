//
//  InteriorCarCeilingFrameTypeViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarCeilingFrameTypeViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarCeilingFrameTypeViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField * otherField;

    NSInteger selectedFrameType;
    NSInteger selectedMountType;
}

@end

@implementation InteriorCarCeilingFrameTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    otherField.inputAccessoryView = self.keyboardAccessoryView;

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car Ceiling Frame Type";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car - %@", interiorCar.carDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d - %@", (int32_t)[DataManager sharedManager].currentInteriorCarNum + 1, bank.numOfInteriorCar, interiorCar.carDescription];
    }
    
    for (UIImageView * checkImageView in checkImageViews) {
        [checkImageView setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    }

    if ([interiorCar.typeOfCeilingFrame isEqualToString:TypeOfCeilingFrameCeiling]) {
        [checkImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedFrameType = 0;
    } else if ([interiorCar.typeOfCeilingFrame isEqualToString:TypeOfCeilingFrameWall]) {
        [checkImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedFrameType = 1;
    } else {
        selectedFrameType = -1;
    }
    
    otherField.text = @"";
    if ([interiorCar.mount isEqualToString:TypeOfCeilingMountingTypeBolted]) {
        [checkImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedMountType = 2;
    } else if ([interiorCar.mount isEqualToString:TypeOfCeilingMountingTypeWelded]) {
        [checkImageViews[3] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedMountType = 3;
    } else if (interiorCar.mount.length > 0) {
        [checkImageViews[4] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        otherField.text = interiorCar.mount;
        selectedMountType = 4;
    } else {
        selectedMountType = -1;
    }
    
    self.viewDescription = @"Cab Interior\nType of Ceiling frame";
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if (selectedFrameType < 0) {
        return;
    }
    if (selectedMountType < 0) {
        return;
    }
    
    if (selectedMountType == 4 && otherField.text.length == 0) {
        return;
    }
    
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    interiorCar.typeOfCeilingFrame = (selectedFrameType == 0) ? TypeOfCeilingFrameCeiling : TypeOfCeilingFrameWall;
    switch (selectedMountType) {
        case 2:
            interiorCar.mount = TypeOfCeilingMountingTypeBolted;
            break;
        case 3:
            interiorCar.mount = TypeOfCeilingMountingTypeWelded;
            break;
        case 4:
            interiorCar.mount = otherField.text;
            break;
        default:
            return;
    }
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDInteriorCarCeilingEscapeHatchLocation sender:nil];
}

-(IBAction)checkAction:(id)sender
{
    UIButton * btnSelected = (UIButton *) sender;

    UIImageView * imageSelected = checkImageViews[btnSelected.tag];
    if (btnSelected.tag < 2) {
        [checkImageViews[1 - btnSelected.tag] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        selectedFrameType = btnSelected.tag;
    } else {
        [checkImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        [checkImageViews[3] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        [checkImageViews[4] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        selectedMountType = btnSelected.tag;
    }
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    if (btnSelected.tag == 4) {
        [otherField becomeFirstResponder];
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedMountType == 4 && indexPath.row == UICellOther)
        return 130;
    else if(indexPath.row == 2)
        return 44;
    return 70; //130
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
