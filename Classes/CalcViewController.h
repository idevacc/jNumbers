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
	
	double currentValue, previousValue, memoryValue;
	NSString *operationType;
	NSMutableString *displayString;
	BOOL clearNextButtonPress, decimalMode, staySilent;
	NSDictionary *clickSounds;
}

@property (nonatomic, retain) IBOutlet UILabel *displayLabel;
@property (nonatomic, retain) IBOutlet UILabel *memoryIndicator;
@property (nonatomic, retain) IBOutlet UILabel *operationIndicator;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;
@property (nonatomic, retain) NSString *operationType;
@property (nonatomic, retain) NSString *displayString;

// Helper functions
- (void)saveState;
- (void)resetData;
- (void)playSound:(NSString *)soundType;

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

