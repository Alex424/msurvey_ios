//
//  HallStationNotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallStationNotesViewController.h"
#import "Constants.h"
#import "ProjectPhotosViewController.h"
#import "DataManager.h"

@interface HallStationNotesViewController () <UITextViewDelegate>
{
    IBOutlet UITextView * txtViewNotes;
}
@end

@implementation HallStationNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    txtViewNotes.layer.cornerRadius = 8;
    txtViewNotes.inputAccessoryView = self.keyboardAccessoryView;
    [txtViewNotes becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Hall Station Notes";

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
    
    txtViewNotes.text = hallStation.notes ? hallStation.notes : @"";
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
    [DataManager sharedManager].currentHallStation.notes = txtViewNotes.text;
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDHallStationNotesPhoto sender:nil];
}

// #pragma mark - Navigation
// 
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     ProjectPhotosViewController* photovc = (ProjectPhotosViewController*) [segue destinationViewController];
//     photovc.photoViewType = UIPhotoViewTypeHallStation;
// }

#pragma textfield delgate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

@end
