//
//  InteriorCarFlatViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarFlatViewController.h"
#import "Common.h"
#import "DataManager.h"

@interface InteriorCarFlatViewController () <UITextFieldDelegate> {
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    IBOutlet UITextField *lWidthField;
    IBOutlet UITextField *lHeightField;
    IBOutlet UITextField *rWidthField;
    IBOutlet UITextField *rHeightField;
}

@end

@implementation InteriorCarFlatViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lWidthField.inputAccessoryView = self.keyboardAccessoryView;
    lHeightField.inputAccessoryView = self.keyboardAccessoryView;
    rWidthField.inputAccessoryView = self.keyboardAccessoryView;
    rHeightField.inputAccessoryView = self.keyboardAccessoryView;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields;
    
    if ([DataManager sharedManager].currentCenterOpening == 1) {
        textFields = @[lWidthField, lHeightField, rWidthField, rHeightField];
    } else {
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        if (door.carDoorOpeningDirection == 1) {
            textFields = @[lWidthField, lHeightField];
        } else {
            textFields = @[rWidthField, rHeightField];
        }
    }

    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;

        double lWidth = [lWidthField.text doubleValueCheckingEmpty];
        double lHeight = [lHeightField.text doubleValueCheckingEmpty];
        BOOL hasLeft = NO;
        
        if ([DataManager sharedManager].currentCenterOpening == 1 || door.carDoorOpeningDirection == 1) {
            
            if (lWidth < 0) {
                [self showWarningAlert:@"Please input Width!"];
                [lWidthField becomeFirstResponder];
                return;
            }
            if (lHeight < 0) {
                [self showWarningAlert:@"Please input Height!"];
                [lHeightField becomeFirstResponder];
                return;
            }
            
            hasLeft = YES;
        }
        if ([DataManager sharedManager].currentCenterOpening == 1 || door.carDoorOpeningDirection == 2) {
            double rWidth = [rWidthField.text doubleValueCheckingEmpty];
            double rHeight = [rHeightField.text doubleValueCheckingEmpty];
            
            if (rWidth < 0) {
                [self showWarningAlert:@"Please input Width!"];
                [rWidthField becomeFirstResponder];
                return;
            }
            if (rHeight < 0) {
                [self showWarningAlert:@"Please input Height!"];
                [rHeightField becomeFirstResponder];
                return;
            }
            
            door.flatFrontRightWidth = rWidth;
            door.flatFrontRightHeight = rHeight;
        }
        
        if (hasLeft) {
            door.flatFrontLeftWidth = lWidth;
            door.flatFrontLeftHeight = lHeight;
        }
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorFlatCopInstalled sender:nil];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;

    if (indexPath.row == 0) {
        if ([DataManager sharedManager].currentCenterOpening == 1 || door.carDoorOpeningDirection == 1) {
            return 128;
        }
    } else {
        if ([DataManager sharedManager].currentCenterOpening == 1 || door.carDoorOpeningDirection == 2) {
            return 128;
        }
    }
    
    return 0;
}

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
    
    lWidthField.text = door.flatFrontLeftWidth >= 0 ? [formatter stringFromNumber:@(door.flatFrontLeftWidth)] : @"";
    lHeightField.text = door.flatFrontLeftHeight >= 0 ? [formatter stringFromNumber:@(door.flatFrontLeftHeight)] : @"";
    rWidthField.text = door.flatFrontRightWidth >= 0 ? [formatter stringFromNumber:@(door.flatFrontRightWidth)] : @"";
    rHeightField.text = door.flatFrontRightHeight >= 0 ? [formatter stringFromNumber:@(door.flatFrontRightHeight)] : @"";
    
//    if ([DataManager sharedManager].currentDoorStyle == 2) {
        self.viewDescription = @"Cab Interior\nFLAT Front";
//    } else {
//        self.viewDescription = @"Cab Interior\nFLAT Back";
//    }
    
    if ([DataManager sharedManager].currentCenterOpening == 1) {
        lHeightField.returnKeyType = UIReturnKeyNext;
    } else {
        lHeightField.returnKeyType = UIReturnKeyDone;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([DataManager sharedManager].currentCenterOpening == 1) {
        [lWidthField becomeFirstResponder];
    } else {
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        if (door.carDoorOpeningDirection == 1) {
            [lWidthField becomeFirstResponder];
        } else {
            [rWidthField becomeFirstResponder];
        }
    }
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_interior_car_flat_front"];
}

@end
