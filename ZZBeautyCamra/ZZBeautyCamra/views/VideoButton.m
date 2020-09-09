//
//  VideoButton.m
//  ZZBeautyCamra
//
//  Created by 泽泽 on 2020/9/8.
//  Copyright © 2020 泽泽. All rights reserved.
//

#import "VideoButton.h"
@interface VideoButton ()
{
    UILabel *_numberLabel;
    CAShapeLayer *circleLayer;
    NSTimer *timer;
    CADisplayLink *displayLink;
    float interval;
    int num;
    
    BOOL recordEnable;
}
@end
@implementation VideoButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        self.layer.cornerRadius = frame.size.width/2;
//        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    recordEnable = NO;
    circleLayer = [CAShapeLayer layer];
    circleLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 2 startAngle:-M_PI_2 endAngle: M_PI + M_PI_2 clockwise:YES];
    circleLayer.path = circlePath.CGPath;
    circleLayer.lineWidth = 6.0f;
    circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
//    circleLayer.lineDashPattern = @[@1,@2];
    [self.layer addSublayer:circleLayer];
    circleLayer.strokeStart = 0.0;
    circleLayer.strokeEnd = 0.0;
    
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
    _numberLabel.textAlignment = 1;
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:_numberLabel];
    
    UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [backControl addTarget:self action:@selector(switchRecord) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backControl];
    
}

- (void)switchRecord
{
    recordEnable = !recordEnable;
    if(recordEnable){
        [self startRecordAnimation];
    }else{
        [self stopRecordAnimation];
    }
}

- (void)startRecordAnimation
{
    circleLayer.strokeEnd = 0.0;
    _numberLabel.text = @"0";
    _numberLabel.hidden = NO;
    circleLayer.hidden = NO;
    NSInteger preferredFramesPerSecond = 15;
    if(displayLink == nil){
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeState)];
        displayLink.preferredFramesPerSecond = preferredFramesPerSecond;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        interval = 1.0/(15.0 * 15.0);
        if([self.delegate respondsToSelector:@selector(videoButtonRecordAnimationStatus:)]){
            [self.delegate videoButtonRecordAnimationStatus:0];
        }
    }
}
- (void)stopRecordAnimation
{
    _numberLabel.hidden = YES;
    circleLayer.hidden = YES;
    num = 0;
    recordEnable = NO;
    circleLayer.strokeEnd = 0.0;
    if(displayLink){
        [displayLink invalidate];
        displayLink = nil;
    }
    //回调
    if([self.delegate respondsToSelector:@selector(videoButtonRecordAnimationStatus:)]){
        [self.delegate videoButtonRecordAnimationStatus:1];
    }
}
- (void)changeState
{
    if(circleLayer.strokeEnd < 1){
        self->circleLayer.strokeEnd+=interval;
    }
    if(num/15 > 15){
        [self stopRecordAnimation];
    }else{
        _numberLabel.text = [NSString stringWithFormat:@"%d",num/15];
    }
    num+=1;
}

- (void)dealloc
{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    if(displayLink){
        [displayLink invalidate];
        displayLink = nil;
    }
}

@end
