//
//  ProjectJpbTypeViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellCombo) {
    UICellService,
    UICellMod,
    UICellNoSelected
};

@interface ProjectJpbTypeViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * comboImageViews;
}

-(IBAction)comboAction:(id)sender;

@end
