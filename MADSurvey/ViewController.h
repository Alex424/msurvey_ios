//
//  ViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 5/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * menuTableView;
    IBOutlet UIView * infoView;
    
    
    IBOutlet UIView * infoFormView;
    IBOutletCollection(UILabel) NSArray * infoLabels;
    IBOutlet UILabel * madLabel;
}

- (IBAction)info:(id)sender;
- (IBAction)closeInfo:(id)sender;

- (IBAction)gotoMap:(id)sender;
- (IBAction)gotoDial:(id)sender;
- (IBAction)gotoSafari:(id)sender;
- (IBAction)gotoEmail:(id)sender;

@end

