//
//  PhotosViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/14/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "PhotosViewController.h"
#import "Constants.h"
#import "PhotoSelectView.h"
#import "Common.h"
#import "DataManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PhotosViewController () <UIImagePickerControllerDelegate , UINavigationControllerDelegate> {
    NSInteger selectedIndex;
    BOOL retake;
}

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation PhotosViewController

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {

}

- (IBAction)camera:(id)sender {
    retake = NO;

    PhotoSelectView *view = [PhotoSelectView showOnView:self.view];
    [view setCameraBlock:^{
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [Common showWarningAlert:@"Camera is unavailable on device."];
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [view setGalleryBlock:^{
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [Common showWarningAlert:@"Cannot access Photo Library on device."];
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
}

- (IBAction)retake:(id)sender {
    retake = YES;
    
    PhotoSelectView *view = [PhotoSelectView showOnView:self.view];
    [view setCameraBlock:^{
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [Common showWarningAlert:@"Camera is unavailable on device."];
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [view setGalleryBlock:^{
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [Common showWarningAlert:@"Cannot access Photo Library on device."];
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
}

- (IBAction)remove:(id)sender {
    Photo *photo = [self photos][selectedIndex];
    [[DataManager sharedManager] deletePhoto:photo];
    [[DataManager sharedManager] saveChanges];
    
    [self removeImageViewAtIndex:selectedIndex];
}
// now not used
- (void)loadDesc {
    switch (self.photoViewType) {
        case UIPhotoTypeProject:
            descLabel.text = @"Please take a photo(s) of the building.\nEnsure all components are in the photo (or take multiple photos)";
            break;
        case UIPhotoTypeLobby:
            descLabel.text = @"Please take a photo(s) of this lobby.\nEnsure all components are in the photo (or take multiple photos)";
            break;
        case UIPhotoTypeBank:
            descLabel.text = @"Please take a photo(s) of this elevator bank.\nEnsure all components are in the photo (or take multiple photos)";
            break;
        case UIPhotoTypeCar:
            descLabel.text = @"Please take a photo(s) of this Car.\nPlease ensure that you have a photo of the Device License";
            break;
        case UIPhotoTypeCarCOP:
            descLabel.text = @"Please take a photo(s) of this COP.";
            break;
        case UIPhotoTypeCarRiding:
            descLabel.text = @"Please take a photo(s) of this Riding Lantern.";
            break;
        case UIPhotoTypeCarSeparate:
            descLabel.text = @"Please take a photo(s) of this Position Indicator.\n";
            break;
        case UIPhotoTypeHallEntrance:
            descLabel.text = @"Please take a photo(s) of this Car Hall Entrance Frames.";
            break;
        case UIPhotoTypeInterior:
            descLabel.text = @"Please take a photo(s) of this Elevator Cab Interior. Please include Walls,Floor and Ceiling, Escape hatch, Transom, Slam Posts etc.";
            break;
        case UIPhotoTypeIntTransom:
            self.navigationController.title = @"InteriorTransom Photos";
            descLabel.text = @"Please take a photo(s) of this Elevator Car Hall Entrance Frames";
            break;
        case UIPhotoTypeLantern:
            self.navigationController.title = @"Lantern Photos";
            descLabel.text = @"Please take a photo(s) of the lantern/PI.\nEnsure all components are in the photo (or take multiple photos)";
            break;
        case UIPhotoTypeHallStation:
            self.navigationController.title = @"HallStation Photos";
            descLabel.text = @"Please take a photo(s) of the Hall Station.\nEnsure all components are in the photo (or take multiple photos)";
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:148.0/255 green:150.0/255 blue:152.0/255 alpha:1];

    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    backButton.layer.cornerRadius = 6.0f;
    nextButton.layer.cornerRadius = 6.0f;
    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [nextButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -90)];
    [nextButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    photoImageView.layer.cornerRadius = 12.0f;
    photoImageView.clipsToBounds = YES;
    photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoImageView.layer.borderWidth = 4.0f;
    
    retakeButton.clipsToBounds = YES;
    retakeButton.layer.cornerRadius = 4.0f;
    
    removeButton.clipsToBounds = YES;
    removeButton.layer.cornerRadius = 4.0f;
    
    self.imageViews = [NSMutableArray array];

    retakeButton.hidden = YES;
    removeButton.hidden = YES;
    
    NSArray *photos = [self photos];
    for (Photo *photo in photos) {
        [self addImageView:photo];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        delWidth.constant = 120;
        delHeight.constant = 60;
        
        retakeButton.titleLabel.font = [UIFont systemFontOfSize:20];
        removeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:^{
        if (!retake) {
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        if (!retake) {
            [self addNewPhoto:image];
        } else {
            [self replacePhoto:image];
        }
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (NSArray *)photos {
    return nil;
}

- (Photo *)addNewPhoto:(UIImage *)image {
    Photo *photo = [[DataManager sharedManager] createNewPhotoWithImage:image];
    [[DataManager sharedManager] saveChanges];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addImageView:photo];
    });
    return photo;
}

- (void)replacePhoto:(UIImage *)image {
    Photo *photo = [self photos][selectedIndex];
    photo = [[DataManager sharedManager] updatePhoto:photo withImage:image];
    [[DataManager sharedManager] saveChanges];
    
    NSString *fileURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:photo.fileName];
    NSString *url = [fileURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"_thumb.jpg"];
    UIImage *thumb = [UIImage imageWithContentsOfFile:url];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        photoImageView.image = image;
        [self.imageViews[selectedIndex] setImage:thumb];
    });
}

- (void)addImageView:(Photo *)photo {
    NSString *fileURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:photo.fileName];
    NSString *url = [fileURL stringByReplacingOccurrencesOfString:@".jpg" withString:@"_thumb.jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:url];

    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 2.0f;
    imageView.layer.borderWidth = 2.0f;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.frame = CGRectMake(self.imageViews.count * (50 + 10), 22, 50, 44);
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapThumbnail:)];
    [imageView addGestureRecognizer:tap];
    
    [thumbScrollView addSubview:imageView];
    
    [self.imageViews addObject:imageView];

    [thumbScrollView setContentSize:CGSizeMake(60 * self.imageViews.count, 88)];
    [thumbScrollView setContentOffset:CGPointMake(MAX(0, thumbScrollView.contentSize.width - thumbScrollView.frame.size.width), 0) animated:YES];
    
    photoImageView.image = image;
    selectedIndex = self.imageViews.count - 1;
    
    retakeButton.hidden = NO;
    removeButton.hidden = NO;
}

- (void)removeImageViewAtIndex:(NSInteger)index {
    [self.imageViews[index] removeFromSuperview];
    
    [self.imageViews removeObjectAtIndex:index];
    
    for (NSInteger i = index ; i < self.imageViews.count ; i ++ ) {
        UIImageView *imageView = self.imageViews[i];
        [imageView setFrame:CGRectOffset(imageView.frame, -(50 + 10), 0)];
    }

    [thumbScrollView setContentSize:CGSizeMake(60 * self.imageViews.count, 88)];

    if (self.imageViews.count == 0) {
        selectedIndex = -1;
        retakeButton.hidden = YES;
        removeButton.hidden = YES;
        
        photoImageView.image = [UIImage imageNamed:@"img_placeholder_large"];
    } else {
        [self selectPhotoAtIndex:MIN(selectedIndex, self.imageViews.count - 1)];
    }
}


- (void)tapThumbnail:(UIGestureRecognizer *)tap {
    NSInteger index = [self.imageViews indexOfObject:tap.view];
    
    [self selectPhotoAtIndex:index];
}

- (void)selectPhotoAtIndex:(NSInteger)index {
    NSArray *photos = [self photos];
    Photo *photo = photos[index];

    NSString *fileURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:photo.fileName];
    UIImage *image = [UIImage imageWithContentsOfFile:fileURL];
    
    photoImageView.image = image;
    
    selectedIndex = index;

    retakeButton.hidden = NO;
    removeButton.hidden = NO;
}


- (void)backToSpecificViewController:(UIViewController *)viewController {
    [self backToSpecificViewController:viewController class:[viewController class]];
}

- (void)backToSpecificViewController:(UIViewController *)viewController class:(Class)type {
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    for (UIViewController *vc in [self.navigationController.viewControllers reverseObjectEnumerator]) {
        if ([vc isKindOfClass:type]) {
            NSInteger index = [viewControllers indexOfObject:vc];
            [viewControllers removeObjectsInRange:NSMakeRange(index, viewControllers.count - index)];
            break;
        }
    }
    
    [viewControllers addObject:viewController];
    
    [self.navigationController.visibleViewController viewWillDisappear:NO];
    [self.navigationController.visibleViewController viewDidDisappear:NO];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)backToSpecificClass:(Class)aClass {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:aClass]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

@end
