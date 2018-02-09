//
//  SubmitProjectViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "SubmitProjectViewController.h"
#import "MADInfoAlert.h"
#import "DataManager.h"
#import "Constants.h"
#import "Settings.h"
#import "Common.h"
#import "SubmitConfirmView.h"
#import "MADWaitingView.h"

@interface SubmitProjectViewController () {
    NSInteger photoIndex;
    MADWaitingView *waitingView;
}

@property (nonatomic, strong) NSDate *now;
@property (nonatomic, strong) NSString *submitTimeForFilename;
@property (nonatomic, strong) NSArray *photos;

@end

@implementation SubmitProjectViewController

- (IBAction)submit:(id)sender {
    Project *project = [DataManager sharedManager].selectedProject;
    
    SubmitConfirmView *view = [SubmitConfirmView showOnView:self.navigationController.view project:project];
    if (view) {
        view.yesBlock = ^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self postAllPhotos];
            });
        };
    }
    
}

- (void)viewDidLoad {
    // set the toolbartype here
    self.toolbarType = UIToolbarTypeNoNext;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Project *project = [DataManager sharedManager].selectedProject;

    projNameLabel.text = project.name;
    projDateLabel.text = project.surveyDate;
    
    NSString *state;
    if ([project.status isEqualToString:StatusSubmitted]) {
        state = @"Submitted";
    } else {
        state = @"Not Submitted";
    }
    submitStateLabel.text = state;
    
    bankLabel.text = [NSString stringWithFormat:@"%d Banks", (int)project.banks.count];
    lobbyPanelLabel.text = [NSString stringWithFormat:@"%d Lobby Panel", (int)project.lobbies.count];
    hallLanternLabel.text = [NSString stringWithFormat:@"%d Hall Lanterns", (int)[[DataManager sharedManager] getLanternCountForProject:project]];
    hallStationLabel.text = [NSString stringWithFormat:@"%d Hall Stations", (int)[[DataManager sharedManager] getHallStationCountForProject:project]];
    copsLabel.text = [NSString stringWithFormat:@"%d COPs", (int)[[DataManager sharedManager] getCopCountForProject:project]];
    carIntLabel.text = [NSString stringWithFormat:@"%d Car Interiors", (int)[[DataManager sharedManager] getInteriorCarCountForProject:project]];
    hallEntLabel.text = [NSString stringWithFormat:@"%d Hall Entrances", (int)[[DataManager sharedManager] getHallEntranceCountForProject:project]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.title = @"Submit Project";
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


- (void)postAllPhotos {
    self.now = [NSDate date];
    
    Project *project = [DataManager sharedManager].selectedProject;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    project.submitTime = [formatter stringFromDate:self.now];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    self.submitTimeForFilename = [formatter stringFromDate:self.now];
    
    self.photos = [[DataManager sharedManager] getAllPhotosForProject:project];
    photoIndex = 0;
    
    if (self.photos.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            waitingView = [MADWaitingView showOnView:self.navigationController.view withTitle:@"Uploading Photos..."];
        });
    }
    
    [self uploadPhoto:photoIndex];
}

- (void)uploadPhoto:(NSInteger)index {
    if (index >= self.photos.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitingView dismiss];
            waitingView = [MADWaitingView showOnView:self.navigationController.view withTitle:@"Please wait..."];
            
            [self submitProjectData];
        });
        return;
    }
    
    Photo *photo = self.photos[index];

    Project *project = [DataManager sharedManager].selectedProject;

    NSString *name = [project.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *uuid = [project.uuid stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    NSString *projectname = [NSString stringWithFormat:@"%@_%@_%@", name, uuid, self.submitTimeForFilename];
    NSString *filename = photo.fileName;
    NSString *photoURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:photo.fileName];
    NSData *file = [NSData dataWithContentsOfFile:photoURL];

    NSString *url = [kServerUrl stringByAppendingString:@"uploadPhoto.php"];
    
    NSURL *reqURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reqURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSString *boundary = [NSString stringWithFormat:@"14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    request.timeoutInterval = 30;
    
    [request setHTTPMethod:@"POST"];
    
    //Now lets create the body of the post
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/x-jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:file];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //projectName
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"projectname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[projectname dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitingView dismiss];
            waitingView = nil;
            
            [self showWarningAlert:@"Image upload failure! Please try again later."];
        });
        return;
    }
    NSString *resp = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    resp = [resp stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[resp dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitingView dismiss];
            waitingView = nil;
            
            [self showWarningAlert:@"Image upload failure! Please try again later."];
        });
        return;
    }
    
    photo.fileURL = response[@"full_name"];
    [[DataManager sharedManager] saveChanges];
    
    [self uploadPhoto:index + 1];
}

- (void)submitProjectData {
    Project *project = [DataManager sharedManager].selectedProject;

    NSString *name = [project.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *uuid = [project.uuid stringByReplacingOccurrencesOfString:@"-" withString:@"_"];

    Settings *settings = [Settings sharedSettings];

//    NSDictionary *params = @{@"projectData" : [[DataManager sharedManager] getPostJSONForProject:project],
//                             @"projectName" : project.name,
//                             @"sender" : settings.yourName,
//                             @"company" : settings.yourCompany,
//                             @"mnumber" : @(project.no),
//                             @"date" : project.surveyDate,
//                             @"platform" : @"iOS",
//                             @"version" : [Common appVersion],
//                             @"email" : settings.yourEmail,
//                             @"sendpdf" : settings.reportByEmail ? @(1) : @(0),
//                             @"file_name" : [NSString stringWithFormat:@"%@_%@_%@", name, uuid, self.submitTimeForFilename]};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];

    NSString *url = [kServerUrl stringByAppendingString:@"postProject.php"];

    NSData *postData = [NSJSONSerialization dataWithJSONObject:[[DataManager sharedManager] getPostJSONForProject:project] options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@":0," withString:@":\"0.0\","];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@":0;" withString:@":\"0.0\";"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@":0}" withString:@":\"0.0\"}"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@":0]" withString:@":\"0.0\"]"];
    
    NSString *params = [@[@"projectData=", jsonString,
                             @"&projectName=", project.name,
                             @"&sender=", settings.yourName,
                             @"&company=", settings.yourCompany,
                             @"&mnumber=", [NSString stringWithFormat:@"%d", (int)project.no],
                             @"&date=", project.surveyDate,
                             @"&platform=", @"iOS",
                             @"&version=", [Common appVersion],
                             @"&email=", settings.yourEmail,
                             @"&sendpdf=", [NSString stringWithFormat:@"%d", settings.reportByEmail],
                             @"&file_name=", [NSString stringWithFormat:@"%@_%@_%@", name, uuid, self.submitTimeForFilename]] componentsJoinedByString:@""];
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [waitingView dismiss];
                    waitingView = nil;
                    
                    [self showWarningAlert:@"Project upload failure! Please try again later."];
                    return;
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                Project *project = [DataManager sharedManager].selectedProject;
                project.status = StatusSubmitted;
                [[DataManager sharedManager] saveChanges];
                
                [waitingView dismiss];
                waitingView = nil;

                MADInfoAlert *view = [MADInfoAlert showOnView:self.tableView.superview withTitle:project.name subTitle:project.surveyDate description:@"Project successfully sent to MAD Sales"];
                [view setOkBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [view setCloseBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            });
        }] resume];
    });
}


@end
