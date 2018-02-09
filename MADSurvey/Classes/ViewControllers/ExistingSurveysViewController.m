//
//  ExistingSurveysViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ExistingSurveysViewController.h"
#import "ExistingSurveyCell.h"
#import "Constants.h"
#import "ExistingSurveyOperationsView.h"
#import "ExistingSurveyDeleteConfirmView.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "MADInfoAlert.h"

@interface ExistingSurveysViewController ()

@end

@implementation ExistingSurveysViewController

- (void)viewDidLoad {
    // set the toolbartype here
    self.toolbarType = UIToolbarTypeNoNext;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [DataManager sharedManager].selectedProject = nil;
    self.navigationController.title = @"Existing Surveys";
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [DataManager sharedManager].projects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExistingSurveyCell * cell = (ExistingSurveyCell *)[tableView dequeueReusableCellWithIdentifier:@"ExistingSurveyCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor =     UIListSelectionColor;
    
    cell.project = [DataManager sharedManager].projects[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [DataManager sharedManager].selectedProject = [DataManager sharedManager].projects[indexPath.row];

    ExistingSurveyOperationsView * opView = [ExistingSurveyOperationsView showOnView:[(AppDelegate*)[UIApplication sharedApplication].delegate window] project:[DataManager sharedManager].selectedProject];
    if (opView) {
        // edit
        opView.editBlock = ^(void) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [self performSegueWithIdentifier:UINavigationIDExistingEdit sender:nil];
            });
        };
        
        // remove
        opView.removeBlock = ^(void) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                ExistingSurveyDeleteConfirmView *conView = [ExistingSurveyDeleteConfirmView showOnView:self.tableView.superview project:[DataManager sharedManager].selectedProject];
                if (conView) {
                    conView.yesBlock = ^(void) {
                        // show info alert
                        Project *project = [DataManager sharedManager].selectedProject;
                        [MADInfoAlert showOnView:self.tableView.superview withTitle:project.name subTitle:project.surveyDate description:@"Survey data successfully deleted from device"];
                        
                        [[DataManager sharedManager] deleteProject:project];
                        [self.tableView reloadData];
                    };
                }
            });
        };
        
        // submit
        opView.submitBlock = ^(void) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self performSegueWithIdentifier:UINavigationIDExistingSubmit sender:nil];
            });
        };
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

@end
