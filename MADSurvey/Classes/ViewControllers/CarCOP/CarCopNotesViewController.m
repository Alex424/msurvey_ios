//
//  CarCopNotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarCopNotesViewController.h"
#import "DataManager.h"

@interface CarCopNotesViewController () <UITextViewDelegate>
{
    IBOutlet UITextView * txtViewNotes;
}
@end

@implementation CarCopNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    txtViewNotes.layer.cornerRadius = 8;
    txtViewNotes.inputAccessoryView = self.keyboardAccessoryView;
    [txtViewNotes becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car COP Notes";

    Project *project = [DataManager sharedManager].selectedProject;
    Car *car = [DataManager sharedManager].currentCar;
    
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];

    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
    }
    carLabel.text = [NSString stringWithFormat:@"COP %d of %d - %@", (int32_t)[DataManager sharedManager].currentCopNum + 1, car.numberOfCops, car.carNumber];
    
    Cop *cop = [DataManager sharedManager].currentCop;
    
    txtViewNotes.text = cop.notes ? cop.notes : @"";
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
    Cop *cop = [DataManager sharedManager].currentCop;
    cop.notes = txtViewNotes.text;
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDCarCopPhotos sender:nil];
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
