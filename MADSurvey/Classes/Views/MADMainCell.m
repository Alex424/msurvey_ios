//
//  MADMainCell.m
//  MADSurvey
//
//  Created by seniorcoder on 5/29/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMainCell.h"

@implementation MADMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellType:(NSUInteger)cellType {
    _cellType = cellType;
    switch (cellType) {
        case UICellTypeMainNew:
        {
            titleLabel.text = @"New Survey";
            [iconImageView setImage:[UIImage imageNamed:@"ic_new_survey"]];
        }
            break;
        case UICellTypeMainExisting:
        {
            titleLabel.text = @"Existing Surveys";
            [iconImageView setImage:[UIImage imageNamed:@"ic_existing_surveys"]];
        }
            break;
        case UICellTypeMainSetting:
        {
            titleLabel.text = @"Settings";
            [iconImageView setImage:[UIImage imageNamed:@"ic_setting"]];
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
