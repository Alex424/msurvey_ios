//
//  LobbyVisibilityViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/3/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LobbyVisibilityViewController.h"
#import "LobbyVisibilityViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface LobbyVisibilityViewController ()

@end

@implementation LobbyVisibilityViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lobby Visibility";
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    indexLabel.text = [NSString stringWithFormat:@"Lobby panel %d of %d", (int32_t)[DataManager sharedManager].currentLobbyIndex + 1, project.numLobbyPanels];

    [checkImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [checkImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];

    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    
    if (lobby.visibility == LobbyElevatorsVisible) {
        [checkImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else if (lobby.visibility == LobbyElevatorsInvisible) {
        [checkImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)next:(id)sender
{
    [self performSegueWithIdentifier:UINavigationIDLobbyMeasurement sender:nil];
    
}

-(IBAction)comboAction:(id)sender
{
    [checkImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    [checkImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];

    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = checkImageViews[btnSelected.tag];
    
    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    Project *project = [DataManager sharedManager].selectedProject;
    Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    
    if (btnSelected.tag == 0) {
        lobby.visibility = LobbyElevatorsVisible;
    } else if (btnSelected.tag == 1) {
        lobby.visibility = LobbyElevatorsInvisible;
    }
    
    [[DataManager sharedManager] saveChanges];
    
    [self performSelector:@selector(next:) withObject:nil afterDelay:0.1];
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
