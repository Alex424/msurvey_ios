//
//  InteriorCarAuxCopReturnViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarAuxCopReturnViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface InteriorCarAuxCopReturnViewController () <UITextFieldDelegate>
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutlet UITextField * widthField;
    IBOutlet UITextField * heightField;
    IBOutlet UITextField * leftField;
    IBOutlet UITextField * rightField;
    IBOutlet UITextField * topField;
    IBOutlet UITextField * bottomField;
    IBOutlet UITextField * throatField;
    IBOutlet UITextField * returnField;

}

@end

@implementation InteriorCarAuxCopReturnViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    widthField.inputAccessoryView = self.keyboardAccessoryView;
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    leftField.inputAccessoryView = self.keyboardAccessoryView;
    rightField.inputAccessoryView = self.keyboardAccessoryView;
    topField.inputAccessoryView = self.keyboardAccessoryView;
    bottomField.inputAccessoryView = self.keyboardAccessoryView;
    throatField.inputAccessoryView = self.keyboardAccessoryView;
    returnField.inputAccessoryView = self.keyboardAccessoryView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[widthField, heightField, leftField, rightField, topField, bottomField, throatField, returnField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double width = [widthField.text doubleValueCheckingEmpty];
        double height = [heightField.text doubleValueCheckingEmpty];
        double left = [leftField.text doubleValueCheckingEmpty];
        double right = [rightField.text doubleValueCheckingEmpty];
        double top = [topField.text doubleValueCheckingEmpty];
        double bottom = [bottomField.text doubleValueCheckingEmpty];
        double throat = [throatField.text doubleValueCheckingEmpty];
        double ret = [returnField.text doubleValueCheckingEmpty];
        
        if (width < 0) {
            [self showWarningAlert:@"Please input Width!"];
            [widthField becomeFirstResponder];
            return;
        }
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [heightField becomeFirstResponder];
            return;
        }
        if (left < 0) {
            [self showWarningAlert:@"Please input Left!"];
            [leftField becomeFirstResponder];
            return;
        }
        if (right < 0) {
            [self showWarningAlert:@"Please input Right!"];
            [rightField becomeFirstResponder];
            return;
        }
        if (top < 0) {
            [self showWarningAlert:@"Please input Top!"];
            [topField becomeFirstResponder];
            return;
        }
        if (bottom < 0) {
            [self showWarningAlert:@"Please input Bottom!"];
            [bottomField becomeFirstResponder];
            return;
        }
        if (throat < 0) {
            [self showWarningAlert:@"Please input Throat!"];
            [throatField becomeFirstResponder];
            return;
        }
        if (ret < 0) {
            [self showWarningAlert:@"Please input Return!"];
            [returnField becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        
        door.auxCopWidth = width;
        door.auxCopHeight = height;
        door.auxCopLeft = left;
        door.auxCopRight = right;
        door.auxCopTop = top;
        door.auxCopBottom = bottom;
        door.auxCopThroat = throat;
        door.auxCopReturn = ret;
        
        [[DataManager sharedManager] saveChanges];

        [self performSegueWithIdentifier:UINavigationIDINteriorCarTransomNotes sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Interior Car Measurements" withImageName:@"img_help_50_interior_car_auxcop_return_help"];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    widthField.text = door.auxCopWidth >= 0 ? [formatter stringFromNumber:@(door.auxCopWidth)] : @"";
    heightField.text = door.auxCopHeight >= 0 ? [formatter stringFromNumber:@(door.auxCopHeight)] : @"";
    leftField.text = door.auxCopLeft >= 0 ? [formatter stringFromNumber:@(door.auxCopLeft)] : @"";
    rightField.text = door.auxCopRight >= 0 ? [formatter stringFromNumber:@(door.auxCopRight)] : @"";
    topField.text = door.auxCopTop >= 0 ? [formatter stringFromNumber:@(door.auxCopTop)] : @"";
    bottomField.text = door.auxCopBottom >= 0 ? [formatter stringFromNumber:@(door.auxCopBottom)] : @"";
    throatField.text = door.auxCopThroat >= 0 ? [formatter stringFromNumber:@(door.auxCopThroat)] : @"";
    returnField.text = door.auxCopReturn >= 0 ? [formatter stringFromNumber:@(door.auxCopReturn)] : @"";

    if ([DataManager sharedManager].currentDoorStyle == 2) {
        self.viewDescription = @"Cab Interior\nAUX Cop Back Return";
    } else {
        self.viewDescription = @"Cab Interior\nAUX Cop Front Return";
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [widthField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
