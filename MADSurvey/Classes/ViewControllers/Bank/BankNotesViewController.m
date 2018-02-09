//
//  BankNotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "BankNotesViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface BankNotesViewController ()
{
    IBOutlet UITextView * bankNotesTxtView;
}

@end

@implementation BankNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    bankNotesTxtView.inputAccessoryView = self.keyboardAccessoryView;
    bankNotesTxtView.layer.cornerRadius = 8.0f;
    [bankNotesTxtView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Bank Notes";
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    indexLabel.text = [NSString stringWithFormat:@"Bank %d of %d", (int32_t)[DataManager sharedManager].currentBankIndex + 1, project.numBanks];
    
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    bankNotesTxtView.text = bank.notes ? bank.notes : @"";
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    bank.notes = bankNotesTxtView.text;
    
    [[DataManager sharedManager] saveChanges];
    [DataManager sharedManager].currentFloorNum = 0;
    
    [self performSegueWithIdentifier:UINavigationIDBankPhotos sender:nil];
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
