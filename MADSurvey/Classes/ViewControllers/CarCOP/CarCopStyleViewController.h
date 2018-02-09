//
//  CarCopStyleViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellType) {
    UICellApplied,
    UICellSwing,
    UICellNone,
    UICellLeft,
    UICellRight,
    UICellNoSelected
};

@interface CarCopStyleViewController : MADMotherViewController
{
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;

    IBOutletCollection(UIImageView) NSArray * checkImageViews;
}

-(IBAction)checkAction:(id)sender;

@end
