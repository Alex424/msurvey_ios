//
//  MADInfoAlert.h
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^alert_ok_block)(void);
typedef void (^alert_close_block)(void);

@interface MADInfoAlert : UIView
{
    IBOutlet UIView * alertView;
}

@property (nonatomic) alert_ok_block okBlock;
@property (nonatomic) alert_close_block closeBlock;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel * descLabel;

- (IBAction)ok:(id)sender;
- (IBAction)close:(id)sender;

+ (MADInfoAlert*) showOnView:(UIView*) view withTitle:(NSString*) title subTitle:(NSString*)subtitle description:(NSString*) desc;

@end
