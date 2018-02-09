//
//  LobbyLocationViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellLobbyLocation) {
    UICellZero,
    UICellCACFRoom,
    UICellFire,
    UICellSecurity,
    UICellOther,
    UICellNoSelected
    
};

@interface LobbyLocationViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * checkImageViews;
    IBOutlet UILabel *indexLabel;
}

-(IBAction)checkAction:(id)sender;


@end
