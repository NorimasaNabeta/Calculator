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
@property (nonatomic,strong) NSDictionary* variableValues;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize history;
@synthesize variables;
@synthesize userInTheMiddleOfEnteringANumber;
@synthesize brain=_brain;
@synthesize variableValues=_variableValues;


-(NSDictionary*) variableValues
{
    if(! _variableValues){
        _variableValues = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithDouble:5], @"x",
                           [NSNumber numberWithDouble:1], @"a",
                           [NSNumber numberWithDouble:2], @"b", nil];
    }
    return _variableValues;
}

-(CalculatorBrain*) brain
{
    if(!_brain){
        _brain=[[CalculatorBrain alloc] init];
    }
    return _brain;
}

// Assignment2:Requiredtask#3b
//
- (IBAction)variablePressed:(id)sender {
    if(userInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation=[sender currentTitle];
    double result= [self.brain performOperation:operation usingVariableValues:self.variableValues];
    self.history.text=[self.brain descriptionInStack];
    self.display.text=[NSString stringWithFormat:@"%g", result];
}

// Assignment2:Requiredtask#3e
//
- (IBAction)presetTestPressed:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"Test1"]) {
        // a) 3 E 5 E 6 E 7 + * -
        [self.brain clearStack];
        [self.brain pushOperand:[@"3" doubleValue]];
        [self.brain pushOperand:[@"5" doubleValue]];
        [self.brain pushOperand:[@"6" doubleValue]];
        [self.brain pushOperand:[@"7" doubleValue]];
        self.display.text=[NSString stringWithFormat:@"%g", [self.brain performOperation:@"+" usingVariableValues:self.variableValues]];
        self.display.text=[NSString stringWithFormat:@"%g", [self.brain performOperation:@"*" usingVariableValues:self.variableValues]];
        self.display.text=[NSString stringWithFormat:@"%g", [self.brain performOperation:@"-" usingVariableValues:self.variableValues]];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Test2"]) {
        // b) 3 E 5 + sqrt
        [self.brain clearStack];
        [self.brain pushOperand:[@"3" doubleValue]];
        [self.brain pushOperand:[@"5" doubleValue]];
        self.display.text=[NSString stringWithFormat:@"%g", [self.brain performOperation:@"+" usingVariableValues:self.variableValues]];
        self.display.text=[NSString stringWithFormat:@"%g", [self.brain performOperation:@"sqrt" usingVariableValues:self.variableValues]];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Test3"]) {
        // c) 3 sqrt sqrt
        [self.brain clearStack];
        [self.brain pushOperand:[@"3" doubleValue]];
        self.display.text=[NSString stringWithFormat:@"%g", [self.brain performOperation:@"sqrt" usingVariableValues:self.variableValues]];
        self.display.text=[NSString stringWithFormat:@"%g", [self.brain performOperation:@"sqrt" usingVariableValues:self.variableValues]];
    }
}

// Assignment2:Requiredtask#4
//
- (IBAction)undoPressed {
}
- (IBAction)floatingPointPressed {
    NSRange range=[self.display.text rangeOfString:@"."];
    if(range.location == NSNotFound){
        self.display.text=[self.display.text stringByAppendingString:@"."];
        userInTheMiddleOfEnteringANumber=YES;
    }
}
- (IBAction)clearPressed {
    [self.brain clearStack];
    self.history.text=@"";
    self.display.text=@"0";
    userInTheMiddleOfEnteringANumber=NO;
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
- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.history.text = [self.history.text stringByAppendingString:[@" " stringByAppendingString:self.display.text]];
    
    userInTheMiddleOfEnteringANumber=NO;
}

- (IBAction)operationPressed:(id)sender {
    
    // ('6' 'Enter' '4' '-') would be the same as ('6' 'Enter' '4' 'Enter' '-')
    if(userInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation=[sender currentTitle];
    double result= [self.brain performOperation:operation usingVariableValues:self.variableValues];
    //self.history.text = [self.brain descriptionOfProgram:operation];
//    self.history.text = [self.history.text stringByAppendingString:[@" " stringByAppendingString:operation]];
    self.history.text=[self.brain descriptionInStack];
    self.display.text=[NSString stringWithFormat:@"%g", result];
    self.variables.text = [self.brain descriptionVariables];
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [self setVariables:nil];
    [super viewDidUnload];
}
@end
