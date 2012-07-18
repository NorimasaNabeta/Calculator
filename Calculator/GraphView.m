//
//  GraphView.m
//  Calculator
//
//  Created by 式正 鍋田 on 12/07/13.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView
@synthesize scale=_scale;
@synthesize offOrigin=_offOrigin;
@synthesize midPoint=_midPoint;
@synthesize dataSource=_dataSource;


#define DEFAULT_SCALE 0.90

- (CGFloat) scale
{
    if (! _scale) {
        _scale=DEFAULT_SCALE;
    }
    return _scale;
}
- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}


- (void)tap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint tapPoint = [gesture locationInView:gesture.view];
        //NSLog(@"%g, %g", tapPoint.x, tapPoint.y);
        self.midPoint=tapPoint;
        [self setNeedsDisplay];
    }
}


- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        // NSLog(@"%g, %g", translation.x, translation.y);
        self.offOrigin = CGPointMake((self.offOrigin.x+translation.x/2),
                                     (self.offOrigin.y+translation.y/2));
        [self setNeedsDisplay];
        
        // reset
        [gesture setTranslation:CGPointZero inView:self];
    }
}


- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
    self.offOrigin = CGPointZero;
    self.midPoint = CGPointMake((self.bounds.origin.x + self.bounds.size.width/2),
                                (self.bounds.origin.y + self.bounds.size.height/2));
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup]; // get initialized when we come out of a storyboard
    }
    return self;
}

// http://stackoverflow.com/questions/899600/how-can-i-add-cgpoint-objects-to-an-nsarray-the-easy-way
// NSArray *points = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(5.5, 6.6)],
//                                             [NSValue valueWithCGPoint:CGPointMake(7.7, 8.8)],nil];
//
// NSValue *val = [points objectAtIndex:0];
// CGPoint p = [val CGPointValue];
//
// Lecture4 'Views' --> drawing on NSView 
//
// [PortateMode] x*y=(3/2):1
- (void) drawGraph: (NSArray*) arrayPoints
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint originPoint= CGPointMake(self.midPoint.x+self.offOrigin.x, self.midPoint.y + self.offOrigin.y );

    UIGraphicsPushContext(context);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextBeginPath(context);
    NSUInteger idx =0;
    CGPoint pnt = [[arrayPoints objectAtIndex:idx] CGPointValue];
    CGContextMoveToPoint(context, (pnt.x + originPoint.x), ((-3/2) *pnt.y + originPoint.y));
    for (idx=1; idx<[arrayPoints count]; idx++) {
        pnt = [[arrayPoints objectAtIndex:idx] CGPointValue];
        CGContextAddLineToPoint(context, (pnt.x + originPoint.x), ((-3/2)*pnt.y + originPoint.y));
        // NSLog(@"x=%g y=%g", (pnt.x + originPoint.x), ((-1)*pnt.y + originPoint.y) );
    };
    //CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP2.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y); // bezier curve
    CGContextStrokePath(context);
    
	UIGraphicsPopContext();

    return;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Drawing code
    CGRect baseRect = self.bounds;
    baseRect.origin.x += self.offOrigin.x;
    baseRect.origin.y += self.offOrigin.y;
    // NSLog(@"ox=%g oy=%g width=%g, height=%g", baseRect.origin.x, baseRect.origin.y, baseRect.size.width, baseRect.size.height);

    // BoundaryRect
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, baseRect);
    // CGContextFillPath(context);    
    CGContextStrokePath(context); 
     
    //[AxesDrawer drawAxesInRect:baseRect originAtPoint:self.midPoint scale:self.scale];
    CGPoint originPoint= CGPointMake(self.midPoint.x+self.offOrigin.x, self.midPoint.y + self.offOrigin.y );
    [AxesDrawer drawAxesInRect:baseRect originAtPoint:originPoint scale:self.scale];

    NSArray* pnts = [self.dataSource programForGraphView:self];
    [self drawGraph:pnts];
}

@end
