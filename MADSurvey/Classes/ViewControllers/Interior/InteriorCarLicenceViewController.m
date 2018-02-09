//
//  InteriorCarLicenceViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarLicenceViewController.h"
#import "WeightSelectView.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarLicenceViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UIButton * kgBtn;
    IBOutlet UITextField * elevatorNoField;
    IBOutlet UITextField * carCapacityField;
    IBOutlet UITextField * noOfPeopleField;
    IBOutlet UITextField * carWeightField;
}

@end

@implementation InteriorCarLicenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [kgBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -75)];
    [kgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    kgBtn.layer.cornerRadius = 5.0f;
    
    elevatorNoField.inputAccessoryView = self.keyboardAccessoryView;
    carCapacityField.inputAccessoryView = self.keyboardAccessoryView;
    noOfPeopleField.inputAccessoryView = self.keyboardAccessoryView;
    carWeightField.inputAccessoryView = self.keyboardAccessoryView;
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [elevatorNoField becomeFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Interior Car License";

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
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    carCapacityField.text = interiorCar.carCapacity >= 0 ? [formatter stringFromNumber:@(interiorCar.carCapacity)] : @"";
    carWeightField.text = interiorCar.carWeight >= 0 ? [formatter stringFromNumber:@(interiorCar.carWeight)] : @"";
    noOfPeopleField.text = interiorCar.numberOfPeople > 0 ? [NSString stringWithFormat:@"%d", interiorCar.numberOfPeople] : @"";
    elevatorNoField.text = interiorCar.installNumber;
    [kgBtn setTitle:interiorCar.weightScale forState:UIControlStateNormal];

    self.viewDescription = @"Cab Interior\nCar License";
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[elevatorNoField, carCapacityField, noOfPeopleField, carWeightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double carCapacity = [carCapacityField.text doubleValueCheckingEmpty];
        double carWeight = [carWeightField.text doubleValueCheckingEmpty];
        NSInteger noPeople = [noOfPeopleField.text integerValue];
        NSString *elevatorNo = elevatorNoField.text;
        
        if (elevatorNo.length == 0) {
            [self showWarningAlert:@"Please input Car Install No!"];
            [elevatorNoField becomeFirstResponder];
            return;
        }
        
        if  (carCapacity < 0) {
            [self showWarningAlert:@"Please input Car Capacity!"];
            [carCapacityField becomeFirstResponder];
            return;
        }
        
        if (noPeople <= 0) {
            [self showWarningAlert:@"Please input Number Of People!"];
            [noOfPeopleField becomeFirstResponder];
            return;
        }
        
        if (carWeight < 0) {
            [self showWarningAlert:@"Please input Car Weight!"];
            [carWeightField becomeFirstResponder];
            return;
        }
        
        InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
        
        interiorCar.carCapacity = carCapacity;
        interiorCar.carWeight = carWeight;
        interiorCar.numberOfPeople = (int32_t)noPeople;
        interiorCar.installNumber = elevatorNo;
        interiorCar.weightScale = [kgBtn titleForState:UIControlStateNormal];
        
        [[DataManager sharedManager] saveChanges];
        
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        if ((![DataManager sharedManager].isEditing || [DataManager sharedManager].addingType == AddingInteriorCar) && bank.interiorCars.count > 1) {
            [self performSegueWithIdentifier:UINavigationIDInteriorCarCopy sender:nil];
        } else {
            [self performSegueWithIdentifier:UINavigationIDInteriorCarBackDoor sender:nil];
        }
    }
}

-(IBAction)kgAction:(id)sender{
    [self.view endEditing:YES];
    WeightSelectView * sView = [WeightSelectView showOnView:self.tableView.superview];
    sView.kgBlock = ^(void) {
        [kgBtn setTitle:@"KG" forState:UIControlStateNormal];
    };
    sView.lbsBlock = ^(void) {
        [kgBtn setTitle:@"LBS" forState:UIControlStateNormal];
    };
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
