//
//  InteriorCarCeilingFrameTypeViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/5/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellLobbyLocation) {
    UICellZero,
    UICellCeilingMounted,
    UICellWallMounted,
    UICellBolted,
    UICellWelded,
    UICellOther,
    UICellNoSelected
    
};
@interface InteriorCarCeilingFrameTypeViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * checkImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * carLabel;
}
-(IBAction)checkAction:(id)sender;

@end
