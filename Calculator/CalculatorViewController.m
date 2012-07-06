//
//  CalculatorViewController.m
//  Calculator
//
//  Created by 式正 鍋田 on 12/07/03.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userInTheMiddleOfEnteringANumber;
@property (nonatomic,strong) CalculatorBrain *brain;

@property (nonatomic) BOOL userPutFloatingPoint;
@end

@implementation CalculatorViewController
@synthesize history;
@synthesize display;
@synthesize userInTheMiddleOfEnteringANumber;
@synthesize brain=_brain;

@synthesize userPutFloatingPoint;

-(CalculatorBrain*) brain
{
    if(!_brain){
        _brain=[[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton*)sender {
    NSString* digit=[sender currentTitle];
    if(userInTheMiddleOfEnteringANumber){
        self.display.text=[self.display.text stringByAppendingString:digit];
    } else {
        self.display.text=digit;
        userInTheMiddleOfEnteringANumber=YES;
    }
}

// AssignmentTask2
- (IBAction)floatingPointPressed {
    if (! userPutFloatingPoint) {
        if(userInTheMiddleOfEnteringANumber){
            self.display.text=[self.display.text stringByAppendingString:@"."];
        } else {
            self.display.text=@"0.";
            userInTheMiddleOfEnteringANumber=YES;
        }
        userPutFloatingPoint=YES;
    }
}
- (IBAction)clearPressed {
    [self.brain clearStack];
    self.history.text=@"";
    self.display.text=@"0";
    userInTheMiddleOfEnteringANumber=NO;
    userPutFloatingPoint=NO;
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    NSString *work=[@" " stringByAppendingString:self.display.text];
    self.history.text = [self.history.text stringByAppendingString:work];
    
    userInTheMiddleOfEnteringANumber=NO;
    userPutFloatingPoint=NO;
}

- (IBAction)operationPressed:(id)sender
{
    // <option>+'p' --> π
    
    // ('6' 'Enter' '4' '-') would be the same as ('6' 'Enter' '4' 'Enter' '-')
    if(userInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation=[sender currentTitle];
    NSString *work=[@" " stringByAppendingString:operation];
    self.history.text = [self.history.text stringByAppendingString:work];

    double result= [self.brain performOperation:operation];
    self.display.text=[NSString stringWithFormat:@"%g", result];
}

- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
