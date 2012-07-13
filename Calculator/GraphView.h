//
//  GraphView.h
//  Calculator
//
//  Created by 式正 鍋田 on 12/07/13.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;

//
// http://stackoverflow.com/questions/2971842/cgrect-var-as-property-value
// CGRect is a struct, not an NSObject.
//
@property (nonatomic,assign) CGPoint offOrigin;
@property (nonatomic,assign) CGPoint midPoint;

// pinch for scaling
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
// pan for moving graph
- (void)pan:(UIPanGestureRecognizer *)gesture;
// tap(Triple-tap) for moving the origin of the graph
- (void)pan:(UIPanGestureRecognizer *)gesture;


@end
