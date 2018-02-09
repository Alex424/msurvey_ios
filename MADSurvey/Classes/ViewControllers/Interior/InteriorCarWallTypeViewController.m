//
//  InteriorCarWallTypeViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "InteriorCarWallTypeViewController.h"
#import "Constants.h"
#import "DataManager.h"
#import "MADInfoAlert.h"

@interface InteriorCarWallTypeViewController ()
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
    
    NSInteger selectedIdx;
    
    IBOutlet UITextView *notesTxtView;
}

@end

@implementation InteriorCarWallTypeViewController

- (void)viewDidLoad {
    
//    self.toolbarType = UIToolbarTypeCenterHelp;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    notesTxtView.layer.cornerRadius = 8.0f;
    notesTxtView.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Interior Car Wall Type";
    
    [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    InteriorCar *interiorCar = [DataManager sharedManager].currentInteriorCar;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car - %@", interiorCar.carDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d - %@", (int32_t)[DataManager sharedManager].currentInteriorCarNum + 1, bank.numOfInteriorCar, interiorCar.carDescription];
        
        if ([DataManager sharedManager].currentDoorStyle == 2) {
            self.backButton.hidden = YES;
            self.keyboardAccessoryView.leftButton.hidden = YES;
        }
    }

    InteriorCarDoor *door = ([DataManager sharedManager].currentDoorStyle == 1) ? interiorCar.frontDoor : interiorCar.backDoor;
    [DataManager sharedManager].currentInteriorCarDoor = door;

    selectedIdx = -1;
    if ([door.wallType isEqualToString:ThreePiece]) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedIdx = 0;
    } else if ([door.wallType isEqualToString:FivePiece]) {
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedIdx = 1;
    } else if ([door.wallType isEqualToString:Hybrid]) {
        [comboImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedIdx = 2;
    }
    
    notesTxtView.text = door.wallTypeNotes ? door.wallTypeNotes : @"";
}

-(IBAction)comboAction:(id)sender
{
    [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [comboImageViews[2] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = comboImageViews[btnSelected.tag];
    
    selectedIdx = btnSelected.tag;
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    InteriorCarDoor *door = [[DataManager sharedManager] createNewInteriorCarDoorForCar:[DataManager sharedManager].currentInteriorCar doorStyle:[DataManager sharedManager].currentDoorStyle];
    [DataManager sharedManager].currentInteriorCarDoor = door;
    
    if (selectedIdx == 0) {
        door.wallType = ThreePiece;
    } else if (selectedIdx == 1) {
        door.wallType = FivePiece;
    } else if (selectedIdx == 2) {
        door.wallType = Hybrid;
    } else {
        [self showWarningAlert:@"Please select Wall Type!"];
        return;
    }
    
    door.wallTypeNotes = notesTxtView.text;
    [[DataManager sharedManager] saveChanges];

    [self performSegueWithIdentifier:UINavigationIDInteriorCarOpening sender:nil];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([DataManager sharedManager].needInstruction) {
        [DataManager sharedManager].needInstruction = NO;
        
        [MADInfoAlert showOnView:self.navigationController.view withTitle:@"Instruction" subTitle:@"" description:@"Now you will go through for the back door information screens."];
    }
}


- (IBAction)center:(id)sender {
    [self.view endEditing:YES];
    [HelpView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] withTitle:@"Wall Type" withImageName:@"img_help_interior_wall_type"];
}

@end
