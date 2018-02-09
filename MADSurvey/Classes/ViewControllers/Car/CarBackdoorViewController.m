//
//  CarBackdoorViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarBackdoorViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface CarBackdoorViewController ()

@end

@implementation CarBackdoorViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Backdoor";
    
    for (UIImageView * comboImageView in comboImageViews) {
        [comboImageView setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    }

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
    
    if (car.isThereRearDoor == 1) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else if (car.isThereRearDoor == 2) {
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender
{
    Car *car = [DataManager sharedManager].currentCar;
    
    if (car.isThereRearDoor == 1) {
        [self performSegueWithIdentifier:UINavigationIDCarDoorCoinciding sender:nil];
    } else {
        [self performSegueWithIdentifier:UINavigationIDCarTypePushButtons sender:nil];
    }
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
    
    Car *car = [DataManager sharedManager].currentCar;
    
    if (btnSelected.tag == 0) {
        car.isThereRearDoor = 1;
        car.doorsCoinciding = @"";
    } else {
        car.isThereRearDoor = 2;
        car.doorsCoinciding = CarDoorNonCoinciding;
        
        car.rearDoorOpeningHeight = -1;
        car.rearDoorSlideJambWidth = -1;
        car.rearDoorStrikeJambWidth = -1;
    }
    
    [[DataManager sharedManager] saveChanges];

    [self performSelector:@selector(next:) withObject:nil afterDelay:0.1];
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
