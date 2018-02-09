//
//  LobbyMeasurementViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/3/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LobbyMeasurementViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface LobbyMeasurementViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField * panelWidthField;
    IBOutlet UITextField * panelHeightField;
    IBOutlet UITextField * coverWidthField;
    IBOutlet UITextField * coverHeightField;
}
@end

@implementation LobbyMeasurementViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lobby Measurements";
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    indexLabel.text = [NSString stringWithFormat:@"Lobby panel %d of %d", (int32_t)[DataManager sharedManager].currentLobbyIndex + 1, project.numLobbyPanels];
    
    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.usesGroupingSeparator = NO;

    panelWidthField.text = lobby.panelWidth >= 0 ? [formatter stringFromNumber:@(lobby.panelWidth)] : @"";
    panelHeightField.text = lobby.panelHeight >= 0 ? [formatter stringFromNumber:@(lobby.panelHeight)] : @"";
    coverWidthField.text = lobby.screwCenterWidth >= 0 ? [formatter stringFromNumber:@(lobby.screwCenterWidth)] : @"";
    coverHeightField.text = lobby.screwCenterHeight >= 0 ? [formatter stringFromNumber:@(lobby.screwCenterHeight)] : @"";;

    self.viewDescription = @"Lobby Panel\nMeasurements";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [panelWidthField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender
{
    NSArray *textFields = @[panelWidthField, panelHeightField, coverWidthField, coverHeightField];
    NSInteger index = [textFields indexOfObjectPassingTest:^BOOL(UITextField *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isFirstResponder];
    }];
    if (index < textFields.count - 1) {
        [textFields[index + 1] becomeFirstResponder];
    } else {
        double panelWidth = [panelWidthField.text doubleValueCheckingEmpty];
        double panelHeight = [panelHeightField.text doubleValueCheckingEmpty];
        double coverWidth = [coverWidthField.text doubleValueCheckingEmpty];
        double coverHeight = [coverHeightField.text doubleValueCheckingEmpty];
        
        if (panelWidth < 0) {
            [self showWarningAlert:@"Please input Panel Width!"];
            [panelWidthField becomeFirstResponder];
            return;
        }

        if (panelHeight < 0) {
            [self showWarningAlert:@"Please input Panel Height!"];
            [panelHeightField becomeFirstResponder];
            return;
        }

        if (coverWidth < 0) {
            [self showWarningAlert:@"Please input Screw Center Width!"];
            [coverWidthField becomeFirstResponder];
            return;
        }

        if (coverHeight < 0) {
            [self showWarningAlert:@"Please input Screw Center Height!"];
            [coverHeightField becomeFirstResponder];
            return;
        }
        
        Project *project = [DataManager sharedManager].selectedProject;
        Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
        
        lobby.panelWidth = panelWidth;
        lobby.panelHeight = panelHeight;
        lobby.screwCenterWidth = coverWidth;
        lobby.screwCenterHeight = coverHeight;
        
        [[DataManager sharedManager] saveChanges];

        [self performSegueWithIdentifier:UINavigationIDLobbyFeatures sender:nil];
    }
}

- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Lobby Panel" withImageName:@"img_help_9_lobby_measurements_help"];
}


#pragma textfield delgate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = self.keyboardAccessoryView;
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
