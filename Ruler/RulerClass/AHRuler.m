//
//  AHRuler.m
//  Ruler
//
//  Created by 呜拉巴哈 on 16/2/1.
//  Copyright © 2016年 http://www.swiftnews.cn . All rights reserved.
//

#import "AHRuler.h"

#define SHEIGHT 8 // 中间指示器顶部闭合三角形高度
#define INDICATORCOLOR [UIColor redColor].CGColor // 中间指示器颜色

@implementation AHRuler{

//    AHRulerScrollView *rulerScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _rulerScrollVieww = [self rulerScrollView];
        _rulerScrollVieww.rulerHeight = frame.size.height;
        _rulerScrollVieww.rulerWidth = frame.size.width;

    }
    return self;
}


- (void)showRulerScrollViewWithCount:(NSUInteger)count
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode {
    NSAssert(_rulerScrollVieww != nil, @"***** 调用此方法前，请先调用 initWithFrame:(CGRect)frame 方法初始化对象 rulerScrollView\n");
    NSAssert(currentValue < [average floatValue] * count, @"***** currentValue 不能大于直尺最大值（count * average）\n");
    _rulerScrollVieww.rulerAverage = average;
    _rulerScrollVieww.rulerCount = count;
    _rulerScrollVieww.rulerValue = currentValue;
    _rulerScrollVieww.mode = mode;
    [_rulerScrollVieww drawRuler];
    [self addSubview:_rulerScrollVieww];
    //画三角形和底部最长的线
    [self drawRacAndLine];
}






- (AHRulerScrollView *)rulerScrollView {
    AHRulerScrollView * rScrollView = [AHRulerScrollView new];
    rScrollView.delegate = self;
    rScrollView.showsHorizontalScrollIndicator = NO;
    return rScrollView;
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(AHRulerScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat ruleValue = (offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
    if (ruleValue < 0.f) {
        return;
    } else if (ruleValue > scrollView.rulerCount * [scrollView.rulerAverage floatValue]) {
        return;
    }
    if (self.rulerDeletate) {
        if (!scrollView.mode) {
            scrollView.rulerValue = ruleValue;
        }
        scrollView.mode = NO;
        [self.rulerDeletate ahRuler:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(AHRulerScrollView *)scrollView {
    [self animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(AHRulerScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self animationRebound:scrollView];
}

- (void)animationRebound:(AHRulerScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat oX = (offSetX / DISTANCEVALUE) * [scrollView.rulerAverage floatValue];
#ifdef DEBUG
    NSLog(@"ago*****************ago:oX:%f",oX);
#endif
    if ([self valueIsInteger:scrollView.rulerAverage]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
#ifdef DEBUG
    NSLog(@"after*****************after:oX:%.1f",oX);
#endif
    CGFloat offX = (oX / ([scrollView.rulerAverage floatValue])) * DISTANCEVALUE + DISTANCELEFTANDRIGHT - self.frame.size.width / 2;
    [UIView animateWithDuration:.2f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
    }];
}

- (void)drawRacAndLine {
 
    
    //底部直线
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[[UIColor lightGrayColor] CGColor]];
    solidShapeLayer.lineWidth = 1.0f ;
    //top horizon
    CGPathMoveToPoint(solidShapePath, NULL, 0, DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(solidShapePath, NULL, self.frame.size.width,DISTANCETOPANDBOTTOM);
    //bottom horizion
    CGPathMoveToPoint(solidShapePath, NULL, 0, self.frame.size.height-DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(solidShapePath, NULL, self.frame.size.width,self.frame.size.height-DISTANCETOPANDBOTTOM);
    

    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    
    
    
    // 渐变
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor];
    
    gradient.locations = @[[NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.6f]];
    
    gradient.startPoint = CGPointMake(0, .5);
    gradient.endPoint = CGPointMake(1, .5);

    
    [self.layer addSublayer:solidShapeLayer];
    //俩边渐变效果
//    [self.layer addSublayer:gradient];
    
    // 红色指示器
    CAShapeLayer *shapeLayerLine = [CAShapeLayer layer];
    shapeLayerLine.strokeColor = [UIColor redColor].CGColor;
    shapeLayerLine.fillColor = INDICATORCOLOR;
    shapeLayerLine.lineWidth = 1.f;
    shapeLayerLine.lineCap = kCALineCapSquare;
    
//    NSUInteger ruleHeight = 20; // 文字占的高度
    CGMutablePathRef pathLine = CGPathCreateMutable();
    
    //底部三角形
    CGPathMoveToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height - DISTANCETOPANDBOTTOM-SHEIGHT);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2+ SHEIGHT / 2, self.frame.size.height - DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 -SHEIGHT / 2, self.frame.size.height - DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height - DISTANCETOPANDBOTTOM-SHEIGHT);
    //中间直线
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, DISTANCETOPANDBOTTOM + SHEIGHT);
    //顶部三角形
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 - SHEIGHT / 2, DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 + SHEIGHT / 2, DISTANCETOPANDBOTTOM);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, DISTANCETOPANDBOTTOM + SHEIGHT);
    
    shapeLayerLine.path = pathLine;
    [self.layer addSublayer:shapeLayerLine];
}

#pragma mark - tool method

- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler*roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber*ouncesDecimal;
    NSDecimalNumber*roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces floatValue];
}

- (BOOL)valueIsInteger:(NSNumber *)number {
    NSString *value = [NSString stringWithFormat:@"%f",[number floatValue]];
    if (value != nil) {
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *temp = nil;
        for(int i =0; i < [valueEnd length]; i++)
        {
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}


-(void)updateUIAccodingWithCount:(NSUInteger)count
                         average:(NSNumber *)average
                    currentValue:(CGFloat)currentValue
{
    _rulerScrollVieww.rulerAverage = average;
    _rulerScrollVieww.rulerCount = count;
    _rulerScrollVieww.rulerValue = currentValue;
    
    [_rulerScrollVieww updateRuleUI];
}

-(void)updateCurrentVaulueUIValue:(float)currentValue
{
    _rulerScrollVieww.rulerValue = currentValue;
    [_rulerScrollVieww updateCurrentValueUI];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
