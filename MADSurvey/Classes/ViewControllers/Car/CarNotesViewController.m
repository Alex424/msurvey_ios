//
//  CarNotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "CarNotesViewController.h"
#import "DataManager.h"

@interface CarNotesViewController () <UITextViewDelegate>
{
    IBOutlet UITextView * txtViewNotes;
}

@end

@implementation CarNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    txtViewNotes.layer.cornerRadius = 8;
    txtViewNotes.inputAccessoryView = self.keyboardAccessoryView;
    [txtViewNotes becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Car Notes";

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
    
    txtViewNotes.text = car.notes ? car.notes : @"";
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
    car.notes = txtViewNotes.text;
    
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDCarPhotos sender:nil];
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
