
//
//  LobbyNotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LobbyNotesViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface LobbyNotesViewController ()
{
    IBOutlet UITextView * notesTxtView;
}

@end

@implementation LobbyNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    notesTxtView.inputAccessoryView = self.keyboardAccessoryView;
    notesTxtView.layer.cornerRadius = 8.0f;
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender
{
    Project *project = [DataManager sharedManager].selectedProject;
    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    
    lobby.notes = notesTxtView.text;
    
    [[DataManager sharedManager] saveChanges];

    [self performSegueWithIdentifier:UINavigationIDLobbyPhotos sender:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [notesTxtView becomeFirstResponder];
    
    self.navigationController.title = @"Lobby Notes";
    
    Project *project = [DataManager sharedManager].selectedProject;
    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    
    notesTxtView.text = lobby.notes ? lobby.notes : @"";
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

@end
