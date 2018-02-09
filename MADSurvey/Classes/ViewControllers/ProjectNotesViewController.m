//
//  ProjectNotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ProjectNotesViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface ProjectNotesViewController () <UITextViewDelegate>
{
    IBOutlet UITextView * txtViewNotes;
}

@end

@implementation ProjectNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    txtViewNotes.layer.cornerRadius = 8;
    txtViewNotes.inputAccessoryView = self.keyboardAccessoryView;
    [txtViewNotes becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Project Notes";
    
    Project *project = [DataManager sharedManager].selectedProject;
    txtViewNotes.text = project.notes;
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)next:(id)sender
{
    Project *project = [DataManager sharedManager].selectedProject;
    project.notes = txtViewNotes.text;
    [[DataManager sharedManager] saveChanges];

    [self performSegueWithIdentifier:UINavigationIDProjectPhotos sender:nil];
}

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
