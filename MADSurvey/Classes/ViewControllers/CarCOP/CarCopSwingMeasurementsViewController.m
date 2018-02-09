//
//  CarCopSwingMeasurementsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarCopSwingMeasurementsViewController.h"
#import "HelpView.h"
#import "DataManager.h"

@interface CarCopSwingMeasurementsViewController () <UITextFieldDelegate>

@end

@implementation CarCopSwingMeasurementsViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    
    panelWidthField.inputAccessoryView = self.keyboardAccessoryView;
    panelHeightField.inputAccessoryView = self.keyboardAccessoryView;
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

    panelWidthField.text = cop.swingPanelWidth >= 0 ? [formatter stringFromNumber:@(cop.swingPanelWidth)] : @"";
    panelHeightField.text = cop.swingPanelHeight >= 0 ? [formatter stringFromNumber:@(cop.swingPanelHeight)] : @"";
    affField.text = cop.coverAff >= 0 ? [formatter stringFromNumber:@(cop.coverAff)] : @"";

    self.viewDescription = @"COPs\nCOP Swing Measurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [panelWidthField becomeFirstResponder];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([panelWidthField isFirstResponder]) {
        [panelHeightField becomeFirstResponder];
    } else if ([panelHeightField isFirstResponder]) {
        [affField becomeFirstResponder];
    } else {
        double width = [panelWidthField.text doubleValueCheckingEmpty];
        double height = [panelHeightField.text doubleValueCheckingEmpty];
        double aff = [affField.text doubleValueCheckingEmpty];
        
        if (width < 0) {
            [self showWarningAlert:@"Please input Swing Panel Width!"];
            [panelWidthField becomeFirstResponder];
            return;
        }
        if (height < 0) {
            [self showWarningAlert:@"Please input Swing Panel Height!"];
            [panelHeightField becomeFirstResponder];
            return;
        }
        if (aff < 0) {
            [self showWarningAlert:@"Please input Bottom of Panel Above Finished Floor!"];
            [affField becomeFirstResponder];
            return;
        }
        
        Cop *cop = [DataManager sharedManager].currentCop;
        
        cop.swingPanelWidth = width;
        cop.swingPanelHeight = height;
        cop.coverAff = aff;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDCarCopNotesFromSwing sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"COP Measurements" withImageName:@"img_help_31_car_cop_swing_measurements_help"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
