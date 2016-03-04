//
//  LTFloatingView.h
//  LTFloatingView
//
//  Created by ltebean on 16/3/4.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTFloatingViewDelegate <NSObject>
- (void)configureView:(UIView *)view withData:(id)data;
@end

@interface LTFloatingView : UIView
@property (nonatomic) NSInteger stayingSeconds;
@property (nonatomic) CGFloat viewSpacing;
@property (nonatomic, weak) id<LTFloatingViewDelegate> delegate;

- (void)registerViewClass:(Class)viewClass;
- (void)pushDataToLast:(id)data;
- (void)pushDataToFirst:(id)data;

@end
