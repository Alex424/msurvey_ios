
//
//  InteriorCarFlooringViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarFlooringViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarFlooringViewController () <UITextFieldDelegate>
{
    int selectedIdx;
    
    IBOutlet UITextField * otherField;
}

@end

@implementation InteriorCarFlooringViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    otherField.inputAccessoryView = self.keyboardAccessoryView;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car Flooring";
    
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
    
    for(UIImageView * img in checkImageViews)
    {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }

    self.toolbarType = UIToolbarTypeNoNext;

    if ([interiorCar.carFlooring isEqualToString:FlooringCeramic]) {
        selectedIdx = UICellCeramic;
    } else if ([interiorCar.carFlooring isEqualToString:FlooringGranit]) {
        selectedIdx = UICellGranit;
    } else if ([interiorCar.carFlooring isEqualToString:FlooringMarble]) {
        selectedIdx = UICellMarble;
    } else if ([interiorCar.carFlooring isEqualToString:FlooringPorcelain]) {
        selectedIdx = UICellPorcelain;
    } else if ([interiorCar.carFlooring isEqualToString:FlooringRubberTiles]) {
        selectedIdx = UICellRubberTiles;
    } else if (interiorCar.carFlooring) {
        otherField.text = interiorCar.carFlooring;
        selectedIdx = UICellOther;
        self.toolbarType = UIToolbarTypeNormal;
    } else {
        selectedIdx = UICellNoSelected;
        return;
    }

    [self updateToolbar];

    UIImageView *imageSelected = checkImageViews[selectedIdx - 1];
    imageSelected.tag = selectedIdx;
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];

    self.viewDescription = @"Cab Interior\nCar Interior Flooring";
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSString *flooring;
    
    switch (selectedIdx) {
        case UICellCeramic:
            flooring = FlooringCeramic;
            break;
        case UICellGranit:
            flooring = FlooringGranit;
            break;
        case UICellMarble:
            flooring = FlooringMarble;
            break;
        case UICellPorcelain:
            flooring = FlooringPorcelain;
            break;
        case UICellRubberTiles:
            flooring = FlooringRubberTiles;
            break;
        case UICellOther:
            flooring = otherField.text;
            break;
        default:
            return;
    }
    
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    interiorCar.carFlooring = flooring;
    
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDInteriorCarTillerCover sender:nil];
}

-(IBAction)checkAction:(id)sender
{
    
    for(UIImageView * img in checkImageViews)
    {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }
    
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = checkImageViews[(btnSelected.tag - 1)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIdx == UICellOther && indexPath.row == (UICellOther - 1))
        return 130;
    
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
