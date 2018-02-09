//
//  HallStationDescriptionViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationDescriptionViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallStationDescriptionViewController () <UITextFieldDelegate>
{
    int selectedIdx;

    IBOutlet UITextField * otherField;
}
@end

@implementation HallStationDescriptionViewController

- (void)viewDidLoad {
    [self setToolbarType:UIToolbarTypeNoNext];
    
    [super viewDidLoad];
    otherField.inputAccessoryView = self.keyboardAccessoryView;

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
    NSString *description;
    
    switch (selectedIdx) {
        case UICellTerminal:
            description = TerminalHallStation;
            break;
        case UICellIntermediate:
            description = IntermediateHallStation;
            break;
        case UICellFireOperation:
            description = FireOperationStation;
            break;
        case UICellEFO:
            description = EPOStation;
            break;
        case UICellAccess:
            description = AccessStation;
            break;
        case UICellSwingHall:
            description = SwingServiceHallStation;
            break;
        case UICellSwingTerminal:
            description = SwingServiceTerminalStation;
            break;
        case UICellOther:
            description = otherField.text;
            break;
        case UICellNoSelected:
            return;
    }
    
    if ([DataManager sharedManager].needToGoBack) {
        [DataManager sharedManager].needToGoBack = NO;
        
        [DataManager sharedManager].currentHallStation.hallStationDescription = description;
        [[DataManager sharedManager] saveChanges];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        
        HallStation *hallStation = [[DataManager sharedManager] getHallStationForBank:bank hallStationNum:[DataManager sharedManager].currentHallStationNum floorNumber:[DataManager sharedManager].floorDescription];
        if (!hallStation) {
            hallStation = [[DataManager sharedManager] createNewHallStationForBank:bank];
            hallStation.hallStationNum = (int32_t)[DataManager sharedManager].currentHallStationNum;
            hallStation.floorNumber = [DataManager sharedManager].floorDescription;
        }
        hallStation.hallStationDescription = description;
        
        [[DataManager sharedManager] saveChanges];
        
        [DataManager sharedManager].currentHallStation = hallStation;
        
        [self performSegueWithIdentifier:UINavigationIDHallStationDescriptionMounting sender:nil];
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
    
    self.navigationController.title = @"Hall Station Description";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    HallStation *hallStation = [[DataManager sharedManager] getHallStationForBank:bank hallStationNum:[DataManager sharedManager].currentHallStationNum floorNumber:[DataManager sharedManager].floorDescription];
    [DataManager sharedManager].currentHallStation = hallStation;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor - %@", [DataManager sharedManager].floorDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
        hallStationLabel.text = [NSString stringWithFormat:@"Hall Station - %d of %d", (int32_t)[DataManager sharedManager].currentHallStationNum + 1, bank.numOfRiser];
    }

    for(UIImageView * img in checkImageViews)
    {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }

    selectedIdx = UICellNoSelected;

    self.toolbarType = UIToolbarTypeNoNext;
    
    if (hallStation && hallStation.hallStationDescription) {
        if ([hallStation.hallStationDescription isEqualToString:TerminalHallStation]) {
            selectedIdx = UICellTerminal;
        } else if ([hallStation.hallStationDescription isEqualToString:IntermediateHallStation]) {
            selectedIdx = UICellIntermediate;
        } else if ([hallStation.hallStationDescription isEqualToString:FireOperationStation]) {
            selectedIdx = UICellFireOperation;
        } else if ([hallStation.hallStationDescription isEqualToString:EPOStation]) {
            selectedIdx = UICellEFO;
        } else if ([hallStation.hallStationDescription isEqualToString:AccessStation]) {
            selectedIdx = UICellAccess;
        } else if ([hallStation.hallStationDescription isEqualToString:SwingServiceHallStation]) {
            selectedIdx = UICellSwingHall;
        } else if ([hallStation.hallStationDescription isEqualToString:SwingServiceTerminalStation]) {
            selectedIdx = UICellSwingTerminal;
        } else {
            selectedIdx = UICellOther;
            otherField.text = hallStation.hallStationDescription;
            
            [otherField becomeFirstResponder];

            self.toolbarType = UIToolbarTypeNormal;
            [self updateToolbar];
        }
        
        UIImageView * imageSelected = checkImageViews[selectedIdx];
        imageSelected.tag = selectedIdx;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    }
    
    [self updateToolbar];

    self.viewDescription = @"Hall Station\nDescription";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIdx == UICellOther && indexPath.row == UICellOther)
        return 130;
    
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
