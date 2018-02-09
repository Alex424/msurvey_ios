//
//  PhotosViewController.h
//  MADSurvey
//
//  Created by seniorcoder on 6/14/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPhotoType) {
    UIPhotoTypeProject,
    UIPhotoTypeLobby,
    UIPhotoTypeBank,
    UIPhotoTypeCar,
    UIPhotoTypeCarCOP,
    UIPhotoTypeCarRiding,
    UIPhotoTypeCarSeparate,
    UIPhotoTypeHallEntrance,
    UIPhotoTypeInterior,
    UIPhotoTypeIntTransom,
    UIPhotoTypeLantern,
    UIPhotoTypeHallStation,
};

@class Photo;

@interface PhotosViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIButton * backButton;
    IBOutlet UIButton * nextButton;
    
    IBOutlet UIButton * retakeButton;
    IBOutlet UIButton * removeButton;
    IBOutlet UIImageView * photoImageView;
    
    IBOutlet UIScrollView * thumbScrollView;
    IBOutlet UILabel * descLabel;
    
    IBOutlet NSLayoutConstraint * delWidth;
    IBOutlet NSLayoutConstraint * delHeight;
}

@property (nonatomic) NSUInteger photoViewType;

- (IBAction)back:(id)sender;
- (IBAction)next:(id)sender;

- (IBAction)camera:(id)sender;
- (IBAction)retake:(id)sender;
- (IBAction)remove:(id)sender;

- (NSArray *)photos;

- (Photo *)addNewPhoto:(UIImage *)image;
- (void)addImageView:(Photo *)photo;
- (void)removeImageViewAtIndex:(NSInteger)index;

- (void)backToSpecificViewController:(UIViewController *)viewController;
- (void)backToSpecificViewController:(UIViewController *)viewController class:(Class)type;
- (void)backToSpecificClass:(Class)aClass;

@end
