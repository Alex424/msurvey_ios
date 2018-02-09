//
//  MADMainCell.h
//  MADSurvey
//
//  Created by seniorcoder on 5/29/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UICellTypeMain) {
    UICellTypeMainNew,
    UICellTypeMainExisting,
    UICellTypeMainSetting,
};

@interface MADMainCell : UITableViewCell
{
    IBOutlet UILabel * titleLabel;
    IBOutlet UIImageView * iconImageView;
}

@property (nonatomic) NSUInteger cellType;

@end
