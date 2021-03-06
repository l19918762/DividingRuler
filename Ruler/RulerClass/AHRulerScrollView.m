//
//  AHRulerScrollView.m
//  Ruler
//
//  Created by 呜拉巴哈 on 16/2/1.
//  Copyright © 2016年 http://www.swiftnews.cn . All rights reserved.
//

#import "AHRulerScrollView.h"
#import "LLMyHeader.h"

#define HOMECOLOR [UIColor colorWithRed:53/255.0 green:153/255.0 blue:54/255.0 alpha:1]
@implementation AHRulerScrollView
{
    CAShapeLayer *shapeLayer1;
    CAShapeLayer *shapeLayer2;
}


- (void)setRulerValue:(CGFloat)rulerValue{
    _rulerValue = rulerValue;
}

- (void)drawRuler{

    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = 1.f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 1.f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    //最长线和最短线间隔
    int logestLineAndShorestLineInternal = 15;
    //最长线和中间线间隔
    int logestLineAndMidLineInternal = 10;
    
    CGSize textSize;
    for (int i = 0; i <= self.rulerCount; i++) {
        UILabel *rule = [[UILabel alloc] init];
        rule.textColor = HOMECOLOR;
        rule.text = [NSString stringWithFormat:@"%.0f",i * [self.rulerAverage floatValue]];
        rule.font = [UIFont systemFontOfSize:11.0];
        textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
        if (i % 10 == 0) {
            CGPathMoveToPoint(pathRef2, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef2, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight/2.0 - textSize.height);
            
            rule.frame = CGRectMake(DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , self.rulerHeight/2.0  - textSize.height, 0, 0);
            [rule sizeToFit];
            [self addSubview:rule];
            
            //由下向上的线
            CGPathMoveToPoint(pathRef2, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i ,self.rulerHeight-  DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef2, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight/2.0  + textSize.height);
            
            
        }
        else if (i % 5 == 0) {
            CGPathMoveToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight/2.0 - textSize.height - logestLineAndMidLineInternal);
            //由下向上
            CGPathMoveToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , self.rulerHeight-  DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight/2.0+textSize.height + logestLineAndMidLineInternal);
        }
        else
        {
            CGPathMoveToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight/2.0 - textSize.height - logestLineAndShorestLineInternal);
            
            //由下向上
            CGPathMoveToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , self.rulerHeight-  DISTANCETOPANDBOTTOM);
            CGPathAddLineToPoint(pathRef1, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight/2.0 + textSize.height + logestLineAndShorestLineInternal);
        }
    }
    
    NSLog(@"at least height=%f",(textSize.height+logestLineAndShorestLineInternal+DISTANCETOPANDBOTTOM*2+2)*2);
    
    shapeLayer1.path = pathRef1;
    shapeLayer2.path = pathRef2;
    
    [self.layer addSublayer:shapeLayer1];
    [self.layer addSublayer:shapeLayer2];
    
    self.frame = CGRectMake(0, 0, self.rulerWidth, self.rulerHeight);

    
    // 开启最小模式
    if (_mode) {
//        UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, self.rulerWidth / 2.f - DISTANCELEFTANDRIGHT);
        UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 0);
        self.contentInset = edge;
        self.contentOffset = CGPointMake(DISTANCEVALUE * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth + (self.rulerWidth / 2.f + DISTANCELEFTANDRIGHT), 0);
    }
    else{
        self.contentOffset = CGPointMake(DISTANCEVALUE * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + DISTANCELEFTANDRIGHT, 0);
    }
    
    self.contentSize = CGSizeMake(self.rulerCount * DISTANCEVALUE + DISTANCELEFTANDRIGHT * 2.f, self.rulerHeight);
}

-(void)updateRuleUI
{
    [shapeLayer1 removeFromSuperlayer];
    [shapeLayer2 removeFromSuperlayer];
    [self drawRuler];
}

-(void)updateCurrentValueUI
{
    self.contentOffset = CGPointMake(DISTANCEVALUE * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth + (self.rulerWidth / 2.f + DISTANCELEFTANDRIGHT), 0);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
