//
//  HallStationDescriptionViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/6/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

typedef NS_ENUM(NSUInteger, UICellHallStationDescriptionCell) {
    UICellTerminal,
    UICellIntermediate,
    UICellFireOperation,
    UICellEFO,
    UICellAccess,
    UICellSwingHall,
    UICellSwingTerminal,
    UICellOther,
    UICellNoSelected
};

@interface HallStationDescriptionViewController : MADMotherViewController
{
    IBOutletCollection(UIImageView) NSArray * checkImageViews;
    
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * floorLabel;
    IBOutlet UILabel * hallStationLabel;
}

-(IBAction)checkAction:(id)sender;

@end
