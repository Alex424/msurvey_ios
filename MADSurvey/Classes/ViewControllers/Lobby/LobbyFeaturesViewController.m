//
//  LobbyFeaturesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LobbyFeaturesViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface LobbyFeaturesViewController ()<UITextViewDelegate>
{
    IBOutlet UITextView * featureTxtView;
    IBOutlet UITextView * communicationView;
}

@end

@implementation LobbyFeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    featureTxtView.layer.cornerRadius = 8.0f;
    communicationView.layer.cornerRadius = 8.0f;
    
    featureTxtView.inputAccessoryView = self.keyboardAccessoryView;
    communicationView.inputAccessoryView = self.keyboardAccessoryView;
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)next:(id)sender
{
    if (communicationView.text.length == 0 && ![communicationView isFirstResponder]) {
        [communicationView becomeFirstResponder];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    
    lobby.specialFeature = featureTxtView.text;
    lobby.specialCommunicationOption = communicationView.text;
    
    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDLobbyNotes sender:nil];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [featureTxtView becomeFirstResponder];
    
    self.navigationController.title = @"Lobby Features";

    Project *project = [DataManager sharedManager].selectedProject;
    
    indexLabel.text = [NSString stringWithFormat:@"Lobby panel %d of %d", (int32_t)[DataManager sharedManager].currentLobbyIndex + 1, project.numLobbyPanels];
    
    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    
    featureTxtView.text = lobby.specialFeature ? lobby.specialFeature : @"";
    communicationView.text = lobby.specialCommunicationOption ? lobby.specialCommunicationOption : @"";
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
