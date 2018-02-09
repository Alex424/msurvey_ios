//
//  EditLobbyListViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 11/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "EditLobbyListViewController.h"

#import "DataManager.h"
#import "EditListViewCell.h"
#import "DeleteItemConfirmView.h"
#import "LobbyLocationViewController.h"
#import "MADInfoAlert.h"

@interface EditLobbyListViewController () <EditListViewCellDelegate>

@property (nonatomic, strong) NSArray *lobbies;

@end

@implementation EditLobbyListViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeAdd;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    self.toolbarType = UIToolbarTypeAdd;
    [self updateToolbar];
    [self.navigationController setToolbarHidden:NO];

    self.lobbies = [[DataManager sharedManager].selectedProject.lobbies array];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lobbies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Lobby *lobby = self.lobbies[indexPath.row];
    
    EditListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditListViewCell"];
    
    cell.title = [NSString stringWithFormat:@"Lobby Panel%d (%@)", (int)indexPath.row + 1, lobby.location];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [DataManager sharedManager].currentLobbyIndex = indexPath.row;
    
    LobbyLocationViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"LobbyLocationViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}


- (void)next:(id)sender {
    [DataManager sharedManager].currentLobbyIndex = self.lobbies.count;
    
    LobbyLocationViewController * lvc = [[UIStoryboard storyboardWithName:@"Second" bundle:nil] instantiateViewControllerWithIdentifier:@"LobbyLocationViewController"];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma mark - EditListViewCellDelegate

- (void)deleteItem:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    Lobby *lobby = self.lobbies[indexPath.row];
    
    NSString *title = [NSString stringWithFormat:@"Lobby Panel %d", (int)indexPath.row + 1];
    NSString *subtitle = lobby.location;
    
    DeleteItemConfirmView *view = [DeleteItemConfirmView
                                   showOnView:self.navigationController.view
                                   title:title
                                   subtitle:subtitle
                                   description:@""];
    if (view) {
        view.yesBlock = ^{
            // show info alert
            [MADInfoAlert showOnView:self.tableView.superview
                           withTitle:title
                            subTitle:subtitle
                         description:@"Item successfully deleted from device"];
            
            [[DataManager sharedManager] deleteLobby:lobby];
            [[DataManager sharedManager] saveChanges];
            
            [self.tableView reloadData];
        };
    }
}

@end
