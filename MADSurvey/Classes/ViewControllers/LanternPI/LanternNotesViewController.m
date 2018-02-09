//
//  LanternNotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LanternNotesViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface LanternNotesViewController () <UITextViewDelegate>
{
    IBOutlet UITextView * txtViewNotes;
}

@end

@implementation LanternNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    txtViewNotes.layer.cornerRadius = 8;
    txtViewNotes.inputAccessoryView = self.keyboardAccessoryView;
    [txtViewNotes becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lantern Notes";

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor - %@", [DataManager sharedManager].floorDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
        lanternLabel.text = [NSString stringWithFormat:@"Lantern / PI - %d of %d", (int32_t)[DataManager sharedManager].currentLanternNum + 1, (int32_t)[DataManager sharedManager].lanternCount];
    }
    
    Lantern *lantern = [DataManager sharedManager].currentLantern;
    
    txtViewNotes.text = lantern.notes ? lantern.notes : @"";
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
    [DataManager sharedManager].currentLantern.notes = txtViewNotes.text;
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDLanternPhotos sender:nil];
}

//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    ProjectPhotosViewController* photovc = (ProjectPhotosViewController*) [segue destinationViewController];
//    photovc.photoViewType = UIPhotoViewTypeHallStation;
//}

#pragma textfield delgate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    //    textView.inputAccessoryView = self.keyboardAccessoryView;
    return YES;
}

@end
