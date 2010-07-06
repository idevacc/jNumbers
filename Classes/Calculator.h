//
//  Calculator.h
//  jNumbers
//
//  Created by Joost Schuur on 7/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Calculator : NSObject {
}

+ (NSNumber *)addOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;
+ (NSNumber *)subtractOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;
+ (NSNumber *)multiplyOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;
+ (NSNumber *)divideOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;

+ (NSNumber *)powerOfOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;

@end
