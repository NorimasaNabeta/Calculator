//
//  GraphViewController.h
//  Calculator
//
//  Created by 式正 鍋田 on 12/07/13.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphViewDataSource>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong,nonatomic) NSMutableArray* program;
@property (weak, nonatomic) IBOutlet UILabel *display;

@end
