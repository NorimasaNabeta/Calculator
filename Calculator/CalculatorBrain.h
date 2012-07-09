//
//  CalculatorBrain.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)op usingVariableValues:(NSDictionary*)variableValues;
- (void)clearStack;

@property (nonatomic, readonly) id program;
@property (nonatomic, strong) NSString *descriptionInStack;
@property (nonatomic, strong) NSString *descriptionVariables;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary*)variableValues;
+ (NSSet*) variablesUsingInProgram:(id)program;

@end
