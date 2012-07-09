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
        _variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:0], @"x",
                           [NSNumber numberWithDouble:0], @"a",
                           [NSNumber numberWithDouble:0], @"b", nil];
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


// Assignment2:Requiredtask#3e
//
- (IBAction)presetTestPressed:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"Test1"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:5], @"x",
                           [NSNumber numberWithDouble:1], @"a",
                           [NSNumber numberWithDouble:2], @"b", nil];

    }
    else if ([sender.titleLabel.text isEqualToString:@"Test2"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:10], @"x",
                               [NSNumber numberWithDouble:.6], @"a",
                               [NSNumber numberWithDouble:23], @"b", nil];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Test3"]) {
        self.variableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:9], @"x",
                               [NSNumber numberWithDouble:3], @"a",
                               [NSNumber numberWithDouble:7], @"b", nil];
    }
    if(userInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    double result=[[self.brain class] runProgram:self.brain.program usingVariableValues:self.variableValues];
    self.display.text=[NSString stringWithFormat:@"%g", result];
    self.history.text=[[self.brain class] descriptionOfProgram:self.brain.program];
    self.variables.text=@"";
    NSSet* sVar=[[self.brain class] variablesUsingInProgram:self.brain.program];
    if( sVar){
        for (NSString* key in sVar){
            double val = [[self.variableValues objectForKey:key] doubleValue];
            self.variables.text= [self.variables.text stringByAppendingFormat:@"%@=%g ", key, val];
        }
    }

}

// Assignment2:Requiredtask#4
// Hitting Undo when the user is in the middle of typing should take back the last digit or decimal point pressed until doing so would clear the display entirely at which point it shouldshow the result of running the brain's current program in the display( and now the user is clearly not in the middle of typing, so take care of that)
- (IBAction)undoPressed {
    if(userInTheMiddleOfEnteringANumber){
        self.display.text=[self.display.text substringToIndex:self.display.text.length-1];
    } else {
        id topOfStack = [self.brain popStack];
        if ([topOfStack isKindOfClass:[NSString class]]){
            self.display.text=@"";
        }
        double result=[[self.brain class] runProgram:self.brain.program usingVariableValues:self.variableValues];
        self.display.text=[NSString stringWithFormat:@"%g", result];
        self.history.text=[[self.brain class] descriptionOfProgram:self.brain.program];
    }
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
    self.variables.text=@"";
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
    self.history.text=[[self.brain class] descriptionOfProgram:self.brain.program];
    userInTheMiddleOfEnteringANumber=NO;
}

- (IBAction)operationPressed:(id)sender {
    if(userInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation=[sender currentTitle];
    double result= [self.brain performOperation:operation usingVariableValues:self.variableValues];
    self.history.text=[[self.brain class] descriptionOfProgram:self.brain.program];
    self.display.text=[NSString stringWithFormat:@"%g", result];
    self.variables.text=@"";
    NSSet* sVar=[[self.brain class] variablesUsingInProgram:self.brain.program];
    if( sVar){
        for (NSString* key in sVar){
            double val = [[self.variableValues objectForKey:key] doubleValue];
            self.variables.text= [self.variables.text stringByAppendingFormat:@"%@=%g ", key, val];
        }
    }
}
- (void)viewDidUnload {
    [self setDisplay:nil];
    [self setHistory:nil];
    [self setVariables:nil];
    [super viewDidUnload];
}
@end
