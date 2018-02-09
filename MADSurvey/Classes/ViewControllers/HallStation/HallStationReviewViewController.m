//
//  HallStationReviewViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationReviewViewController.h"
#import "Constants.h"
#import "HelpView.h"
#import "DataManager.h"

@interface HallStationReviewViewController ()

@end

@implementation HallStationReviewViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeCenterHelp;
    
    [super viewDidLoad];
    
    descField.inputAccessoryView = self.keyboardAccessoryView;
    mountingField.inputAccessoryView = self.keyboardAccessoryView;
    wallMaterialField.inputAccessoryView = self.keyboardAccessoryView;
    coverWidthField.inputAccessoryView = self.keyboardAccessoryView;
    coverHeightField.inputAccessoryView = self.keyboardAccessoryView;
    screwWidthField.inputAccessoryView = self.keyboardAccessoryView;
    screwHeightField.inputAccessoryView = self.keyboardAccessoryView;
    affField.inputAccessoryView = self.keyboardAccessoryView;

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Hall Station Review";

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
    if (hallStation != nil) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.usesGroupingSeparator = NO;

        descField.text = hallStation.hallStationDescription ? hallStation.hallStationDescription : @"";
        mountingField.text = hallStation.mount ? hallStation.mount : @"";
        wallMaterialField.text = hallStation.wallFinish ? hallStation.wallFinish : @"";
        coverWidthField.text = [formatter stringFromNumber:@(hallStation.width)];
        coverHeightField.text = [formatter stringFromNumber:@(hallStation.height)];
        screwWidthField.text = [formatter stringFromNumber:@(hallStation.screwCenterWidth)];
        screwHeightField.text = [formatter stringFromNumber:@(hallStation.screwCenterHeight)];
        affField.text = [formatter stringFromNumber:@(hallStation.affValue)];
    }
    
    [DataManager sharedManager].needToGoBack = NO;

    self.viewDescription = @"Hall Station\nReview";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([coverWidthField isFirstResponder]) {
        [coverHeightField becomeFirstResponder];
    } else if ([coverHeightField isFirstResponder]) {
        [screwWidthField becomeFirstResponder];
    } else if ([screwWidthField isFirstResponder]) {
        [screwHeightField becomeFirstResponder];
    } else if ([screwHeightField isFirstResponder]) {
        [affField becomeFirstResponder];
    } else {
        double width = [coverWidthField.text doubleValueCheckingEmpty];
        double height = [coverHeightField.text doubleValueCheckingEmpty];
        double screwWidth = [screwWidthField.text doubleValueCheckingEmpty];
        double screwHeight = [screwHeightField.text doubleValueCheckingEmpty];
        double aff = [affField.text doubleValueCheckingEmpty];
        
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
        
        if (aff < 0) {
            [self showWarningAlert:@"Please input Aff Value!"];
            return;
        }
        
        HallStation *hallStation = [DataManager sharedManager].currentHallStation;
        
        hallStation.width = width;
        hallStation.height = height;
        hallStation.screwCenterWidth = screwWidth;
        hallStation.screwCenterHeight = screwHeight;
        hallStation.affValue = aff;
        
        [[DataManager sharedManager] saveChanges];
        
        [self performSegueWithIdentifier:UINavigationIDHallStationReviewToNotes sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];

    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Hall Station" withImageName:@"img_help_15_hallstation_review_help"];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == mountingField) {
        [DataManager sharedManager].needToGoBack = YES;
        [self performSegueWithIdentifier:UINavigationIDHallStationReviewToMount sender:nil];
        return NO;
    } else if (textField == wallMaterialField) {
        [DataManager sharedManager].needToGoBack = YES;
        [self performSegueWithIdentifier:UINavigationIDHallStationReviewToWall sender:nil];
        return NO;
    } else if (textField == descField) {
        [DataManager sharedManager].needToGoBack = YES;
        [self performSegueWithIdentifier:UINavigationIDHallStationReviewToDesc sender:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
