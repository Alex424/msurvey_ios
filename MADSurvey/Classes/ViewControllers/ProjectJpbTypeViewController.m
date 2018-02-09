//
//  ProjectJpbTypeViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ProjectJpbTypeViewController.h"
#import "ProjectEditViewController.h"

#import "Constants.h"
#import "DataManager.h"

@interface ProjectJpbTypeViewController ()

@end

@implementation ProjectJpbTypeViewController

- (void)viewDidLoad {
    self.toolbarType = UIToolbarTypeNoNext;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Project Job Type";

    Project *project = [DataManager sharedManager].selectedProject;
    if (project.jobType == ProjectJobTypeService) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    } else if (project.jobType == ProjectJobTypeMod) {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    } else {
        [comboImageViews[0] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
        [comboImageViews[1] setImage:[UIImage imageNamed:@"ic_checkbox_normal"]];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)next:(id)sender
{
    [[DataManager sharedManager] saveChanges];
    
    if ([DataManager sharedManager].isEditing) {
        [self backToSpecificClass:[ProjectEditViewController class]];
        return;
    }

    Project *project = [DataManager sharedManager].selectedProject;

    if (project.hallStations == 0 &&
        project.hallEntrances == 0 &&
        project.hallLanterns == 0 &&
        project.cops == 0 &&
        project.cabInteriors == 0) {
        project.numBanks = 0;
        project.numFloors = 0;
        [self performSegueWithIdentifier:UINavigationIDProjectJobTypeLobbyPanels sender:nil];
    } else {
        [self performSegueWithIdentifier:UINavigationIDProjectNumberBanks sender:nil];
    }
}
-(IBAction)comboAction:(id)sender
{
    UIButton * btnSelected = (UIButton *) sender;
    UIImageView * imageSelected = comboImageViews[btnSelected.tag];

    [imageSelected setImage:[UIImage imageNamed:@"ic_checkbox_checked"]];
    
    Project *project = [DataManager sharedManager].selectedProject;
    if (btnSelected.tag == 0) {
        project.jobType = ProjectJobTypeService;
    } else {
        project.jobType = ProjectJobTypeMod;
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
