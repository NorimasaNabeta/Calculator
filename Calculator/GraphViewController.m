//
//  GraphViewController.m
//  Calculator
//
//  Created by 式正 鍋田 on 12/07/13.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController ()

@end

@implementation GraphViewController
@synthesize graphView=_graphView;
@synthesize program=_program;
@synthesize display=_display;

-(void) setProgram:(NSMutableArray *)program
{
    _program=program;
    [self.graphView setNeedsDisplay];
}

-(void) setGraphView:(GraphView *)graphView
{
    _graphView=graphView;
    // enable pinch gestures for scaling
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];

    // enable pan gestures for moving graph
    //[self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]]; 
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)];
    // put a threshold value 
    [self.graphView addGestureRecognizer:panRecognizer];
    
    // enable triple-tap gestures for moving origin
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired=3;
    [self.graphView addGestureRecognizer:tapRecognizer];
    
    //
    
    // GraphViewDataSource
    self.graphView.dataSource=self;
}

// DataSource
- (void)programForGraphView:(GraphView *)sender
{
    NSMutableArray *pnts = [[NSMutableArray alloc] initWithArray:nil];
    double valx=0.0;
    double valy=0.0;
    
    for (valx=sender.rectGraph.origin.x-sender.midPoint.x; 
         valx<(sender.rectGraph.origin.x-sender.midPoint.x+sender.rectGraph.size.width); 
         valx++) {
        valy=[CalculatorBrain runProgram:self.program 
                     usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:valx], @"x", nil ]]; 
        [pnts addObject:[NSValue valueWithCGPoint:CGPointMake(valx,valy)]];
    }
    [sender drawGraph:[pnts copy]];
    
    return;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // RequiredTask#4
    self.display.text=[CalculatorBrain descriptionOfProgram:self.program];
    // NSLog(@"-->%@", self.display.text);
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setDisplay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
