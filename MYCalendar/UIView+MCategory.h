//
// Created by wangwei on 7/3/14.
// Copyright (c) 2014 com.qianxs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    OUOViewDistanceMeasureGuidelineLeftToLeft,      //从左边到左边
    OUOViewDistanceMeasureGuidelineLeftToRight,     //从左边到右边
    OUOViewDistanceMeasureGuidelineTopToTop,       //从顶边到顶边
    OUOViewDistanceMeasureGuidelineTopToButtom    //从顶边到底边
} OUOViewDistanceMeasureGuideline;


@interface UIView (MCategory)

- (void)presentView:(UIView *)viewPresent;

- (void)dismisModeView;



///////////////////////////////////////////////////////
#pragma mark - 位置、大小

@property CGPoint origin;
@property CGSize size;

@property(readonly) CGPoint bottomLeft;
@property(readonly) CGPoint bottomRight;
@property(readonly) CGPoint topRight;

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;

// Setting these modifies the origin but not the size.
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic, assign) CGFloat centerX;
@property(nonatomic, assign) CGFloat centerY;

- (void)verticalCenterInView:(UIView *)aView;

- (void)horizontalCenterInView:(UIView *)aView;

- (void)rightAlignInView:(UIView *)aView margin:(CGFloat)margin;

- (void)bottomAlignInView:(UIView *)aView margin:(CGFloat)margin;

///////////////////////////////////////////////////////
#pragma mark - 层级

- (int)getSubviewIndex;

- (void)bringToFront;

- (void)sentToBack;

- (void)bringOneLevelUp;

- (void)sendOneLevelDown;

- (BOOL)isInFront;

- (BOOL)isAtBack;

- (void)swapDepthsWithView:(UIView *)swapView;

///////////////////////////////////////////////////////
#pragma mark - NIB

+ (id)loadFromNIB;

+ (id)loadFromNIB:(NSString *)reuseIdentify;

///////////////////////////////////////////////////////
#pragma mark -

- (void)removeAllSubviews;

///////////////////////////////////////////////////////
#pragma mark -


- (UIViewController *)firstViewController;

- (UIViewController *)viewController;

- (id)traverseResponderChainForUIViewController;


/**
*	@brief	视图部分圆角
*
*   指定视图某个角是圆角
*
*	@param 	corners 	指定哪个角是圆角
*	@param 	radii 	圆角的半径
*/
- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;

- (CALayer *)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;
@end