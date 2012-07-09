//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}


// RequiredTask#2 
// a. It should display all single-operand operations using "function" notation.
//    e.g. '10' 'sqrt' --> "sqrt(10)"
// b. It should display all single-operand operations using "infix" notation if appropriate,
//    else function notation.
//    e.g. '3' 'Enter' '5' '+' --> "3 + 5"
// c. Any no-operand operations, like π, should appear unadorned.
// d. variables(RequiredTask#1) shuld also apear unadorned.
//
// check:
// 3 E 5 E 6 E 7 + * - --> "3 - (5*(6+7))"
// 3 E 5 + sqrt --> "sqrt(3+5)"
// 3 sqrt sqrt --> "sqrt(sqrt(3))"
// 3 E 5 sqrt + --> "3 + sqrt(5)" 
//
// In case of no operand in the stack, operation command should be error?
//
+ (NSString *) descriptionOfTopOfStack:(NSMutableArray *)stack 
                        callFromTop:(BOOL) top
{
    NSSet *nonOps = [[NSSet alloc] initWithObjects:@"π", @"e", nil]; 
    NSSet *unaryOps = [[NSSet alloc] initWithObjects:@"sqrt", @"sin", @"cos", @"log", nil]; 
    NSSet *binaryOps = [[NSSet alloc] initWithObjects:@"+", @"-", @"/", @"*", nil]; 
    NSString *result = @"";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack stringValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if([binaryOps containsObject:operation]){
            NSString *op1 = [self descriptionOfTopOfStack:stack callFromTop:NO];
            NSString *op2 = [self descriptionOfTopOfStack:stack callFromTop:NO];
            if(top){
                result = [result stringByAppendingFormat:@"%@ %@ %@", op2,operation,op1];
            } else {
                result = [result stringByAppendingFormat:@"(%@ %@ %@)", op2,operation,op1];
            }
        }
        else if([unaryOps containsObject:operation]){
            result = [result stringByAppendingFormat:@" %@(%@) ", operation, [self descriptionOfTopOfStack:stack callFromTop:YES]];
        }
        else if([nonOps containsObject:operation]){
            result = operation;
        }            
        else {
            result = [result stringByAppendingFormat:@"%@", operation];
        }
    }
    
    return result;
}

//
// descriptionOfProgram: does not take a variable values dictionary as an argument.
//
+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack callFromTop:YES];
}

-(void) clearStack
{
    [self.programStack removeAllObjects];
}

-(id) popStack
{
    id topOfStack = [self.programStack lastObject];
    if (topOfStack) [self.programStack removeLastObject];
   
    return topOfStack;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:nil];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack 
                usingVariableValues:(NSDictionary*)variableValues
{
    double result = 0;

    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] +
                     [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] *
                     [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
            if (divisor) result = [self popOperandOffProgramStack:stack usingVariableValues:variableValues] / divisor;
        }
        else if( [operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        } else if( [operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        } else if( [operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        } else if( [operation isEqualToString:@"log"]){
            result = log([self popOperandOffProgramStack:stack usingVariableValues:variableValues]);
        } else if( [operation isEqualToString:@"π"]){
            result = M_PI;
        } else if( [operation isEqualToString:@"e"]){
            result = M_E;
        }    
        else if( variableValues ){
            NSEnumerator *enumDict = [variableValues keyEnumerator];
            NSString *key;
            while (key=[enumDict nextObject]) {
                if ([operation isEqualToString:key]) {
                    result=[[variableValues objectForKey:key] doubleValue];
                    break;
                }
            }
        }
    }

    return result;
}

// new version of runProgram which accepts variable's dictionary.
// RequiredTask#1a
// RequiredTask#3c
+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary*)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack usingVariableValues:variableValues];
}

// RequiredTask#1b
// get all the name of the variables used in a given program.
// If the program has no variables return nil.
// 
+ (NSSet*) variablesUsingInProgram:(id)program
{
    NSSet *opSet = [[NSSet alloc] initWithObjects:@"+", @"-", @"/", @"*", @"e", @"π", @"sqrt", @"sin", @"cos", @"log", nil]; 
    NSSet *result;
    NSMutableArray *stack;
    NSMutableSet *chkSet=[[NSMutableSet alloc] initWithArray:nil];
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    for (id work in stack) {
        if ([work isKindOfClass:[NSString class]]) {
            if ((! [opSet containsObject:work]) && (! [chkSet containsObject:work])){
                    [chkSet addObject:work];
            }
        }
    }
    if( [chkSet count] > 0){
        result = [[NSSet alloc] initWithSet:chkSet];
    }
    
    return result;
}

@end
