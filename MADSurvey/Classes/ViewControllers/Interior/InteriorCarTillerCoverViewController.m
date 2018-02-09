//
//  InteriorCarTillerCoverViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarTillerCoverViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarTillerCoverViewController ()

@end

@implementation InteriorCarTillerCoverViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeNoNext;

    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Interior Car Tiller Cover";
    
    [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    
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
    
    if (interiorCar.carTiller == 1) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else if (interiorCar.carTiller == 2) {
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    }
}
-(IBAction)comboAction:(id)sender
{
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = comboImageViews[btnSelected.tag];
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    if (btnSelected.tag == 0) {
        interiorCar.carTiller = 1;
    } else {
        interiorCar.carTiller = 2;
    }
    [[DataManager sharedManager] saveChanges];
    
    [self performSelector:@selector(next:) withObject:nil afterDelay:0.1];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDInteriorCarFloorHeight sender:nil];
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
