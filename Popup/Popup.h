//
//  Popup.h
//  PopupDemo
//
//  Created by Mark Miscavage on 4/16/15.
//  Copyright (c) 2015 Mark Miscavage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopupButtonType) {
    PopupButtonSuccess = 0,
    PopupButtonCancel
};

typedef NS_ENUM(NSInteger, PopupType) {
    PopupTypeSuccess = 0,
    PopupTypeError
};

typedef NS_ENUM(NSInteger, PopupBackGroundBlurType) {
    PopupBackGroundBlurTypeDark = 0,
    PopupBackGroundBlurTypeLight,
    PopupBackGroundBlurTypeExtraLight,
    PopupBackGroundBlurTypeNone
};

typedef NS_ENUM(NSUInteger, PopupIncomingTransitionType) {
    PopupIncomingTransitionTypeBounceFromCenter = 0,
    PopupIncomingTransitionTypeSlideFromLeft,
    PopupIncomingTransitionTypeSlideFromTop,
    PopupIncomingTransitionTypeSlideFromBottom,
    PopupIncomingTransitionTypeSlideFromRight,
    PopupIncomingTransitionTypeEaseFromCenter,
    PopupIncomingTransitionTypeAppearCenter,
    PopupIncomingTransitionTypeFallWithGravity,
    PopupIncomingTransitionTypeGhostAppear,
    PopupIncomingTransitionTypeShrinkAppear
};

typedef NS_ENUM(NSUInteger, PopupOutgoingTransitionType) {
    PopupOutgoingTransitionTypeBounceFromCenter = 0,
    PopupOutgoingTransitionTypeSlideToLeft,
    PopupOutgoingTransitionTypeSlideToTop,
    PopupOutgoingTransitionTypeSlideToBottom,
    PopupOutgoingTransitionTypeSlideToRight,
    PopupOutgoingTransitionTypeEaseToCenter,
    PopupOutgoingTransitionTypeDisappearCenter,
    PopupOutgoingTransitionTypeFallWithGravity,
    PopupOutgoingTransitionTypeGhostDisappear,
    PopupOutgoingTransitionTypeGrowDisappear
};


typedef void (^blocky)(void);


@class Popup;

@protocol PopupDelegate;

@interface Popup : UIView


@property (nonatomic, weak) id <PopupDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                  cancelTitle:(NSString *)cancelTitle
                 successTitle:(NSString *)successTitle;

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
        textFieldPlaceholders:(NSArray *)textFieldPlaceholderArray
                  cancelTitle:(NSString *)cancelTitle
                 successTitle:(NSString *)successTitle
                  cancelBlock:(blocky)cancelBlock
                 successBlock:(blocky)successBlock;

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                  cancelTitle:(NSString *)cancelTitle
                 successTitle:(NSString *)successTitle
                  cancelBlock:(blocky)cancelBlock
                 successBlock:(blocky)successBlock;


@property (nonatomic, assign) PopupIncomingTransitionType incomingTransition;
@property (nonatomic, assign) PopupOutgoingTransitionType outgoingTransition;

@property (nonatomic, assign) PopupBackGroundBlurType backgroundBlurType;

@property (nonatomic, assign) UIColor *backgroundColor;
@property (nonatomic, assign) UIColor *borderColor;
@property (nonatomic, assign) UIColor *titleColor;
@property (nonatomic, assign) UIColor *subTitleColor;
@property (nonatomic, assign) UIColor *successBtnColor;
@property (nonatomic, assign) UIColor *successTitleColor;
@property (nonatomic, assign) UIColor *cancelBtnColor;
@property (nonatomic, assign) UIColor *cancelTitleColor;

- (void)showPopup;
- (void)dismissPopup:(PopupButtonType)buttonType;

- (void)setOverallKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance;
- (void)setKeyboardTypeForTextFields:(NSArray *)keyboardTypeArray;
- (void)setTextFieldTypeForTextFields:(NSArray *)textFieldTypeArray;

@property (nonatomic, assign) BOOL roundedCorners;


@end

@protocol PopupDelegate <NSObject>

@optional


- (void)popupWillAppear:(Popup *)popup;
- (void)popupDidAppear:(Popup *)popup;
- (void)popupWilldisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType;
- (void)popupDidDisappear:(Popup *)popup buttonType:(PopupButtonType)buttonType;


- (void)popupPressButton:(Popup *)popup buttonType:(PopupButtonType)buttonType;


- (void)dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray;


@end