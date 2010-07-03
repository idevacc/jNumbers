//
//  CalcViewController.m
//  jNumbers
//
//  Created by Joost Schuur on 6/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

// TOOD: 
//       Resize for large numbers
//       Comma format large numbers
//       Stringing up operator (without hitting equal)
//       Swipe to backspace
//       Write operator type under number as reminder
//       Shaking to clear?
//       What happens if you hit equals when you first start up the app?
//       Stack of previous results. Swipe display to move between them. (use stack for double equal sign saving too).
//       Toggle size of display to include more history; eliminate memory buttons? (swipe up and down to scroll; button above 7 toggles modes or downwipe on display expands)
//       What happens if you hit equal without an operator active?
//       Swipe over section of memory buttons to reveal additional controls (PageControl? With arrow indicator on the left right).
//       Hitting clear twice 'forgets' last operation type
//       Don't truncate results after 6 decimal points
//       Highlight button (digit, operator) that you've just clicked, like Apple's calculator;
//       Memory icon in its own space so it won't get overwritten
//       Restore state from last time app ran
//       Try custom font (from http://www.dafont.com) via FontLabel (http://github.com/zynga/FontLabel)
//       Rotation handling
//       iOS 4.0 compliant (but 3.x backwards compatible)
//       Use images for buttons
//       Settings (edit colors, font) triggered by 'info circle' button
//       Parantheses 
//       Proper icon
//       Scientific forumulas
//       Page Controller to change between calc/unit converter/tip calculator/ Or just swipe across the screen?
//       Copy & Paste data between these apps

#import "CalcViewController.h"

@implementation CalcViewController

@synthesize displayLabel, memoryIndicator;
@synthesize operationType;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Attempt to restore data from UserDefaults if set (from potential pervious termination)
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSLog(@"Dictionary: %@", [defaults dictionaryRepresentation]);

	currentValue = [defaults doubleForKey:@"currentValue"];
	previousValue = [defaults doubleForKey:@"previousValue"];
	if (memoryValue = [defaults doubleForKey:@"memoryValue"])
		[memoryIndicator setHidden:NO];

	clearNextButtonPress = [defaults boolForKey:@"clearNextButtonPress"];
	decimalMode = [defaults boolForKey:@"decimaMode"];

	self.operationType = [defaults objectForKey:@"operationType"];

	if (!(displayString = [[NSMutableString alloc] initWithString:[defaults objectForKey:@"displayString"]]))
		displayString = [[NSMutableString alloc] initWithString:@"0"];
	[displayLabel setText:displayString];
	
	// Overide the font with something nicer
//	UIFont *lcdFont = [UIFont fontWithName:@"DBLCDTempBlack" size:48.0]; 
//	[displayLabel setFont:lcdFont];
//	[lcdFont release];
	
	[super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

// Save calculator related state
- (void)saveState {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:displayString forKey:@"displayString"];
	[defaults setObject:operationType forKey:@"operationType"];
	[defaults setDouble:currentValue forKey:@"currentValue"];
	[defaults setDouble:previousValue forKey:@"previousValue"];
	[defaults setDouble:memoryValue forKey:@"memoryValue"];
	[defaults setBool:clearNextButtonPress forKey:@"clearNextButtonPress"];
	[defaults setBool:decimalMode forKey:@"decimalMode"];

	[defaults synchronize];

	NSLog(@"after save Dictionary: %@", [defaults dictionaryRepresentation]);
}

// All of our cleanup that we need between numbers
- (void)resetCurrentValue {
	clearNextButtonPress = NO;
	decimalMode = NO;
	currentValue = 0.0;
	[displayString setString:@"0"];
}

// Lumping all the digits into a single method
- (IBAction)digitClicked:(id)sender {

	if (clearNextButtonPress)
		[self resetCurrentValue];

	UIButton *button = (UIButton *)sender;
	NSString *digit = button.titleLabel.text;

	// Make sure we're not continuing on the default zero
	if ([displayString isEqualToString:@"0"])
		[displayString setString:digit];
	else
		[displayString appendString:digit];

	[displayLabel setText:displayString];
	currentValue = [displayString doubleValue];
}

