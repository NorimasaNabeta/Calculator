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
@synthesize midPoint=_midPoint;
@synthesize rectGraph=_rectGraph;
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
        self.midPoint=CGPointMake(tapPoint.x+self.rectGraph.origin.x, tapPoint.y + self.rectGraph.origin.y );
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
        self.rectGraph= CGRectMake((self.rectGraph.origin.x+translation.x/2), (self.rectGraph.origin.y+translation.y/2),
                                     self.rectGraph.size.width, self.rectGraph.size.height);
        self.midPoint=CGPointMake(self.midPoint.x+translation.x/2, self.midPoint.y+translation.y/2);
        [self setNeedsDisplay];
        
        // reset
        [gesture setTranslation:CGPointZero inView:self];
    }
}


- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
    // self.offOrigin = CGPointZero;
    self.midPoint = CGPointMake((self.bounds.origin.x + self.bounds.size.width/2),
                                (self.bounds.origin.y + self.bounds.size.height/2));
    self.rectGraph = self.bounds;
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

    UIGraphicsPushContext(context);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextBeginPath(context);

    //NSLog(@"scale=%g", self.scale);
    BOOL first=TRUE;
    for (NSUInteger idx=0; idx<[arrayPoints count]; idx++) {
        CGPoint pnt = [[arrayPoints objectAtIndex:idx] CGPointValue];
        CGPoint chk = CGPointMake(pnt.x*self.scale+ self.midPoint.x, (-3/2)* pnt.y*self.scale+ self.midPoint.y);
        if(CGRectContainsPoint(self.rectGraph, chk)){
            if(first){
                CGContextMoveToPoint(context, chk.x, chk.y);
                first=FALSE;
            }
            else {
                CGContextAddLineToPoint(context, chk.x, chk.y);
            }
            //NSLog(@"scale=%g x=%g y=%g", self.scale, pnt.x,pnt.y);
        }
    };
    //CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP2.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y); // bezier curve
    CGContextStrokePath(context);
    
	UIGraphicsPopContext();

    return;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code

    // (DEBUG) BoundaryRect
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, self.rectGraph);
    CGContextStrokePath(context); 
     
    // AXES
    [AxesDrawer drawAxesInRect:self.rectGraph originAtPoint:self.midPoint scale:self.scale];

    // GRAPH
    [self.dataSource programForGraphView:self];
}

@end
