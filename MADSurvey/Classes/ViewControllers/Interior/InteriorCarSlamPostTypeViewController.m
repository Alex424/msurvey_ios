//
//  InteriorCarSlamPostTypeViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarSlamPostTypeViewController.h"
#import "DataManager.h"

@interface InteriorCarSlamPostTypeViewController ()
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;   
    int selectedIdx;
}
@end

@implementation InteriorCarSlamPostTypeViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeNoNext;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    otherField.inputAccessoryView = self.keyboardAccessoryView;

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car Slam Post Type";
    
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
    
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    
    if ([door.typeOfSlamPost isEqualToString:TypeOfSlamPostA]) {
        selectedIdx = 0;
    } else if ([door.typeOfSlamPost isEqualToString:TypeOfSlamPostB]) {
        selectedIdx = 1;
    } else if ([door.typeOfSlamPost isEqualToString:TypeOfSlamPostC]) {
        selectedIdx = 2;
    } else if ([door.typeOfSlamPost isEqualToString:TypeOfSlamPostOther]) {
        selectedIdx = 3;
    } else {
        selectedIdx = -1;
    }
    
    for(UIImageView * img in checkImageViews) {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }
    if (selectedIdx >= 0) {
        [checkImageViews[selectedIdx] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        [checkImageViews[selectedIdx] setTag:selectedIdx];
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    
    NSLog(@"%@", [NSString stringWithFormat:@"%d", selectedIdx]);
    NSString *type = @"";
    
    switch (selectedIdx) {
        case UICellA:
            type = @"A";
            [self performSegueWithIdentifier:UINavigationIDInteriorCarSlamPostTypeA sender:nil];
            break;
        case UICellB:
            type = @"B";
            [self performSegueWithIdentifier:UINavigationIDInteriorCarSlamPostTypeB sender:nil];
            break;
        case UICellC:
            type = @"C";
            [self performSegueWithIdentifier:UINavigationIDInteriorCarSlamPostTypeC sender:nil];
            break;
        case UICellOther:
            type = @"Other";
            [self performSegueWithIdentifier:UINavigationIDInteriorCarSlamPostTypeOther sender:nil];
            break;
        default:
            break;
    }
    
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    door.typeOfSlamPost = type;
    [[DataManager sharedManager] saveChanges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)checkAction:(id)sender
{
    
    for(UIImageView * img in checkImageViews)
    {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }
    
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = checkImageViews[(btnSelected.tag)];
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

        [self next:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
