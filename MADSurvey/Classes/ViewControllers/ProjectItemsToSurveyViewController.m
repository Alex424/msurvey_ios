//
//  ProjectItemsToSurveyViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ProjectItemsToSurveyViewController.h"
#import "Constants.h"
#import "CheckButton.h"

#import "DataManager.h"

@interface ProjectItemsToSurveyViewController ()
{

    
}

@end

@implementation ProjectItemsToSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    Project *project = [DataManager sharedManager].selectedProject;
    
    NSString *title;
    if (project) {
        title = project.name;
    } else {
        title = @"New Survey";
    }
    self.navigationController.title = title;

    [self updateCheckControls];
}


- (void)updateCheckControls {
    Project *project = [DataManager sharedManager].selectedProject;

    [self check:UICellLobbyPanels on:(project.lobbyPanels == 1)];
    [self check:UICellHallStations on:(project.hallStations == 1)];
    [self check:UICellHallLanterns on:(project.hallLanterns == 1)];
    [self check:UICellCops on:(project.cops == 1)];
    [self check:UICellHallEntrance on:(project.hallEntrances == 1)];
    [self check:UICellCabInteriors on:(project.cabInteriors == 1)];
    
    [self check:UICellAll on:(project.lobbyPanels == 1 &&
                              project.hallStations == 1 &&
                              project.hallLanterns == 1 &&
                              project.cops == 1 &&
                              project.hallEntrances == 1 &&
                              project.cabInteriors == 1)];
    [self check:UICellAllFixtures on:(project.lobbyPanels == 1 &&
                                      project.hallStations == 1 &&
                                      project.hallLanterns == 1 &&
                                      project.cops == 1)];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if (checkButtons[UICellLobbyPanels].tag != checkImageViews[UICellLobbyPanels].tag &&
        checkButtons[UICellHallStations].tag != checkImageViews[UICellHallStations].tag &&
        checkButtons[UICellHallLanterns].tag != checkImageViews[UICellHallLanterns].tag &&
        checkButtons[UICellCops].tag != checkImageViews[UICellCops].tag &&
        checkButtons[UICellHallEntrance].tag != checkImageViews[UICellHallEntrance].tag &&
        checkButtons[UICellCabInteriors].tag != checkImageViews[UICellCabInteriors].tag) {
        [self showWarningAlert:@"Please select Item(s) to survey!"];
        return;
    }
    
    Project *project = [DataManager sharedManager].selectedProject;

    project.lobbyPanels = (checkButtons[UICellLobbyPanels].tag == checkImageViews[UICellLobbyPanels].tag);
    project.hallStations = (checkButtons[UICellHallStations].tag == checkImageViews[UICellHallStations].tag);
    project.hallLanterns = (checkButtons[UICellHallLanterns].tag == checkImageViews[UICellHallLanterns].tag);
    project.cops = (checkButtons[UICellCops].tag == checkImageViews[UICellCops].tag);
    project.hallEntrances = (checkButtons[UICellHallEntrance].tag == checkImageViews[UICellHallEntrance].tag);
    project.cabInteriors = (checkButtons[UICellCabInteriors].tag == checkImageViews[UICellCabInteriors].tag);

    [[DataManager sharedManager] saveChanges];
    
    [self performSegueWithIdentifier:UINavigationIDProjectNotes sender:nil];
}


- (IBAction)checkAction:(id)sender {
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = checkImageViews[btnSelected.tag];
    if(btnSelected.tag == imageSelected.tag) {
        imageSelected.tag = UICellNoSelected;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        
        if (btnSelected.tag == UICellAll || btnSelected.tag == UICellAllFixtures) {
            [self check:UICellLobbyPanels on:NO];
            [self check:UICellHallStations on:NO];
            [self check:UICellHallLanterns on:NO];
            [self check:UICellCops on:NO];
            if (btnSelected.tag == UICellAll) {
                [self check:UICellHallEntrance on:NO];
                [self check:UICellCabInteriors on:NO];
                [self check:UICellAllFixtures on:NO];
            }
        }
    } else {
        imageSelected.tag = btnSelected.tag;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_tick_checked"]];
        
        if (btnSelected.tag == UICellAll || btnSelected.tag == UICellAllFixtures) {
            [self check:UICellLobbyPanels on:YES];
            [self check:UICellHallStations on:YES];
            [self check:UICellHallLanterns on:YES];
            [self check:UICellCops on:YES];
            if (btnSelected.tag == UICellAll) {
                [self check:UICellHallEntrance on:YES];
                [self check:UICellCabInteriors on:YES];
                [self check:UICellAllFixtures on:YES];
            }
        }
    }
    
    [self check:UICellAll on:(checkButtons[UICellLobbyPanels].tag == checkImageViews[UICellLobbyPanels].tag &&
                              checkButtons[UICellHallStations].tag == checkImageViews[UICellHallStations].tag &&
                              checkButtons[UICellHallLanterns].tag == checkImageViews[UICellHallLanterns].tag &&
                              checkButtons[UICellCops].tag == checkImageViews[UICellCops].tag &&
                              checkButtons[UICellHallEntrance].tag == checkImageViews[UICellHallEntrance].tag &&
                              checkButtons[UICellCabInteriors].tag == checkImageViews[UICellCabInteriors].tag)];
    [self check:UICellAllFixtures on:(checkButtons[UICellLobbyPanels].tag == checkImageViews[UICellLobbyPanels].tag &&
                                      checkButtons[UICellHallStations].tag == checkImageViews[UICellHallStations].tag &&
                                      checkButtons[UICellHallLanterns].tag == checkImageViews[UICellHallLanterns].tag &&
                                      checkButtons[UICellCops].tag == checkImageViews[UICellCops].tag)];
}


- (void)check:(UICellCheck)index on:(BOOL)on {
    UIButton * btnSelected = checkButtons[index];
    UIImageView * imageSelected = checkImageViews[index];
    if (!on) {
        imageSelected.tag = UICellNoSelected;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    } else {
        imageSelected.tag = btnSelected.tag;
        [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_tick_checked"]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProductsItemsCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor =  UIListSelectionColor;
    
    return cell;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
