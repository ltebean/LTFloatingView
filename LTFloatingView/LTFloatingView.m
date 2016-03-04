//
//  LTFloatingView.m
//  LTFloatingView
//
//  Created by ltebean on 16/3/4.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "LTFloatingView.h"


@interface NSMutableArray(Queue)
- (void)push:(id)data;
- (id)pop;
@end
@implementation NSMutableArray(Queue)
- (void)push:(id)data
{
    [self addObject:data];
}
- (id)pop
{
    if (self.count == 0) {
        return nil;
    }
    id data = self[0];
    [self removeObjectAtIndex:0];
    return data;
}
@end



@interface LTFloatingView()
@property (nonatomic) CGFloat speed;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *dataQueue;
@property (nonatomic, strong) NSMutableArray *unusedViews;
@property (nonatomic, strong) NSMutableSet *viewsUnderAnimation;
@property (nonatomic, strong) Class viewClass;
@property (nonatomic) CFTimeInterval previousTime;
@end

@implementation LTFloatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.dataQueue = [NSMutableArray array];
    self.viewsUnderAnimation = [NSMutableSet set];
    self.unusedViews = [NSMutableArray array];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    self.previousTime = 0;
}

- (void)tick:(CADisplayLink *)displayLink
{
    CGFloat height = self.bounds.size.height;
    CFTimeInterval currentTime = [displayLink timestamp];
    CFTimeInterval deltaTime = currentTime - self.previousTime;
    CGFloat distance = deltaTime * self.speed;
    self.previousTime = currentTime;

    // animate all views up
    NSArray *views = self.subviews;
    for (UIView *view in views) {
        CGFloat top = view.frame.origin.y - distance;
        view.frame = CGRectMake(view.frame.origin.x, top, view.frame.size.width, view.frame.size.height);
        // animate view alpah to 0 then remove it for reuse
        if (top < 0 && ![self.viewsUnderAnimation containsObject:view]) {
            [self.viewsUnderAnimation addObject:view];
            [UIView animateWithDuration:0.3 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                [self.viewsUnderAnimation removeObject:view];
                view.alpha = 1;
                [self.unusedViews addObject:view];
            }];
        }
    }
    
    // check whether we need to add a view
    UIView *lastView = [self.subviews lastObject];
    if (self.dataQueue.count > 0) {
        if (!lastView || (lastView.frame.origin.y + lastView.frame.size.height + self.viewSpacing) <= height) {
            id data = [self.dataQueue pop];
            UIView *view = [self.unusedViews pop];
            if (!view) {
                view = [[self.viewClass alloc] initWithFrame:CGRectZero];
                NSLog(@"init new view");
            }
            [self.delegate configureView:view withData:data];
            view.frame = CGRectMake(view.frame.origin.x, height, view.frame.size.width, view.frame.size.height);
            [self addSubview:view];
        }
    }
}


- (void)setStayingSeconds:(NSInteger)stayingSeconds
{
    _stayingSeconds = stayingSeconds;
    [self recalculateSpeed];
}

- (void)registerViewClass:(Class)viewClass
{
    self.viewClass = viewClass;
}

- (void)pushDataToLast:(id)data
{
    [self.dataQueue addObject:data];
}

- (void)pushDataToFirst:(id)data
{
    [self.dataQueue insertObject:data atIndex:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self recalculateSpeed];
}

- (void)recalculateSpeed
{
    self.speed = self.bounds.size.height / self.stayingSeconds;
}
@end



