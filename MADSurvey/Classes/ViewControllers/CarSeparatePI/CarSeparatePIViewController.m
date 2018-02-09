//
//  CarSeparatePIViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarSeparatePIViewController.h"
#import "DataManager.h"
#import "CarDescriptionViewController.h"
#import "InteriorCarCountViewController.h"
#import "FloorDescriptionViewController.h"
#import "BankNameViewController.h"
#import "SubmitProjectViewController.h"
#import "EditCarListViewController.h"
#import "FinalViewController.h"

@interface CarSeparatePIViewController ()

@end

@implementation CarSeparatePIViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Separated PI";
    
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
    
    for (UIImageView * comboImageView in comboImageViews) {
        [comboImageView setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    }
    
    if (car.isThereSPI == 1) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else if (car.isThereSPI == 2) {
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender
{
    Car *car = [DataManager sharedManager].currentCar;
    if (car.isThereSPI == 1) {
        [self performSegueWithIdentifier:UINavigationIDCarSeparatePIMounting sender:nil];
    } else if (car.isThereSPI == 2) {
        if ([DataManager sharedManager].isEditing) {
            [self backToSpecificClass:[EditCarListViewController class]];
            return;
        }
        
        NSInteger currentCar = [DataManager sharedManager].currentCarNum;
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

        if (bank.numOfCar > currentCar + 1) {
            [DataManager sharedManager].currentCarNum ++;

            CarDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CarDescriptionViewController"];
            [self backToSpecificViewController:lvc];
        } else {
            if (project.cabInteriors == 1) {
                InteriorCarCountViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"InteriorCarCountViewController"];
                [self.navigationController pushViewController:lvc animated:YES];
            } else if (project.hallEntrances == 1) {
                [DataManager sharedManager].currentFloorNum = 0;
                FloorDescriptionViewController * lvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FloorDescriptionViewController"];
                lvc.fromBank = NO;
                [self.navigationController pushViewController:lvc animated:YES];
            } else {
                if (project.numBanks > [DataManager sharedManager].currentBankIndex + 1) {
                    [DataManager sharedManager].currentFloorNum = 0;
                    [DataManager sharedManager].currentBankIndex ++;

                    BankNameViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"BankNameViewController"];
                    [self backToSpecificViewController:lvc];
                } else {
                    FinalViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"FinalViewController"];
                    [self.navigationController pushViewController:lvc animated:YES];
                }
            }
        }
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
        car.isThereSPI = 1;
    } else {
        car.isThereSPI = 2;
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
