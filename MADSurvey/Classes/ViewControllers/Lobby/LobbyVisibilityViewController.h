//
//  LobbyVisibilityViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/3/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"


typedef NS_ENUM(NSUInteger, UICellCombo) {
    UICellYes,
    UICellNo,
    UICellNoSelected
    
};

@interface LobbyVisibilityViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * checkImageViews;
    IBOutlet UILabel *indexLabel;
}


@end
