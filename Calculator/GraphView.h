//
//  GraphView.h
//  Calculator
//
//  Created by 式正 鍋田 on 12/07/13.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GraphView;  // forward declaration for use in @protocol
@protocol GraphViewDataSource
- (void)programForGraphView:(GraphView *)sender;
@end

// RequiredTask#6 specify the protocol, it means dataSource?


@interface GraphView : UIView

@property (nonatomic) CGFloat scale;

//
// http://stackoverflow.com/questions/2971842/cgrect-var-as-property-value
// CGRect is a struct, not an NSObject.
//
@property (nonatomic,assign) CGPoint midPoint;
@property (nonatomic,assign) CGRect rectGraph;

// pinch for scaling
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
// pan for moving graph
- (void)pan:(UIPanGestureRecognizer *)gesture;
// tap(Triple-tap) for moving the origin of the graph
- (void)pan:(UIPanGestureRecognizer *)gesture;

// set this property to whatever object will provide this View's data
// usually a Controller using a GraphView in its View
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

- (void) drawGraph: (NSArray*) arrayPoints;


@end
