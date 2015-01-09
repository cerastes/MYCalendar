//
//  UIView+MCategory.m
//  MrMoney
//
//  Created by xingyong on 13-12-3.
//  Copyright (c) 2013年 xingyong. All rights reserved.
//

#import "UIView+MCategory.h"
//#import "NSObject+BKBlockObservation.h"

@implementation UIView (MCategory)

-(void)presentView:(UIView *)viewPresent{
    UIView *backView = [[UIView alloc ]initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [backView addSubview:viewPresent];


    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type =  kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [backView.layer addAnimation:transition forKey:nil];

    [self addSubview:backView];


}


-(void)dismisModeView{

    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.4];
    //动画的内容
    self.superview.frame= CGRectMake(0, self.superview.top+400, self.superview.width, self.superview.height);
    //动画结束
    [UIView commitAnimations];

    [self performSelector:@selector(goBack) withObject:nil afterDelay:0.3];
}

-(void)goBack{
    [self.superview removeFromSuperview];
}


#pragma mark - 位置、大小

- (void)pixelAlign {
    self.left = floorf(self.left);
    self.top = floorf(self.top);
    self.width = floorf(self.width);
    self.height = floorf(self.height);
}

- (void)verticalCenterInView:(UIView*)aView {
    self.top = floorf(aView.height/2 - self.height/2);
}
- (void)bottomAlignInView:(UIView*)aView margin:(CGFloat)margin {
    self.top = aView.height - self.height - margin;
}
- (void)horizontalCenterInView:(UIView*)aView {
    self.left = floorf(aView.width/2 - self.width/2);
}

- (void)rightAlignInView:(UIView*)aView margin:(CGFloat)margin {
    self.left = aView.width - self.width - margin;
}



- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
            newSize.width, newSize.height);
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y,
            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,
            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
            newWidth, self.frame.size.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
            self.frame.size.width, newHeight);
}

- (CGFloat)centerX;
{
    return [self center].x;
}

- (void)setCenterX:(CGFloat)centerX;
{
    [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)centerY;
{
    return [self center].y;
}

- (void)setCenterY:(CGFloat)centerY;
{
    [self setCenter:CGPointMake(self.center.x, centerY)];
}

- (CGPoint) bottomRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) topRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y;
	return CGPointMake(x, y);
}
///////////////////////////////////////////////////////
#pragma mark - 层级

-(int)getSubviewIndex
{
    return (int)[self.superview.subviews indexOfObject:self];
}

-(void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

-(void)sentToBack
{
    [self.superview sendSubviewToBack:self];
}

-(void)bringOneLevelUp
{
    int currentIndex = [self getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

-(void)sendOneLevelDown
{
    int currentIndex = [self getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

-(BOOL)isInFront
{
    return ([self.superview.subviews lastObject]==self);
}

-(BOOL)isAtBack
{
    return ([self.superview.subviews objectAtIndex:0]==self);
}

-(void)swapDepthsWithView:(UIView*)swapView
{
    [self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}

///////////////////////////////////////////////////////
#pragma mark - NIB

+ (NSString*)nibName {
    return [self description];
}


+ (id)loadFromNIB {
    Class klass = [self class];
    NSString *nibName = [self nibName];

    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];

    for (id object in objects) {
        if ([object isKindOfClass:klass]) {
            return object;
        }
    }

    [NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one UIView, and its class must be '%@'", nibName, NSStringFromClass(klass)];

    return nil;
}

+ (id)loadFromNIB:(NSString *)reuseIdentify {
    Class klass = [self class];
    NSString *nibName = [self nibName];

    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];

    for (id object in objects) {
        if ([object isKindOfClass:klass]) {
            return [object initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentify];
        }
    }

    [NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one UIView, and its class must be '%@'", nibName, NSStringFromClass(klass)];

    return nil;
}

- (UIViewController *)viewController {
    /// Finds the view's view controller.
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;

    // If the view controller isn't found, return nil.
    return nil;
}

///////////////////////////////////////////////////////
#pragma mark -

- (void)removeAllSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
}


- (UIViewController *) firstViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

-(void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    CALayer *tMaskLayer = [self maskForRoundedCorners:corners withRadii:radii];

    UIView *tSuperview = self.superview;
    if (tSuperview) {
        [self removeFromSuperview];
    }

    self.layer.mask = tMaskLayer;

    if (tSuperview) {
        [tSuperview addSubview:self];
    }
}

-(CALayer*)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;

    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:
            maskLayer.bounds byRoundingCorners:corners cornerRadii:radii];
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
    maskLayer.path = [roundedPath CGPath];

    return maskLayer;
}


@end
