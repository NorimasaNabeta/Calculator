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

-(void) clearStack
{
    [self.operandStack removeAllObjects];
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
    } else if( [operation isEqualToString:@"sin"]){
        result = sin([self popOperand]);
    } else if( [operation isEqualToString:@"cos"]){
        result = cos([self popOperand]);
    } else if( [operation isEqualToString:@"sqrt"]){
        result = sqrt([self popOperand]);
    } else if( [operation isEqualToString:@"log"]){
        result = log([self popOperand]);
    } else if( [operation isEqualToString:@"π"]){
        result = M_PI;
    } else if( [operation isEqualToString:@"e"]){
        result = M_E;
    }    
    [self pushOperand:result];
    
    return result;
}
@end
