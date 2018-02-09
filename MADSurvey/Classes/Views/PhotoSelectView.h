//
//  PhotoSelectView.h
//  MADSurvey
//
//  Created by seniorcoder on 6/2/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^proj_photo_camera_block)(void);
typedef void (^proj_photo_gallery_block)(void);

@interface PhotoSelectView : UIView
{
    IBOutlet UIView * selectView;
}

@property (nonatomic) proj_photo_camera_block cameraBlock;
@property (nonatomic) proj_photo_gallery_block galleryBlock;

- (IBAction)close:(id)sender;

- (IBAction)camera:(id)sender;
- (IBAction)gallery:(id)sender;

+ (PhotoSelectView*) showOnView:(UIView*) view;

@end
