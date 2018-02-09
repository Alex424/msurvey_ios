//
//  CarCopAppliedMeasurementsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarCopAppliedMeasurementsViewController.h"
#import "HelpView.h"
#import "AppDelegate.h"
#import "DataManager.h"

@interface CarCopAppliedMeasurementsViewController () <UITextFieldDelegate>

@end

@implementation CarCopAppliedMeasurementsViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    
    returnWidthField.inputAccessoryView = self.keyboardAccessoryView;
    returnHeightField.inputAccessoryView = self.keyboardAccessoryView;
    copWidthField.inputAccessoryView = self.keyboardAccessoryView;
    copHeightField.inputAccessoryView = self.keyboardAccessoryView;
    coverToOpeningField.inputAccessoryView = self.keyboardAccessoryView;
    affField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car COP Measurements";

    Project *project = [DataManager sharedManager].selectedProject;
    Car *car = [DataManager sharedManager].currentCar;
    
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
    }
    carLabel.text = [NSString stringWithFormat:@"COP %d of %d - %@", (int32_t)[DataManager sharedManager].currentCopNum + 1, car.numberOfCops, car.carNumber];
    
    Cop *cop = [DataManager sharedManager].currentCop;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    returnWidthField.text = cop.returnPanelWidth >= 0 ? [formatter stringFromNumber:@(cop.returnPanelWidth)] : @"";
    returnHeightField.text = cop.returnPanelHeight >= 0 ? [formatter stringFromNumber:@(cop.returnPanelHeight)] : @"";
    copWidthField.text = cop.coverWidth >= 0 ? [formatter stringFromNumber:@(cop.coverWidth)] : @"";
    copHeightField.text = cop.coverHeight >= 0 ? [formatter stringFromNumber:@(cop.coverHeight)] : @"";
    coverToOpeningField.text = cop.coverToOpening >= 0 ? [formatter stringFromNumber:@(cop.coverToOpening)] : @"";
    affField.text = cop.coverAff >= 0 ? [formatter stringFromNumber:@(cop.coverAff)] : @"";

    self.viewDescription = @"COPs\nCOP Applied Measurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [returnWidthField becomeFirstResponder];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([returnWidthField isFirstResponder]) {
        [returnHeightField becomeFirstResponder];
    } else if ([returnHeightField isFirstResponder]) {
        [copWidthField becomeFirstResponder];
    } else if ([copWidthField isFirstResponder]) {
        [copHeightField becomeFirstResponder];
    } else if ([copHeightField isFirstResponder]) {
        [coverToOpeningField becomeFirstResponder];
    } else if ([coverToOpeningField isFirstResponder]) {
        [affField becomeFirstResponder];
    } else {
        double returnWidth = [returnWidthField.text doubleValueCheckingEmpty];
        double returnHeight = [returnHeightField.text doubleValueCheckingEmpty];
        double copWidth = [copWidthField.text doubleValueCheckingEmpty];
        double copHeight = [copHeightField.text doubleValueCheckingEmpty];
        double coverToOpening = [coverToOpeningField.text doubleValueCheckingEmpty];
        double aff = [affField.text doubleValueCheckingEmpty];
        
        if (returnWidth < 0) {
            [self showWarningAlert:@"Please input Return Panel Width!"];
            [returnWidthField becomeFirstResponder];
            return;
        }
        
        if (returnHeight < 0) {
            [self showWarningAlert:@"Please input Return Panel Height!"];
            [returnHeightField becomeFirstResponder];
            return;
        }
        
        if (copWidth < 0) {
            [self showWarningAlert:@"Please input COP Width!"];
            [copWidthField becomeFirstResponder];
            return;
        }
        
        if (copHeight < 0) {
            [self showWarningAlert:@"Please input COP Height!"];
            [copHeightField becomeFirstResponder];
            return;
        }
        
        if (coverToOpening < 0) {
            [self showWarningAlert:@"Please input Cover To Opening!"];
            [coverToOpeningField becomeFirstResponder];
            return;
        }
        
        if (aff < 0) {
            [self showWarningAlert:@"Please input Bottom of Panel Above Finished Floor!"];
            [affField becomeFirstResponder];
            return;
        }
        
        Cop *cop = [DataManager sharedManager].currentCop;
        
        cop.returnPanelWidth = returnWidth;
        cop.returnPanelHeight = returnHeight;
        cop.coverWidth = copWidth;
        cop.coverHeight = copHeight;
        cop.coverToOpening = coverToOpening;
        cop.coverAff = aff;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDCarCopNotesFromApplied sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"COP Measurements" withImageName:@"img_help_31_car_cop_applied_measurements_help"];
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
