//
//  InteriorCarFrontReturnTypeViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/7/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellLobbyLocation) {
    UICellA,
    UICellB,
    UICellOther,
    UICellNoSelected
    
};

@interface InteriorCarFrontReturnTypeViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * checkImageViews;

}
-(IBAction)checkAction:(id)sender;

@end
