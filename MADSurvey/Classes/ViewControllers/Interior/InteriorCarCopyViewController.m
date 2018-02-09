//
//  InteriorCarCopyViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarCopyViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarCopyViewController ()

@end

@implementation InteriorCarCopyViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Interior Car";
    
    for (UIImageView * comboImageView in comboImageViews) {
        [comboImageView setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    }
    
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
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender
{
    //[self performSegueWithIdentifier:UINavigationIDProjectNumberBanks sender:nil];
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
    
    if (btnSelected.tag == UICellSameAs) {
        [self performSegueWithIdentifier:UINavigationIDInteriorCarExistingList sender:nil];
    } else if (btnSelected.tag == UICellUnique) {
        InteriorCar *car = [DataManager sharedManager].currentInteriorCar;
        NSString *description = car.carDescription;
        NSInteger capacity = car.carCapacity;
        double weight = car.carWeight;
        int32_t noPeople = car.numberOfPeople;
        NSString *installNum = car.installNumber;
        NSString *weightScale = car.weightScale;
        
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        [[DataManager sharedManager] deleteInteriorCar:car];
        
        car = [[DataManager sharedManager] createNewInteriorCarForBank:bank
                                                        interiorCarNum:[DataManager sharedManager].currentInteriorCarNum
                                                interiorCarDescription:description];
        car.carCapacity = capacity;
        car.carWeight = weight;
        car.numberOfPeople = noPeople;
        car.installNumber = installNum;
        car.weightScale = weightScale;
        
        [[DataManager sharedManager] saveChanges];
        [DataManager sharedManager].currentInteriorCar = car;

        [self performSegueWithIdentifier:UINavigationIDInteriorCarCopyUnique sender:nil];
    } else {
        // same as last
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        
        InteriorCar *car = [DataManager sharedManager].currentInteriorCar;
        InteriorCar *lastCar = bank.interiorCars[bank.interiorCars.count - 2];
        
        [[DataManager sharedManager] copyInteriorCar:lastCar to:car];
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorCarCopyUnique sender:nil];
    }
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
