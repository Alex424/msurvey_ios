//
//  InteriorCarDescriptionViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarDescriptionViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarDescriptionViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    IBOutlet UITextField * interiorField;
}
@end

@implementation InteriorCarDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    interiorField.inputAccessoryView = self.keyboardAccessoryView;
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [interiorField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Interior Car Description";

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d", (int32_t)[DataManager sharedManager].currentInteriorCarNum + 1, bank.numOfInteriorCar];
        
        if ([DataManager sharedManager].currentInteriorCarNum > 0) {
            self.backButton.hidden = YES;
            self.keyboardAccessoryView.leftButton.hidden = YES;
        }
    }
    
    InteriorCar *interiorCar = [[DataManager sharedManager] getInteriorCarForBank:bank interiorCarNum:[DataManager sharedManager].currentInteriorCarNum];
    [DataManager sharedManager].currentInteriorCar = interiorCar;
    
    interiorField.text = interiorCar.carDescription ? interiorCar.carDescription : @"";
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSString *description = interiorField.text;
    if (description.length == 0) {
        [self showWarningAlert:@"Please input Car Descriptor!"];
        [interiorField becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    InteriorCar *interiorCar = [[DataManager sharedManager] createNewInteriorCarForBank:bank interiorCarNum:[DataManager sharedManager].currentInteriorCarNum interiorCarDescription:description];
    [DataManager sharedManager].currentInteriorCar = interiorCar;
    
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDInteriorCarLicence sender:nil];
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
