//
//  InteriorCarFrontReturnTypeViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarFrontReturnTypeViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarFrontReturnTypeViewController ()
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    int selectedIdx;

}

@end

@implementation InteriorCarFrontReturnTypeViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeNoNext;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    
    if (selectedIdx == UICellA) {
        door.typeOfFrontReturn = TypeOfFrontReturnA;
        [[DataManager sharedManager] saveChanges];
        
        if ([DataManager sharedManager].currentCenterOpening == 1) {
            [self performSegueWithIdentifier:UINavigationIDInteriorCarCenterReturnMeasurementsA sender:nil];
        } else {
            [self performSegueWithIdentifier:UINavigationIDInteriorCarSingleSideReturnMeasurementsA sender:nil];
        }
    } else if (selectedIdx == UICellB) {
        door.typeOfFrontReturn = TypeOfFrontReturnB;
        [[DataManager sharedManager] saveChanges];
        
        if ([DataManager sharedManager].currentCenterOpening == 1) {
            [self performSegueWithIdentifier:UINavigationIDInteriorCarCenterReturnMeasurementsB sender:nil];
        } else {
            [self performSegueWithIdentifier:UINavigationIDInteriorCarSingleSideReturnMeasurementsB sender:nil];
        }
    } else if (selectedIdx == UICellOther) {
        door.typeOfFrontReturn = TypeOfFrontReturnOther;
        [[DataManager sharedManager] saveChanges];
        
        //Other Page
        [self performSegueWithIdentifier:UINavigationIDInteriorCarFrontReturnMeasurementsOther sender:nil];
    }
}

-(IBAction)checkAction:(id)sender {
    for (UIImageView * img in checkImageViews) {
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
    } else {
        imageSelected.tag = btnSelected.tag;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedIdx = (int) btnSelected.tag;
        
        [self next:nil];        
    }
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    for (UIImageView * img in checkImageViews) {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }

    if ([door.typeOfFrontReturn isEqualToString:TypeOfFrontReturnA]) {
        selectedIdx = UICellA;
    } else if ([door.typeOfFrontReturn isEqualToString:TypeOfFrontReturnB]) {
        selectedIdx = UICellB;
    } else if ([door.typeOfFrontReturn isEqualToString:TypeOfFrontReturnOther]) {
        selectedIdx = UICellOther;
    } else {
        selectedIdx = UICellNoSelected;
        return;
    }
    
    [checkImageViews[selectedIdx] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
}

@end
