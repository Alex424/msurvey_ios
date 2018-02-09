//
//  SubmitProjectViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/1/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "MADMotherViewController.h"

@interface SubmitProjectViewController : MADMotherViewController
{
    IBOutlet UILabel * projNameLabel;
    IBOutlet UILabel * projDateLabel;
    IBOutlet UILabel * submitStateLabel;
    IBOutlet UILabel * bankLabel;
    IBOutlet UILabel * lobbyPanelLabel;
    IBOutlet UILabel * hallLanternLabel;
    IBOutlet UILabel * hallStationLabel;
    IBOutlet UILabel * copsLabel;
    IBOutlet UILabel * carIntLabel;
    IBOutlet UILabel * hallEntLabel;
}

- (IBAction)submit:(id)sender;

@end
