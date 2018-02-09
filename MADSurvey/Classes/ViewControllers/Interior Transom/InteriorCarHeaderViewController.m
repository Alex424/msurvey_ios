//
//  InteriorCarHeaderViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarHeaderViewController.h"
#import "Common.h"
#import "DataManager.h"

@interface InteriorCarHeaderViewController () <UITextFieldDelegate> {
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    IBOutlet UITextField *hoistField;
    IBOutlet UITextField *throatField;
    IBOutlet UITextField *widthField;
    IBOutlet UITextField *heightField;
    IBOutlet UITextField *returnField;
}

@end

@implementation InteriorCarHeaderViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    hoistField.inputAccessoryView = self.keyboardAccessoryView;
    throatField.inputAccessoryView = self.keyboardAccessoryView;
    widthField.inputAccessoryView = self.keyboardAccessoryView;
    heightField.inputAccessoryView = self.keyboardAccessoryView;
    returnField.inputAccessoryView = self.keyboardAccessoryView;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[hoistField, throatField, widthField, heightField, returnField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double hoist = [hoistField.text doubleValueCheckingEmpty];
        double throat = [throatField.text doubleValueCheckingEmpty];
        double width = [widthField.text doubleValueCheckingEmpty];
        double height = [heightField.text doubleValueCheckingEmpty];
        double retWall = [returnField.text doubleValueCheckingEmpty];
        
        if (hoist < 0) {
            [self showWarningAlert:@"Please input Return Hoist Way!"];
            [hoistField becomeFirstResponder];
            return;
        }
        if (throat < 0) {
            [self showWarningAlert:@"Please input Throat!"];
            [throatField becomeFirstResponder];
            return;
        }
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
        if (retWall < 0) {
            [self showWarningAlert:@"Please input Return Wall!"];
            [returnField becomeFirstResponder];
            return;
        }
        
        InteriorCarDoor *door = [DataManager sharedManager].currentInteriorCarDoor;
        
        door.headerReturnHoistWay = hoist;
        door.headerThroat = throat;
        door.headerWidth = width;
        door.headerHeight = height;
        door.headerReturnWall = retWall;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDInteriorFlat sender:nil];
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
    
    hoistField.text = door.headerReturnHoistWay >= 0 ? [formatter stringFromNumber:@(door.headerReturnHoistWay)] : @"";
    throatField.text = door.headerThroat >= 0 ? [formatter stringFromNumber:@(door.headerThroat)] : @"";
    widthField.text = door.headerWidth >= 0 ? [formatter stringFromNumber:@(door.headerWidth)] : @"";
    heightField.text = door.headerHeight >= 0 ? [formatter stringFromNumber:@(door.headerHeight)] : @"";
    returnField.text = door.headerReturnWall >= 0 ? [formatter stringFromNumber:@(door.headerReturnWall)] : @"";
    
    self.viewDescription = @"Cab Interior\nHeader";
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [hoistField becomeFirstResponder];
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Car Interior Measurements" withImageName:@"img_help_interior_car_header"];
}

@end
