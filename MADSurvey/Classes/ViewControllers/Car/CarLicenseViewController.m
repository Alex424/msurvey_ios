//
//  CarLicenseViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarLicenseViewController.h"
#import "Constants.h"
#import "WeightSelectView.h"
#import "DataManager.h"

@interface CarLicenseViewController () <UITextFieldDelegate>

@end

@implementation CarLicenseViewController

- (IBAction)kg:(id)sender {
    [self.view endEditing:YES];
    WeightSelectView * sView = [WeightSelectView showOnView:self.tableView.superview];
    sView.kgBlock = ^(void) {
        [weightButton setTitle:@"KG" forState:UIControlStateNormal];
    };
    sView.lbsBlock = ^(void) {
        [weightButton setTitle:@"LBS" forState:UIControlStateNormal];
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    installNoField.inputAccessoryView = self.keyboardAccessoryView;
    capacityNoField.inputAccessoryView = self.keyboardAccessoryView;
    peopleNoField.inputAccessoryView = self.keyboardAccessoryView;
    
    [weightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    weightButton.backgroundColor = [UIColor whiteColor];
    weightButton.layer.cornerRadius = 4;
    // image inset
    [weightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -75)];
    [weightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car License";

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

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    installNoField.text = car.installNumber ? car.installNumber : @"";
    capacityNoField.text = car.capacityWeight >= 0 ? [formatter stringFromNumber:@(car.capacityWeight)] : @"";
    peopleNoField.text = car.capacityNumberPersons > 0 ? [NSString stringWithFormat:@"%d", car.capacityNumberPersons] : @"";
    if (car.weightScale) {
        [weightButton setTitle:car.weightScale forState:UIControlStateNormal];
    }

    self.viewDescription = @"COPs\nCar License";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [installNoField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([installNoField isFirstResponder]) {
        [capacityNoField becomeFirstResponder];
    } else if ([capacityNoField isFirstResponder]) {
        [peopleNoField becomeFirstResponder];
    } else {
        NSString *installNo = installNoField.text;
        double capacity = [capacityNoField.text doubleValueCheckingEmpty];
        NSInteger people = [peopleNoField.text integerValue];
        
        if (installNo.length == 0) {
            [self showWarningAlert:@"Please input Car Install No!"];
            [installNoField becomeFirstResponder];
            return;
        }
        
        if (capacity < 0) {
            [self showWarningAlert:@"Please input Car Capacity!"];
            [capacityNoField becomeFirstResponder];
            return;
        }
        
        if (people <= 0) {
            [self showWarningAlert:@"Please input Number Of People!"];
            [peopleNoField becomeFirstResponder];
            return;
        }
        
        Car *car = [DataManager sharedManager].currentCar;
        car.installNumber = installNo;
        car.capacityWeight = capacity;
        car.capacityNumberPersons = (int32_t)people;
        car.weightScale = [weightButton titleForState:UIControlStateNormal];
        
        [self performSegueWithIdentifier:UINavigationIDCarType sender:nil];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
