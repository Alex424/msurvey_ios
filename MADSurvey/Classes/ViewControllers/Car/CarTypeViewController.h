//
//  CarTypeViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellType) {
    UICellPassenger,
    UICellService,
    UICellFreight,
    UICellOther,
    UICellNoSelected
};

@interface CarTypeViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * checkImageViews;

    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
}

-(IBAction)checkAction:(id)sender;

@end
