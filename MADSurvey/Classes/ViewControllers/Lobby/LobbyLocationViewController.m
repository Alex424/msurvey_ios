//
//  LobbyLocationViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "LobbyLocationViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface LobbyLocationViewController () <UITextFieldDelegate>
{
    int selectedIdx;
    
    IBOutlet UITextField * otherField;
}

@end

@implementation LobbyLocationViewController

- (void)viewDidLoad {
    
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    otherField.inputAccessoryView = self.keyboardAccessoryView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    
    NSLog(@"%@", [NSString stringWithFormat:@"%d", selectedIdx]);
    
    [otherField resignFirstResponder];
    
    Project *project = [DataManager sharedManager].selectedProject;

    Lobby *lobby;
    if (project.lobbies.count > [DataManager sharedManager].currentLobbyIndex) {
        lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
    } else {
        lobby = [[DataManager sharedManager] createNewLobbyForProject:project];
    }
    
    if (selectedIdx == UICellCACFRoom) {
        lobby.location = LobbyLocationCACFRoom;
    } else if (selectedIdx == UICellFire) {
        lobby.location = LobbyLocationFireRecallPanel;
    } else if (selectedIdx == UICellSecurity) {
        lobby.location = LobbyLocationSecurityDesk;
    } else {
        lobby.location = otherField.text;
    }
    
    [[DataManager sharedManager] saveChanges];

    [self performSegueWithIdentifier:UINavigationIDLobbyVisibility sender:nil];
    
}

-(IBAction)checkAction:(id)sender
{
    
    for(UIImageView * img in checkImageViews)
    {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }
    
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = checkImageViews[(btnSelected.tag - 1)];
    if(btnSelected.tag == imageSelected.tag)
    {
        imageSelected.tag = UICellNoSelected;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        
        selectedIdx = UICellNoSelected;
        
    }
    else{
        imageSelected.tag = btnSelected.tag;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        selectedIdx = (int) btnSelected.tag;
        
        if(selectedIdx != UICellOther) {
            self.toolbarType = UIToolbarTypeNoNext;
            [self updateToolbar];

            [self next:nil];
        } else {
            self.toolbarType = UIToolbarTypeNormal;
            [self updateToolbar];
        }

        if (![DataManager sharedManager].isEditing && [DataManager sharedManager].currentLobbyIndex > 0) {
            self.backButton.hidden = YES;
            self.keyboardAccessoryView.leftButton.hidden = YES;
        }
    }
    [self.tableView reloadData];
    if(selectedIdx == UICellOther)
        [otherField becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Lobby Location";
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    indexLabel.text = [NSString stringWithFormat:@"Lobby panel %d of %d", (int32_t)[DataManager sharedManager].currentLobbyIndex + 1, project.numLobbyPanels];
    
    for(UIImageView * img in checkImageViews)
    {
        [img setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        img.tag = UICellNoSelected;
    }

    self.toolbarType = UIToolbarTypeNoNext;

    if (project.lobbies.count > [DataManager sharedManager].currentLobbyIndex) {
        Lobby *lobby = project.lobbies[[DataManager sharedManager].currentLobbyIndex];
        
        if ([lobby.location isEqualToString:LobbyLocationCACFRoom]) {
            selectedIdx = UICellCACFRoom;
        } else if ([lobby.location isEqualToString:LobbyLocationFireRecallPanel]) {
            selectedIdx = UICellFire;
        } else if ([lobby.location isEqualToString:LobbyLocationSecurityDesk]) {
            selectedIdx = UICellSecurity;
        } else {
            selectedIdx = UICellOther;
            otherField.text = lobby.location;

            self.toolbarType = UIToolbarTypeNormal;
        }
        
        UIImageView * imageSelected = checkImageViews[selectedIdx - 1];
        imageSelected.tag = selectedIdx;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];

        [self.tableView reloadData];
    }

    [self updateToolbar];
    if (![DataManager sharedManager].isEditing && [DataManager sharedManager].currentLobbyIndex > 0) {
        self.backButton.hidden = YES;
        self.keyboardAccessoryView.leftButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (selectedIdx == UICellOther) {
        [otherField becomeFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIdx == UICellOther && indexPath.row == (UICellOther - 1))
        return 130;
    
    return 70; //130
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self next:nil];
    return YES;
}

@end
