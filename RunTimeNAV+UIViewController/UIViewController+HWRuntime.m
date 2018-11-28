//
//  UIViewController+HWRuntime.m
//  runtimeTest
//
//  Created by gaucho on 2018/10/22.
//  Copyright © 2018年 gaucho. All rights reserved.
//

        #import "UIViewController+HWRuntime.h"
        #import <objc/runtime.h>
        @interface UIViewController (HWRuntimeTest)
        @property UILabel *titleLabel;
        @property UIButton *HWLeftTopBtn;
        @property  UIView *topView;
        /**导航栏标题*/
        @property  NSString *titleTest;
        @end
        @implementation UIViewController (HWRuntime)
        - (CGFloat)naviBarHeight {
            return [self iSiphoneX] ? 88 : 64;
        }
        - (CGFloat)statusBarHeight {
            return [self iSiphoneX] ? 40 : 20;
        }
        - (BOOL)iSiphoneX{
            BOOL iphoneXLater = NO;
            if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
                return iphoneXLater;
            }
            if (@available(iOS 11.0, *)) {
                UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
                if (mainWindow.safeAreaInsets.bottom > 0.0) {
                    iphoneXLater = YES;
                }
            }
            return iphoneXLater;
        }
        + (void)load{
            
            SEL changeMethodArray[4] = {
                @selector(viewWillAppear:),
                @selector(viewWillDisappear:),
                @selector(viewDidLoad),
                @selector(setTitle:)
            };
            for (int i = 0; i<4; i++) {
                SEL selector = changeMethodArray[i];
                NSString *methodSting = [NSString stringWithFormat:@"HW_%@",NSStringFromSelector(selector)];
                Method originMethodAssociation = class_getInstanceMethod(self, selector);
                Method HWMethod = class_getInstanceMethod(self, NSSelectorFromString(methodSting));
                method_exchangeImplementations(originMethodAssociation, HWMethod);
            }
        }

        #pragma mark ----------LW_viewWillAppear-------------
        - (void)HW_viewWillAppear:(BOOL)animated{
            
            if ([self isMemberOfClass:[UINavigationController class]]) {return;}
            
            if ([self canUpdateNavigation]) {
                self.navigationController.navigationBar.hidden = YES;
                [self updateNavigation];
            }
            [self HW_viewWillAppear:animated];
        }
        #pragma mark ----HW_viewDidLoad-----------
        #define KScreenW [UIScreen mainScreen].bounds.size.width
        - (void)HW_viewDidLoad{
            if ([self isMemberOfClass:[UINavigationController class]]) {
                return;
            }
            if ([self canUpdateNavigation]) {
                self.navigationController.navigationBar.hidden = YES;
                [self updateNavigation];
            }
            [self HW_viewDidLoad];
            [self setupSubUI];
            
        }


        - (void)HW_setTitle:(NSString *)title{
            if ([self isMemberOfClass:[UINavigationController class]]) {
                return;
            }
            self.titleTest= title;
        }
        - (void)setTitleTest:(NSString *)titleTest{
            
            objc_setAssociatedObject(self, @selector(titleTest), titleTest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (NSString *)titleTest{
            NSString * titleText = (NSString *)objc_getAssociatedObject(self, _cmd);
            return titleText ? titleText : nil;
        }
        //标题颜色
        - (UIColor *)titleColor {
            UIColor * titleColor = (UIColor *)objc_getAssociatedObject(self, _cmd);
            return titleColor ? titleColor : [UIColor blackColor];
        }
        - (void)setTitleColor:(UIColor *)titleColor {
            objc_setAssociatedObject(self, @selector(titleColor), titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        //标题字体
        - (UIFont *)titleFont {
            UIFont * titleFont = (UIFont *)objc_getAssociatedObject(self, _cmd);
            return titleFont ? titleFont : [UIFont boldSystemFontOfSize:18];
        }
        - (void)setTitleFont:(UIFont *)titleFont {
            objc_setAssociatedObject(self, @selector(titleFont), titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        //返回图片
        - (void)setHWLeftImage:(UIImage *)HWLeftImage{
            
            objc_setAssociatedObject(self, @selector(HWLeftImage), HWLeftImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (UIImage *)HWLeftImage{
            
            UIImage *image = (UIImage *)objc_getAssociatedObject(self, _cmd);
            return image ? image :nil;
        }
        #pragma mark------------导航栏控件-------------
        - (void)updateNavigation{
            [self.view bringSubviewToFront:self.topView];
            [self.view bringSubviewToFront:self.topImageView];
            [self.view bringSubviewToFront:self.HWLeftTopBtn];
            [self.view bringSubviewToFront:self.titleLabel];
            [self isFirstViewController];
            self.titleLabel.text = self.titleTest;
            self.titleLabel.textColor = self.titleColor;
            self.titleLabel.font = self.titleFont;
            if (self.HWLeftImage) {
                [self.HWLeftTopBtn setImage:self.HWLeftImage forState:UIControlStateNormal];
                [self.HWLeftTopBtn setTitle:nil forState:UIControlStateNormal];
                [self.HWLeftTopBtn setImage:self.HWLeftImage forState:UIControlStateHighlighted];
            }else{
                [self.HWLeftTopBtn setTitle:self.leftTitle forState:UIControlStateNormal];
            }
            [self.HWLeftTopBtn setTitleColor:self.leftColor forState:UIControlStateNormal];
            if (self.navigationBGColor) {
                self.topImageView.backgroundColor = self.navigationBGColor;
            }
            if (self.naviBGAlpha) {
                self.topImageView.alpha = self.naviBGAlpha;
            }
            if (self.naviBGAlpha == 0) {
                self.topImageView.hidden = YES;
            }
            if (self.navigationBGColor == [UIColor whiteColor] && self.naviBGAlpha >= 1.0) {
                self.naviBGAlpha = 0.5;
            }
        }

        #pragma mark------------是否是首个控制器-----------
        - (void)isFirstViewController{
            if(self.navigationController.childViewControllers.count>1)
            {
                self.HWLeftTopBtn.hidden = NO;
            }else{
                self.HWLeftTopBtn.hidden = YES;
            }
        }
        #pragma mark------------属性----------------
        - (void)setLeftColor:(UIColor *)leftColor{
            
            objc_setAssociatedObject(self, @selector(leftColor), leftColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (UIColor *)leftColor{
            
            UIColor *leftColor = (UIColor *)objc_getAssociatedObject(self, _cmd);
            return leftColor?leftColor:nil;
        }
        - (void)setNavigationBGColor:(UIColor *)navigationBGColor{
            
            objc_setAssociatedObject(self, @selector(navigationBGColor), navigationBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (UIColor *)navigationBGColor{
            UIColor *navBGColor = objc_getAssociatedObject(self, _cmd);
            return navBGColor?navBGColor:nil;
        }
        - (void)setLeftHidden:(BOOL)leftHidden{
            
            objc_setAssociatedObject(self, @selector(leftHidden), @(leftHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (BOOL)leftHidden{
            
            id leftHidden = objc_getAssociatedObject(self, _cmd);
            return leftHidden ? [leftHidden boolValue] : NO;
        }
        - (BOOL)canUpdateNavigation{
            
            return [self.navigationController.viewControllers containsObject:self];
        }
        - (void)setLeftTitle:(NSString *)leftTitle{
            
            objc_setAssociatedObject(self, @selector(leftTitle), leftTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (NSString *)leftTitle{
            NSString *leftString = (NSString *)objc_getAssociatedObject(self, _cmd);
            return leftString?leftString:nil;
        }//左侧按钮
        - (void)setHWLeftTopBtn:(UIButton *)HWLeftTopBtn{
            
            objc_setAssociatedObject(self, @selector(HWLeftTopBtn), HWLeftTopBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (UIButton *)HWLeftTopBtn{
            
            return (UIButton*)objc_getAssociatedObject(self, _cmd);
        }
        - (void)setLeftOnBtn:(LeftTopBtnBlock)leftOnBtn{
            
            objc_setAssociatedObject(self, @selector(leftOnBtn), leftOnBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }
        - (LeftTopBtnBlock)leftOnBtn{
            
            return  objc_getAssociatedObject(self, _cmd);
        }
        - (void)setTopView:(UIView *)topView{
            
            objc_setAssociatedObject(self, @selector(topView), topView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (UIView *)topView{
            
            return (UIView *)objc_getAssociatedObject(self, _cmd);
        }

        - (void)setTopImageView:(UIImageView *)topImageView{
            
            objc_setAssociatedObject(self, @selector(topImageView), topImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (UIImageView *)topImageView{
            
            return (UIImageView *)objc_getAssociatedObject(self, _cmd);
        }

        - (UILabel *)titleLabel{
            
            return (UILabel *)objc_getAssociatedObject(self, _cmd);
            
        }
        - (void)setTitleLabel:(UILabel *)titleLabel{
            
            objc_setAssociatedObject(self, @selector(titleLabel), titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }
        - (void)setNaviBGAlpha:(float)naviBGAlpha{
            
            objc_setAssociatedObject(self, @selector(naviBGAlpha), @(naviBGAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        - (float)naviBGAlpha{
            
            id alphaColor = objc_getAssociatedObject(self, _cmd);
            return alphaColor?[alphaColor floatValue]:1.0;
        }
        #pragma mark-------------创建控件--------------
        - (void)setupSubUI{
            self.topView = [[UIView alloc] init];
            self.topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self naviBarHeight]);
            [self.view addSubview:self.topView];
            NSLog(@"具体多高===.2%f",[self naviBarHeight]);
            
            self.topImageView = [[UIImageView alloc] init];
            self.topImageView.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self naviBarHeight]);
            [self.view addSubview:self.topImageView];
            
            self.titleLabel = [[UILabel alloc] init];
            self.titleLabel.frame = CGRectMake(55, [self statusBarHeight], [UIScreen mainScreen].bounds.size.width-110, 44);
            [self.view addSubview:self.titleLabel];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.HWLeftTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.HWLeftTopBtn.frame = CGRectMake(10, [self statusBarHeight], 45, 40);
            self.HWLeftTopBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [self.HWLeftTopBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)];
            self.HWLeftTopBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.HWLeftTopBtn addTarget:self action:@selector(LWLeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:self.HWLeftTopBtn];
            
        }

        #pragma mark----导航栏左侧按钮返回调用事件
        - (void)LWLeftBtnAction{
            if (self.leftOnBtn) {
                self.leftOnBtn();
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }

@end
