//
//  CalcViewController.h
//  Calc
//
//  Created by Joost Schuur on 6/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalcViewController : UIViewController {
	UILabel *displayLabel;
	// TODO: label is hiding under other label?
	UILabel *memoryIndicator;
	UIButton *activeButton;
	
	double currentValue, previousValue, memoryValue;
	NSString *operationType, *errorText;
	NSMutableString *displayString;
	BOOL clearNextButtonPress, decimalMode;
}

@property (nonatomic, retain) IBOutlet UILabel *displayLabel;
@property (nonatomic, retain) IBOutlet UILabel *memoryIndicator;
@property (nonatomic, retain) NSString *operationType;
@property (nonatomic, retain) NSString *errorText;

// Helper functions
- (void)updateDisplay;
- (void)appendToDisplayString:(NSString *)character;
- (void)resetCurrentValue;

// Button click methods
- (IBAction)digitClicked:(id)sender;
- (IBAction)operationClicked:(id)sender;
- (IBAction)memoryClicked:(id)sender;
- (IBAction)clearClicked;
- (IBAction)equalsClicked;
- (IBAction)decimalClicked;
- (IBAction)negateClicked;
- (IBAction)delClicked;

@end

