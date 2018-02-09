//
//  HallStationWallMaterialViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationWallMaterialViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallStationWallMaterialViewController () <UITextFieldDelegate>
{
    int selectedIdx;
    
    IBOutlet UITextField * otherField;
}
@end

@implementation HallStationWallMaterialViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    [super viewDidLoad];
    
    otherField.inputAccessoryView = self.keyboardAccessoryView;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSString *wall;
    
    switch (selectedIdx) {
        case UICellDrywall:
            wall = HallStationDryWall;
            break;
        case UICellPlaster:
            wall = HallStationPlaster;
            break;
        case UICellConcrete:
            wall = HallStationConcrete;
            break;
        case UICellBrick:
            wall = HallStationBrick;
            break;
        case UICellMarble:
            wall = HallStationMarble;
            break;
        case UICellGranit:
            wall = HallStationGranit;
            break;
        case UICellGlass:
            wall = HallStationGlass;
            break;
        case UICellTile:
            wall = HallStationTile;
            break;
        case UICellMetal:
            wall = HallStationMetal;
            break;
        case UICellWood:
            wall = HallStationWood;
            break;
        case UICellOther:
            wall = otherField.text;
            break;
        case UICellNoSelected:
            return;
    }
    
    [DataManager sharedManager].currentHallStation.wallFinish = wall;
    [[DataManager sharedManager] saveChanges];
    
    [otherField resignFirstResponder];
    
    if ([DataManager sharedManager].needToGoBack) {
        [DataManager sharedManager].needToGoBack = NO;

        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:UINavigationIDHallStationMaterialMeasure sender:nil];
    }
}

-(IBAction)checkAction:(id)sender
{
    for(UIImageView * img in checkImageViews)
    {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }
    
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = checkImageViews[btnSelected.tag];
    if(btnSelected.tag == imageSelected.tag)
    {
        imageSelected.tag = UICellNoSelected;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        
        selectedIdx = UICellNoSelected;
        
    }
    else{
        imageSelected.tag = btnSelected.tag;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedIdx = (int) btnSelected.tag;
        
        if(selectedIdx != UICellOther) {
            self.toolbarType = UIToolbarTypeNoNext;
            [self updateToolbar];

            [self next:nil];
        } else {
            self.toolbarType = UIToolbarTypeNormal;
            [self updateToolbar];
        }
        
    }
    [self.tableView reloadData];
    if(selectedIdx == UICellOther)
        [otherField becomeFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Hall Station Wall Material";

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

    self.toolbarType = UIToolbarTypeNoNext;

    NSString *wall = [DataManager sharedManager].currentHallStation.wallFinish;
    if ([wall isEqualToString:HallStationDryWall]) {
        selectedIdx = UICellDrywall;
    } else if ([wall isEqualToString:HallStationPlaster]) {
        selectedIdx = UICellPlaster;
    } else if ([wall isEqualToString:HallStationConcrete]) {
        selectedIdx = UICellConcrete;
    } else if ([wall isEqualToString:HallStationBrick]) {
        selectedIdx = UICellBrick;
    } else if ([wall isEqualToString:HallStationMarble]) {
        selectedIdx = UICellMarble;
    } else if ([wall isEqualToString:HallStationGranit]) {
        selectedIdx = UICellGranit;
    } else if ([wall isEqualToString:HallStationGlass]) {
        selectedIdx = UICellGlass;
    } else if ([wall isEqualToString:HallStationTile]) {
        selectedIdx = UICellTile;
    } else if ([wall isEqualToString:HallStationMetal]) {
        selectedIdx = UICellMetal;
    } else if ([wall isEqualToString:HallStationWood]) {
        selectedIdx = UICellWood;
    } else if (wall != nil) {
        selectedIdx = UICellOther;
        otherField.text = wall;
        
        [otherField becomeFirstResponder];

        self.toolbarType = UIToolbarTypeNormal;
    } else {
        selectedIdx = UICellNoSelected;
    }

    [self updateToolbar];

    for(UIImageView * img in checkImageViews)
    {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }
    
    if (selectedIdx != UICellNoSelected) {
        UIImageView *imageView = checkImageViews[selectedIdx];
        [imageView setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        imageView.tag = selectedIdx;
    }
    
    self.viewDescription = @"Hall Station\nWall Material";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIdx == UICellOther && indexPath.row == UICellOther)
        return 130;
    
    return 70; //130
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
