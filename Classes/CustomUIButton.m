//
//  CustomUIButton.m
//  jNumbers
//
//  Created by Joost Schuur on 6/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomUIButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomUIButton

// Trick to add rounded corners to buttons, which you can't set in Interface Builder
// via http://www.cimgf.com/2010/01/28/fun-with-uibuttons-and-core-animation-layers/
- (id)initWithCoder:(NSCoder *)coder {
    if(self = [super initWithCoder:coder]) {
		CALayer *layer = [self layer];
		
        layer.cornerRadius = 10.0f;
		layer.masksToBounds = YES;
    }
    return self;
}

@end
