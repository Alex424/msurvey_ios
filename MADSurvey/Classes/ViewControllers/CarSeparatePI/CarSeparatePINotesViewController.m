//
//  CarSeparatePINotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarSeparatePINotesViewController.h"
#import "DataManager.h"

@interface CarSeparatePINotesViewController ()
{
    IBOutlet UITextView * txtViewNotes;
}

@end

@implementation CarSeparatePINotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    txtViewNotes.layer.cornerRadius = 8;
    txtViewNotes.inputAccessoryView = self.keyboardAccessoryView;
    [txtViewNotes becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Separated PI Notes";

    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    Car *car = [DataManager sharedManager].currentCar;
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car - %@", car.carNumber];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        carLabel.text = [NSString stringWithFormat:@"Car %d of %d - %@", (int32_t)[DataManager sharedManager].currentCarNum + 1, bank.numOfCar, car.carNumber];
    }
    
    txtViewNotes.text = car.notesSPI ? car.notesSPI : @"";
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
    Car *car = [DataManager sharedManager].currentCar;
    car.notesSPI = txtViewNotes.text;
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDCarSeparatePIPhotos sender:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
