//
//  HallInstranseTransomMeasurement2sViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallInstranseTransomMeasurement2sViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "DataManager.h"

@interface HallInstranseTransomMeasurement2sViewController ()
{
    IBOutlet UITextField * aField;
    IBOutlet UITextField * bField;
    IBOutlet UITextField * cField;
    IBOutlet UITextField * dField;
    IBOutlet UITextField * eField;
    IBOutlet UITextField * fField;
    IBOutlet UITextField * gField;
    IBOutlet UITextField * hField;
    IBOutlet UITextField * iField;

}

@end

@implementation HallInstranseTransomMeasurement2sViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    aField.inputAccessoryView = self.keyboardAccessoryView;
    bField.inputAccessoryView = self.keyboardAccessoryView;
    cField.inputAccessoryView = self.keyboardAccessoryView;
    dField.inputAccessoryView = self.keyboardAccessoryView;
    eField.inputAccessoryView = self.keyboardAccessoryView;
    fField.inputAccessoryView = self.keyboardAccessoryView;
    gField.inputAccessoryView = self.keyboardAccessoryView;
    hField.inputAccessoryView = self.keyboardAccessoryView;
    iField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.navigationController.title = @"Interior Car Structure";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor - %@", [DataManager sharedManager].floorDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
        carNumberLabel.text = [NSString stringWithFormat:@"Car %d of %d", (int32_t)[DataManager sharedManager].currentHallEntranceCarNum + 1, bank.numOfCar];
    }
    
    HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    aField.text = hallEntrance.transomMeasurementsA >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsA)] : @"";
    bField.text = hallEntrance.transomMeasurementsB >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsB)] : @"";
    cField.text = hallEntrance.transomMeasurementsC >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsC)] : @"";
    dField.text = hallEntrance.transomMeasurementsD >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsD)] : @"";
    eField.text = hallEntrance.transomMeasurementsE >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsE)] : @"";
    fField.text = hallEntrance.transomMeasurementsF >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsF)] : @"";
    gField.text = hallEntrance.transomMeasurementsG >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsG)] : @"";
    hField.text = hallEntrance.transomMeasurementsH >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsH)] : @"";
    iField.text = hallEntrance.transomMeasurementsI >= 0 ? [formatter stringFromNumber:@(hallEntrance.transomMeasurementsI)] : @"";

    self.viewDescription = @"Hall Entrance\nTransom Measurements 2S";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [aField becomeFirstResponder];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[aField, bField, cField, dField, eField, fField, gField, hField, iField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double a = [aField.text doubleValueCheckingEmpty];
        double b = [bField.text doubleValueCheckingEmpty];
        double c = [cField.text doubleValueCheckingEmpty];
        double d = [dField.text doubleValueCheckingEmpty];
        double e = [eField.text doubleValueCheckingEmpty];
        double f = [fField.text doubleValueCheckingEmpty];
        double g = [gField.text doubleValueCheckingEmpty];
        double h = [hField.text doubleValueCheckingEmpty];
        double i = [iField.text doubleValueCheckingEmpty];

        if (a < 0) {
            [self showWarningAlert:@"Please input A!"];
            [aField becomeFirstResponder];
            return;
        }
        if (b < 0) {
            [self showWarningAlert:@"Please input B!"];
            [bField becomeFirstResponder];
            return;
        }
        if (c < 0) {
            [self showWarningAlert:@"Please input C!"];
            [cField becomeFirstResponder];
            return;
        }
        if (d < 0) {
            [self showWarningAlert:@"Please input D!"];
            [dField becomeFirstResponder];
            return;
        }
        if (e < 0) {
            [self showWarningAlert:@"Please input E!"];
            [eField becomeFirstResponder];
            return;
        }
        if (f < 0) {
            [self showWarningAlert:@"Please input F!"];
            [fField becomeFirstResponder];
            return;
        }
        if (g < 0) {
            [self showWarningAlert:@"Please input G!"];
            [gField becomeFirstResponder];
            return;
        }
        if (h < 0) {
            [self showWarningAlert:@"Please input H!"];
            [hField becomeFirstResponder];
            return;
        }
        if (i < 0) {
            [self showWarningAlert:@"Please input I!"];
            [iField becomeFirstResponder];
            return;
        }

        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
        
        hallEntrance.transomMeasurementsA = a;
        hallEntrance.transomMeasurementsB = b;
        hallEntrance.transomMeasurementsC = c;
        hallEntrance.transomMeasurementsD = d;
        hallEntrance.transomMeasurementsE = e;
        hallEntrance.transomMeasurementsF = f;
        hallEntrance.transomMeasurementsG = g;
        hallEntrance.transomMeasurementsH = h;
        hallEntrance.transomMeasurementsI = i;

        [[DataManager sharedManager] saveChanges];

        [self performSegueWithIdentifier:UINavigationIDHallInstrance2sNotes sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Hall Entrance Measurements" withImageName:@"img_help_55_hall_entrance_transom_measurements_2s_help"];
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