- (IBAction)delClicked {
	if (clearNextButtonPress)
		[self resetCurrentValue];
	
	// With one character on the screen, reset it to zero, otherwise, delete last character from the end
	if ([displayString length] > 1)
		[displayString deleteCharactersInRange:NSMakeRange([displayString length] - 1, 1)];
	else
		[displayString setString:@"0"];
	
	[displayLabel setText:displayString];
	currentValue = [displayString doubleValue];
}

- (IBAction)negateClicked {
	// Either prepend minus or remove the first instance. Don't do anything for zero.
	if (currentValue > 0) {
		[displayString	insertString:@"-" atIndex:0];
	} else if (currentValue < 0) {
		[displayString replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [displayString length])];
	} else
		return;	

	[displayLabel setText:displayString];	
	currentValue *= -1.0f;
}

- (IBAction)decimalClicked {
	if (clearNextButtonPress)
		[self resetCurrentValue];		
	
	// Only add a decimal point if we don't already have one
	if (!decimalMode) {
		[displayString appendString:@"."];
		[displayLabel setText:displayString];
		decimalMode = YES;
	}
}

- (IBAction)operationClicked:(id)sender {
	UIButton *button = (UIButton *)sender;
	[self setOperationType:button.titleLabel.text];
		
	previousValue = currentValue;
	[self resetCurrentValue];
	clearNextButtonPress = YES;
}

- (IBAction)memoryClicked:(id)sender {
	UIButton *button = (UIButton *)sender;
	NSString *memoryType = button.titleLabel.text;
	
	if ([memoryType isEqualToString:@"mc"]) {
		memoryValue = 0.0;
		[memoryIndicator setHidden:YES];
	} else if ([memoryType isEqualToString:@"m+"]) {
		memoryValue += currentValue;
		[memoryIndicator setHidden:NO];
	} else if ([memoryType isEqualToString:@"m-"]) {
		memoryValue = memoryValue - currentValue;
		[memoryIndicator setHidden:NO];
	} else if ([memoryType isEqualToString:@"mr"]) {
		// BUG: Hitting equal twice doesn't work after mr
		[displayString release];
		displayString = [[NSMutableString alloc] initWithFormat:@"%g", memoryValue];

		[displayLabel setText:displayString];
		currentValue = memoryValue;
		clearNextButtonPress = YES;
	}
}

- (IBAction)equalsClicked {	
	BOOL divideByZero = NO;
	double temp;

	// For repeat operation (hitting equal again) swap the 2 values, so we can run the same operation again
	if (clearNextButtonPress) {
		temp = previousValue;
		previousValue = currentValue;
		currentValue = temp;
	} else
		temp = currentValue;

	if ([operationType isEqualToString:@"+"]) {
		currentValue += previousValue;
	} else if ([operationType isEqualToString:@"-"]) {
		currentValue = previousValue - currentValue;
	} else if ([operationType isEqualToString:@"x"]) {
		currentValue *= previousValue;
	} else if ([operationType isEqualToString:@"/"]) {
		if (currentValue)
			currentValue = previousValue / currentValue;
		else {
			divideByZero = YES;
		}
	}
	
	if (divideByZero) {
		[displayLabel setText:@"divide by zero error"];
		currentValue = 0.0f;
	}
	else {
		[displayString release];
		displayString = [[NSMutableString alloc] initWithFormat:@"%g", currentValue];
		[displayLabel setText:displayString];
	}

	// Store this, so we can perform the operation again if the equal sign is hit again
	previousValue = temp;
	clearNextButtonPress = YES;
}

- (IBAction)clearClicked {
	[self resetCurrentValue];
	[displayLabel setText:displayString];
}

- (void)dealloc {
	[displayLabel release];
	[operationType release];
	[displayString release];
    [super dealloc];
}

@end
