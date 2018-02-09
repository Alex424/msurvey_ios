//
//  ProjectPhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "ProjectPhotosViewController.h"
#import "Constants.h"
#import "PhotoSelectView.h"
#import "DataManager.h"

@interface ProjectPhotosViewController ()

@end

@implementation ProjectPhotosViewController

- (IBAction)next:(id)sender {
    [self performSegueWithIdentifier:UINavigationIDProjectJpbType sender:nil];
}

- (void)viewDidLoad {
    self.photoViewType = UIPhotoTypeProject;
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Project Photos";
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
    
    Photo *photo = [super addNewPhoto:image];
    photo.project = project;
    [project addPhotosObject:photo];
    
    [[DataManager sharedManager] saveChanges];
    
    return photo;
}

- (NSArray *)photos {
    Project *project = [DataManager sharedManager].selectedProject;
    return [project.photos array];
}

@end
