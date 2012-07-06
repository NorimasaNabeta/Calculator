//
//  CalculatorBrain.m
//  Calculator
//
//  Created by 式正 鍋田 on 12/07/03.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack=_operandStack;
-(NSMutableArray*) operandStack
{
    // lazy instatiation
    if(! _operandStack){
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}
-(void) setOparandStack:(NSMutableArray*)anArray
{
    _operandStack=anArray;
}

-(void) pushOperand:(double)operand
{
    NSNumber *operandObject=[NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
    
}
-(double) popOperand
{
    NSNumber *operandObject=[self.operandStack lastObject];
    if(operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

-(double)performOperation:(NSString *)operation
{
    double result=0;
    
    // perform the opration here, store answer in result.
    if( [operation isEqualToString:@"+"]){
        result = [self popOperand] + [self popOperand];
    } else if( [operation isEqualToString:@"*"]){
        result = [self popOperand] * [self popOperand];
    } else if( [operation isEqualToString:@"-"]){
        double substrahend=[self popOperand];
        result = [self popOperand] - substrahend;
    } else if( [operation isEqualToString:@"/"]){
        double divisor=[self popOperand];
        if(divisor) result = [self popOperand] / divisor;
    }
    [self pushOperand:result];
    
    return result;
}
@end
