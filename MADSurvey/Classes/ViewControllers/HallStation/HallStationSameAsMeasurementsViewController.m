//
//  HallStationSameAsMeasurementsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationSameAsMeasurementsViewController.h"
#import "Constants.h"
#import "HelpView.h"
#import "DataManager.h"

@interface HallStationSameAsMeasurementsViewController () <UITextFieldDelegate>

@end

@implementation HallStationSameAsMeasurementsViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    affField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Hall Station AFF";

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor - %@", [DataManager sharedManager].floorDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
        hallStationLabel.text = [NSString stringWithFormat:@"Hall Station - %d of %d", (int32_t)[DataManager sharedManager].currentHallStationNum + 1, bank.numOfRiser];
    }
    
    HallStation *hallStation = [DataManager sharedManager].currentHallStation;
    if (hallStation) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.usesGroupingSeparator = NO;

        affField.text = hallStation.affValue >= 0 ? [formatter stringFromNumber:@(hallStation.affValue)] : @"";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [affField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    double affValue = [affField.text doubleValueCheckingEmpty];
    if (affValue < 0) {
        [self showWarningAlert:@"Please input Aff Value!"];
        [affField becomeFirstResponder];
        return;
    }
    
    [DataManager sharedManager].currentHallStation.affValue = affValue;
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDHallStationSameAsMeasureReview sender:nil];
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];

    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Hall Station" withImageName:@"img_help_15_hallstation_sameas_measurements_help"];
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
