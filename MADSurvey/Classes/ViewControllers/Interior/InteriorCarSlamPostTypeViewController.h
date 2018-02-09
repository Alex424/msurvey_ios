//
//  InteriorCarSlamPostTypeViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"
#import "Constants.h"

typedef NS_ENUM(NSUInteger, UICellLobbyLocation) {
    UICellA,
    UICellB,
    UICellC,
    UICellOther,
    UICellNoSelected
    
};
@interface InteriorCarSlamPostTypeViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * checkImageViews;
    
}
-(IBAction)checkAction:(id)sender;

@end
