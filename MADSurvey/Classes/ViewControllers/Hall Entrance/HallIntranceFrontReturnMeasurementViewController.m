//
//  HallIntranceFrontReturnMeasurementViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallIntranceFrontReturnMeasurementViewController.h"

#import "AppDelegate.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallIntranceFrontReturnMeasurementViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField * leftAField;
    IBOutlet UITextField * leftBField;
    IBOutlet UITextField * leftCField;
    IBOutlet UITextField * leftDField;
    IBOutlet UITextField * rightAField;
    IBOutlet UITextField * rightBField;
    IBOutlet UITextField * rightCField;
    IBOutlet UITextField * rightDField;
    IBOutlet UITextField * heightField;
}

@end

@implementation HallIntranceFrontReturnMeasurementViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    leftAField.inputAccessoryView = self.keyboardAccessoryView;
    leftBField.inputAccessoryView = self.keyboardAccessoryView;
    leftCField.inputAccessoryView = self.keyboardAccessoryView;
    leftDField.inputAccessoryView = self.keyboardAccessoryView;
    rightAField.inputAccessoryView = self.keyboardAccessoryView;
    rightBField.inputAccessoryView = self.keyboardAccessoryView;
    rightCField.inputAccessoryView = self.keyboardAccessoryView;
    rightDField.inputAccessoryView = self.keyboardAccessoryView;
    heightField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    leftAField.text = hallEntrance.leftSideA >= 0 ? [formatter stringFromNumber:@(hallEntrance.leftSideA)] : @"";
    leftBField.text = hallEntrance.leftSideB >= 0 ? [formatter stringFromNumber:@(hallEntrance.leftSideB)] : @"";
    leftCField.text = hallEntrance.leftSideC >= 0 ? [formatter stringFromNumber:@(hallEntrance.leftSideC)] : @"";
    leftDField.text = hallEntrance.leftSideD >= 0 ? [formatter stringFromNumber:@(hallEntrance.leftSideD)] : @"";
    rightAField.text = hallEntrance.rightSideA >= 0 ? [formatter stringFromNumber:@(hallEntrance.rightSideA)] : @"";
    rightBField.text = hallEntrance.rightSideB >= 0 ? [formatter stringFromNumber:@(hallEntrance.rightSideB)] : @"";
    rightCField.text = hallEntrance.rightSideC >= 0 ? [formatter stringFromNumber:@(hallEntrance.rightSideC)] : @"";
    rightDField.text = hallEntrance.rightSideD >= 0 ? [formatter stringFromNumber:@(hallEntrance.rightSideD)] : @"";
    heightField.text = hallEntrance.height >= 0 ? [formatter stringFromNumber:@(hallEntrance.height)] : @"";

    self.viewDescription = @"Hall Entrance\nFront Return Measurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [leftAField becomeFirstResponder];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[leftAField, leftBField, leftCField, leftDField, rightAField, rightBField, rightCField, rightDField, heightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double leftA = [leftAField.text doubleValueCheckingEmpty];
        double leftB = [leftBField.text doubleValueCheckingEmpty];
        double leftC = [leftCField.text doubleValueCheckingEmpty];
        double leftD = [leftDField.text doubleValueCheckingEmpty];
        double rightA = [rightAField.text doubleValueCheckingEmpty];
        double rightB = [rightBField.text doubleValueCheckingEmpty];
        double rightC = [rightCField.text doubleValueCheckingEmpty];
        double rightD = [rightDField.text doubleValueCheckingEmpty];
        double height = [heightField.text doubleValueCheckingEmpty];
        
        if (leftA < 0) {
            [self showWarningAlert:@"Please input Left Side A!"];
            [leftAField becomeFirstResponder];
            return;
        }
        if (leftB < 0) {
            [self showWarningAlert:@"Please input Left Side B!"];
            [leftBField becomeFirstResponder];
            return;
        }
        if (leftC < 0) {
            [self showWarningAlert:@"Please input Left Side C!"];
            [leftCField becomeFirstResponder];
            return;
        }
        if (leftD < 0) {
            [self showWarningAlert:@"Please input Left Side D!"];
            [leftDField becomeFirstResponder];
            return;
        }
        if (rightA < 0) {
            [self showWarningAlert:@"Please input Right Side A!"];
            [rightAField becomeFirstResponder];
            return;
        }
        if (rightB < 0) {
            [self showWarningAlert:@"Please input Right Side B!"];
            [rightBField becomeFirstResponder];
            return;
        }
        if (rightC < 0) {
            [self showWarningAlert:@"Please input Right Side C!"];
            [rightCField becomeFirstResponder];
            return;
        }
        if (rightD < 0) {
            [self showWarningAlert:@"Please input Right Side D!"];
            [rightDField becomeFirstResponder];
            return;
        }
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [heightField becomeFirstResponder];
            return;
        }
        
        [self.view endEditing:YES];
        
        Project *project = [DataManager sharedManager].selectedProject;
        Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
        HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
        
        hallEntrance.leftSideA = leftA;
        hallEntrance.leftSideB = leftB;
        hallEntrance.leftSideC = leftC;
        hallEntrance.leftSideD = leftD;
        hallEntrance.rightSideA = rightA;
        hallEntrance.rightSideB = rightB;
        hallEntrance.rightSideC = rightC;
        hallEntrance.rightSideD = rightD;
        hallEntrance.height = height;
        
        [[DataManager sharedManager] saveChanges];
        
        if (hallEntrance.doorType == HallInstranceDoorTypeCenter)
        {
            [self performSegueWithIdentifier:UINavigationIDHallInstranceTransomMeasurementCenter sender:nil];
        }
        else if(hallEntrance.doorType == HallInstranceDoorType1s)
        {
            [self performSegueWithIdentifier:UINavigationIDHallInstranceTransomMeasurement1s sender:nil];

        }
        else {
            [self performSegueWithIdentifier:UINavigationIDHallInstranceTransomMeasurement2s sender:nil];

        }
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

- (void)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Hall Entrance Measurements" withImageName:@"img_help_54_hall_entrance_front_return_measurements_help"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
