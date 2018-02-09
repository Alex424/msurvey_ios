//
//  ExistingSurveyCell.h
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;

@interface ExistingSurveyCell : UITableViewCell
{
    IBOutlet UILabel * projNameLabel;
    IBOutlet UILabel * submitDateLabel;
    IBOutlet UILabel * submitStateLabel;
}

@property (nonatomic, weak) Project *project;

@end
