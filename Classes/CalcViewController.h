//
//  CalcViewController.h
//  Calc
//
//  Created by Joost Schuur on 6/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CalcViewController : UIViewController <AVAudioPlayerDelegate> {
	UILabel *displayLabel;
	UILabel *memoryIndicator;
	UILabel *operationIndicator;
	UILabel *versionLabel;
	UIScrollView *functionButtonScrollView;
	
	BOOL clearNextButtonPress;			// next time something is entered, reset display
	BOOL decimalMode;					// before or after decimal point?
	BOOL staySilent;					// don't play button click sounds

	double currentValue;				// number visible on the display
	double lastEnteredValue;			// save previous one for repeat operations
	double memoryValue;					// number saved in memory 
	int functionButtonsPosition;		// what set of red buttons we're displaying
	NSMutableArray *valueHistory;		// stack of previous entered numbers and results
	int currentOperation;				// maps to current math operation	
	// TODO: Put this in saveState and reset where needed

	NSMutableString *displayString;
	NSString *operationType;
	NSDictionary *clickSounds;			// maps sound types to sound file name
	NSArray *operationMethods;			// maps button tag to math operation
}

@property (nonatomic, retain) IBOutlet UILabel *displayLabel;
@property (nonatomic, retain) IBOutlet UILabel *memoryIndicator;
@property (nonatomic, retain) IBOutlet UILabel *operationIndicator;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;
@property (nonatomic, retain) IBOutlet UIScrollView *functionButtonScrollView;
@property (nonatomic, retain) NSString *operationType;
@property (nonatomic, retain) NSString *displayString;

// Helper functions
- (void)saveState;
- (void)resetData;
- (void)playSound:(NSString *)soundType;

// Button click methods
- (IBAction)pageFunctionButtons;
- (IBAction)digitClicked:(id)sender;
- (IBAction)operationClicked:(id)sender;
- (IBAction)memoryClicked:(id)sender;
- (IBAction)clearClicked;
- (IBAction)equalsClicked;
- (IBAction)decimalClicked;
- (IBAction)negateClicked;
- (IBAction)delClicked;

- (IBAction)showSettings;
- (IBAction)showAbout;
	

// Math operations
- (NSNumber *)addOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;
- (NSNumber *)subtractOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;
- (NSNumber *)multiplyOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;
- (NSNumber *)divideByOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;
- (NSNumber *)powerOfOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2;

- (IBAction)squareRootOperation;
- (IBAction)powerOfTwoOperation;
- (IBAction)oneDividedByOperation;
	
@end

