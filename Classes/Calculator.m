//
//  Calculator.m
//  jNumbers
//
//  Created by Joost Schuur on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Calculator.h"


@implementation Calculator

// One function per operation type
// TODO: return the result (and take 2 operator from stack?) 
+ (NSNumber *)addOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	return [NSNumber numberWithDouble:([operand1 doubleValue] + [operand2 doubleValue])];
}

+ (NSNumber *)subtractOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	return [NSNumber numberWithDouble:([operand1 doubleValue] - [operand2 doubleValue])];
}

+ (NSNumber *)multiplyOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	return [NSNumber numberWithDouble:([operand1 doubleValue] * [operand2 doubleValue])];
}

+ (NSNumber *)divideOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	if (operand2)
		return [NSNumber numberWithDouble:([operand1 doubleValue] / [operand2 doubleValue])];
	else {
		// FIXME: Doesn't raise exception in CalcViewController
		NSException *exception = [NSException exceptionWithName:@"DivideByZero" reason:@"divide by zero" userInfo:nil];
		[exception raise];
		return 0;
	}
}

+ (NSNumber *)powerOfOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	return [NSNumber numberWithDouble:0.0f];
}


@end
