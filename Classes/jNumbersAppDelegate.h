//
//  CalcAppDelegate.h
//  Calc
//
//  Created by Joost Schuur on 6/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVersion @"0.01"

@class CalcViewController;

@interface jNumbersAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CalcViewController *cAlcController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CalcViewController *calcController;

@end

