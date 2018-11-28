//
//  UIViewController+HWRuntime.h
//  runtimeTest
//
//  Created by gaucho on 2018/10/22.
//  Copyright © 2018年 gaucho. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LeftTopBtnBlock) (void);
@interface UIViewController (HWRuntime)
/**导航栏背景色*/
@property  UIImageView *topImageView;
/**标题的颜色,default:blcakColor*/
@property  UIColor * titleColor;
/**标题的字体,default:boldSystemFontOfSize:18*/
@property  UIFont * titleFont;
@property  UIImage *HWLeftImage;
//左按钮隐藏,default:NO
@property  BOOL  leftHidden;
/**左 按钮标题,default:返回*/
@property  NSString * leftTitle;
/**左按钮标题颜色*/
@property  UIColor * leftColor;
/**导航栏的背景色*/
@property UIColor *navigationBGColor;
/**导航栏透明度*/
@property float naviBGAlpha;
/**左侧返回按钮的点击回调事件*/
@property (nonatomic,copy)  LeftTopBtnBlock leftOnBtn;
@end
