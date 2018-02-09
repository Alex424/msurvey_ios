//
//  InteriorCarCopyViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 11/26/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellCombo) {
    UICellUnique,
    UICellSameAsLast,
    UICellSameAs
};

@interface InteriorCarCopyViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
}

-(IBAction)comboAction:(id)sender;

@end
