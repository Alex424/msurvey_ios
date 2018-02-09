//
//  CarTypeViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarTypeViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface CarTypeViewController () <UITextFieldDelegate>
{
    int selectedIdx;
    
    IBOutlet UITextField * otherField;
}

@end

@implementation CarTypeViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    [super viewDidLoad];
    
    otherField.inputAccessoryView = self.keyboardAccessoryView;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSString *type;
    switch (selectedIdx) {
        case UICellPassenger:
            type = CarPassengerElevator;
            break;
        case UICellFreight:
            type = CarFreightElevator;
            break;
        case UICellService:
            type = CarServiceElevator;
            break;
        case UICellOther:
            type = otherField.text;
            break;
        default:
            type = @"";
            break;
    }
    
    [DataManager sharedManager].currentCar.carDescription = type;
    [[DataManager sharedManager] saveChanges];
    
    [otherField resignFirstResponder];
    
    [self performSegueWithIdentifier:UINavigationIDCarBackdoor sender:nil];
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
    
    self.navigationController.title = @"Car Type";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    Car *car = [DataManager sharedManager].currentCar;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car - %@", car.carNumber];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d - %@", (int32_t)[DataManager sharedManager].currentCarNum + 1, bank.numOfCar, car.carNumber];
    }

    for (UIImageView * img in checkImageViews) {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }

    self.toolbarType = UIToolbarTypeNoNext;

    if ([car.carDescription isEqualToString:CarServiceElevator]) {
        selectedIdx = UICellService;
        [checkImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        [checkImageViews[1] setTag:selectedIdx];
    } else if ([car.carDescription isEqualToString:CarFreightElevator]) {
        selectedIdx = UICellFreight;
        [checkImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        [checkImageViews[2] setTag:selectedIdx];
    } else if ([car.carDescription isEqualToString:CarPassengerElevator]) {
        selectedIdx = UICellPassenger;
        [checkImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        [checkImageViews[0] setTag:selectedIdx];
    } else if (car.carDescription.length > 0) {
        selectedIdx = UICellOther;
        otherField.text = car.carDescription;
        [checkImageViews[3] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        [checkImageViews[3] setTag:selectedIdx];

        self.toolbarType = UIToolbarTypeNormal;
    }

    [self updateToolbar];
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
