//
//  LanternMeasurementsViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LanternMeasurementsViewController.h"
#import "Constants.h"
#import "HelpView.h"
#import "DataManager.h"

@interface LanternMeasurementsViewController () <UITextFieldDelegate>

@end

@implementation LanternMeasurementsViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    
    coverWidthField.inputAccessoryView = self.keyboardAccessoryView;
    coverHeightField.inputAccessoryView = self.keyboardAccessoryView;
    depthField.inputAccessoryView = self.keyboardAccessoryView;
    screwWidthField.inputAccessoryView = self.keyboardAccessoryView;
    screwHeightField.inputAccessoryView = self.keyboardAccessoryView;
    spaceWidthField.inputAccessoryView = self.keyboardAccessoryView;
    spaceHeightField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lantern Measurements";

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor - %@", [DataManager sharedManager].floorDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
        hallStationLabel.text = [NSString stringWithFormat:@"Lantern / PI - %d of %d", (int32_t)[DataManager sharedManager].currentLanternNum + 1, (int32_t)[DataManager sharedManager].lanternCount];
    }
    
    Lantern *lantern = [DataManager sharedManager].currentLantern;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    coverWidthField.text = lantern.width >= 0 ? [formatter stringFromNumber:@(lantern.width)] : @"";
    coverHeightField.text = lantern.height >= 0 ? [formatter stringFromNumber:@(lantern.height)] : @"";
    depthField.text = lantern.depth >= 0 ? [formatter stringFromNumber:@(lantern.depth)] : @"";
    screwWidthField.text = lantern.screwCenterWidth >= 0 ? [formatter stringFromNumber:@(lantern.screwCenterWidth)] : @"";
    screwHeightField.text = lantern.screwCenterHeight >= 0 ? [formatter stringFromNumber:@(lantern.screwCenterHeight)] : @"";
    spaceWidthField.text = lantern.spaceAvailableWidth >= 0 ? [formatter stringFromNumber:@(lantern.spaceAvailableWidth)] : @"";
    spaceHeightField.text = lantern.spaceAvailableHeight >= 0 ? [formatter stringFromNumber:@(lantern.spaceAvailableHeight)] : @"";

    self.viewDescription = @"Hall Lantern\nMeasurements";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [coverWidthField becomeFirstResponder];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    NSArray *textFields = @[coverWidthField, coverHeightField, depthField, screwWidthField, screwHeightField, spaceWidthField, spaceHeightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double width = [coverWidthField.text doubleValueCheckingEmpty];
        double height = [coverHeightField.text doubleValueCheckingEmpty];
        double depth = [depthField.text doubleValueCheckingEmpty];
        double screwWidth = [screwWidthField.text doubleValueCheckingEmpty];
        double screwHeight = [screwHeightField.text doubleValueCheckingEmpty];
        double spaceWidth = [spaceWidthField.text doubleValueCheckingEmpty];
        double spaceHeight = [spaceHeightField.text doubleValueCheckingEmpty];
        
        if (width < 0) {
            [self showWarningAlert:@"Please input Width!"];
            [coverWidthField becomeFirstResponder];
            return;
        }
        
        if (height < 0) {
            [self showWarningAlert:@"Please input Height!"];
            [coverHeightField becomeFirstResponder];
            return;
        }
        
        if (depth < 0) {
            [self showWarningAlert:@"Please input Depth!"];
            [depthField becomeFirstResponder];
            return;
        }
        
        if (screwWidth < 0) {
            [self showWarningAlert:@"Please input Screw Width!"];
            [screwWidthField becomeFirstResponder];
            return;
        }
        
        if (screwHeight < 0) {
            [self showWarningAlert:@"Please input Screw Height!"];
            [screwHeightField becomeFirstResponder];
            return;
        }
        
        if (spaceWidth < 0) {
            [self showWarningAlert:@"Please input Space Available Width Value!"];
            [spaceWidthField becomeFirstResponder];
            return;
        }

        if (spaceHeight < 0) {
            [self showWarningAlert:@"Please input Space Available Height Value!"];
            [spaceHeightField becomeFirstResponder];
            return;
        }

        Lantern *lantern = [DataManager sharedManager].currentLantern;
        
        lantern.width = width;
        lantern.height = height;
        lantern.depth = depth;
        lantern.screwCenterWidth = screwWidth;
        lantern.screwCenterHeight = screwHeight;
        lantern.spaceAvailableWidth = spaceWidth;
        lantern.spaceAvailableHeight = spaceHeight;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDLanternNotes sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];

    Lantern *lantern = [DataManager sharedManager].currentLantern;
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Lantern / PI" withImageName:[self helpImageForLantern:lantern]];
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
