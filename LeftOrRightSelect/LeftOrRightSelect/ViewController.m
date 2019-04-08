//
//  ViewController.m
//  LeftOrRightSelect
//
//  Created by Sun on 2019/4/8.
//  Copyright © 2019 Sun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) NSMutableArray *viewArray;
@property (nonatomic,strong) UIView *firstView;
@property (nonatomic,strong) UIView *lastView;
#define Screen_W  [UIScreen mainScreen].bounds.size.width
#define Screen_H  [UIScreen mainScreen].bounds.size.height
#define ImageSpace 20 //每张图片底部距离
#define ImageScale 0.1 //每张图片初始化缩小尺寸

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewArray = [[NSMutableArray alloc]init];
    [self setUI];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)setUI{
    NSArray *colorArr = @[[UIColor orangeColor],[UIColor blueColor],[UIColor greenColor],[UIColor redColor]];
    for (int i = 0; i<4; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
        view.tag = 100 + i;
        int index = i;
        if (i ==3) {
            index = 2;
        }
        view.center = CGPointMake(Screen_W/2, Screen_H/2 +(400 *ImageScale*index/2) + ImageSpace * index);
        view.transform =  CGAffineTransformMakeScale(1 - ImageScale*index, 1 - ImageScale *index);
        view.backgroundColor = colorArr[i];
    
        [_viewArray addObject:view];
        [self.view addSubview:view];
        [self.view sendSubviewToBack:view];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
        [view addGestureRecognizer:pan];
        view.userInteractionEnabled = NO;
        if (i == 0) {
            view.userInteractionEnabled = YES;
            self.firstView = view;
        }else if (i ==3){
            self.lastView = view;
        }
    }
}
-(void)panHandle:(UIPanGestureRecognizer *)pan{
    UIView *view = pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        //ll开始拖动
    }else if (pan.state == UIGestureRecognizerStateChanged){
        //正在拖动
        CGPoint viewLocation = [pan translationInView:view];
        view.center = CGPointMake(view.center.x + viewLocation.x, view.center.y + viewLocation.y);
        CGFloat XOffPercent = (view.center.x - Screen_W/2.0)/(Screen_W/2.0);
        CGFloat rotation = M_PI_2/4*XOffPercent;
        view.transform = CGAffineTransformMakeRotation(rotation);
        [pan setTranslation:CGPointZero inView:view];
        [self animationBlowViewWithXOffPercent:fabs(XOffPercent)];
    }else if (pan.state == UIGestureRecognizerStateEnded){
        //拖动结束
        if (view.center.x > 60 && view.center.x < Screen_W - 60) {
            [UIView animateWithDuration:0.25 animations:^{
                view.center =  CGPointMake(Screen_W/2, Screen_H/2);
                view.transform = CGAffineTransformMakeRotation(0);
                [self animationBlowViewWithXOffPercent:0];
            }];
        }else{
            if (view.center.x < 60) {
                [UIView animateWithDuration:0.3 animations:^{
                    view.center = CGPointMake(-200, view.center.y);
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    view.center = CGPointMake(Screen_W +200, view.center.y);
                }];
            }
            [self animationBlowViewWithXOffPercent:1];
            [self performSelector:@selector(viewRemove) withObject:view afterDelay:0.25];
        }
    }
}

-(void)animationBlowViewWithXOffPercent:(CGFloat)XCoffPercent{
    for (UIView *view in self.viewArray) {
        if (view != self.firstView && view.tag != 103) {
            NSInteger index = view.tag - 100;
            view.center = CGPointMake(Screen_W/2, Screen_H/2 +(400 *ImageScale *index/2) + ImageSpace *index - XCoffPercent*ImageSpace - (400 *ImageScale*index/2)*XCoffPercent);
            CGFloat scale = 1 - ImageScale *index + XCoffPercent *ImageScale;
            view.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    
    
}
-(void)viewRemove{
    [self.viewArray removeObject:self.firstView];
    [self.viewArray addObject:self.firstView];
    
    for (int i= 0; i< 4; i++) {
        UIView *v  = self.viewArray[i];
        v.tag = 100 + i;
    }
    
    self.firstView.userInteractionEnabled = NO;
    self.firstView.center = CGPointMake(Screen_W/2, Screen_H/2 +(400 * 0.1*2/2)+ ImageSpace*2);
    self.firstView.transform = CGAffineTransformMakeScale(1 - 0.1*2, 1- 0.1*2);
    [self.view sendSubviewToBack:self.firstView];
    self.lastView = self.firstView;
    UIView *currentView = self.viewArray.firstObject;
    currentView.userInteractionEnabled = YES;
    self.firstView = currentView;
}

@end
