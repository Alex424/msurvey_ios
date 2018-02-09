//
//  LobbyPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/4/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LobbyPhotosViewController.h"
#import "Constants.h"
#import "PhotoSelectView.h"
#import "DataManager.h"
#import "LobbyLocationViewController.h"
#import "FinalViewController.h"
#import "EditLobbyListViewController.h"

@interface LobbyPhotosViewController ()

@end

@implementation LobbyPhotosViewController


- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeLobby;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.title = @"Lobby Photos";
    [self.navigationController setToolbarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    if ([DataManager sharedManager].isEditing) {
        [self backToSpecificClass:[EditLobbyListViewController class]];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;
    if ([DataManager sharedManager].currentLobbyIndex + 1 >= project.numLobbyPanels) {
        if (project.hallStations == 1 || project.hallLanterns == 1 || project.cops == 1 || project.cabInteriors == 1 || project.hallEntrances == 1) {
            [DataManager sharedManager].currentBankIndex = 0;
            [self performSegueWithIdentifier:UINavigationIDLobbyBankName sender:nil];
        } else {
            FinalViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"FinalViewController"];
            [self.navigationController pushViewController:lvc animated:YES];
        }
    } else {
        [DataManager sharedManager].currentLobbyIndex ++;

        LobbyLocationViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"LobbyLocationViewController"];
        [self backToSpecificViewController:lvc];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (Photo *)addNewPhoto:(UIImage *)image {
    Project *project = [DataManager sharedManager].selectedProject;
    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    
    Photo *photo = [super addNewPhoto:image];
    photo.lobby = lobby;
    [lobby addPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    Project *project = [DataManager sharedManager].selectedProject;
    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    
    return [lobby.photos array];
}

@end
