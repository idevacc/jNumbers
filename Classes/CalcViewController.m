//
//  CalcViewController.m
//  jNumbers
//
//  Created by Joost Schuur on 6/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CalcViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation CalcViewController

@synthesize displayLabel, versionLabel, memoryIndicator, operationIndicator;
@synthesize functionButtonScrollView;
@synthesize operationType, displayString;

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
	// Set version string field
	NSString *versionString = [NSString stringWithFormat:@"v%@ (%@)",
							   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
							   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
	[versionLabel setText:versionString];

	functionButtonsPosition = 0;
	
	// Initialize array of all of our supported operation types
	operationMethods = [[NSArray arrayWithObjects:@"add", @"subtract", @"multiply", @"divide",
												  @"squareRoot", @"powerOf", @"powerOfTwo", @"oneDividedBy", 
												  nil] retain];	
	
	// Intialize button click sound data
	clickSounds = [[NSDictionary dictionaryWithObjectsAndKeys:@"beep-28", @"digit", @"beep-29", @"operation",
	                                                          @"button-16", @"del", @"beep-21", @"decimal",
	                                                          @"button-50", @"equals", @"button-20", @"memory",
	                                                          @"button-43", @"negate", @"beep-26", @"clear",
	                                                          @"beep-10", @"error",
	                                                          nil] retain];
	// FIXME: Slight lockup the first time a button is clicked before audio is played. Try System Sound Services
	
	// Attempt to restore data from UserDefaults if set (from potential pervious termination)
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	// TOOD: Restore this from saved state, but truncate at 100
	valueHistory = [[NSMutableArray alloc] init];
	
	currentValue = [defaults doubleForKey:@"currentValue"];
	lastEnteredValue = [defaults doubleForKey:@"lastEnteredValue"];
	if (memoryValue = [defaults doubleForKey:@"memoryValue"])
		[memoryIndicator setHidden:NO];

	clearNextButtonPress = [defaults boolForKey:@"clearNextButtonPress"];
	decimalMode = [defaults boolForKey:@"decimaMode"];

	// TODO: Reenable button clicks
	//staySilent = [defaults boolForKey:@"staySilent"];
	staySilent = 1;

	[self setOperationType:[defaults objectForKey:@"operationType"]];
	[operationIndicator setText:operationType];

	// Set a default value, for first time launch of the app
	[defaults registerDefaults:[NSDictionary dictionaryWithObject:@"0" forKey:@"displayString"]];
	[self setDisplayString:[NSMutableString stringWithString:[defaults objectForKey:@"displayString"]]];
	[displayLabel setText:displayString];

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
	[defaults setDouble:lastEnteredValue forKey:@"lastEnteredValue"];
	[defaults setDouble:memoryValue forKey:@"memoryValue"];
	[defaults setBool:clearNextButtonPress forKey:@"clearNextButtonPress"];
	[defaults setBool:decimalMode forKey:@"decimalMode"];

	[defaults synchronize];
}

// All of our cleanup that we need between numbers
- (void)resetData {
	clearNextButtonPress = NO;
	decimalMode = NO;
	currentValue = 0.0;
	[displayString setString:@"0"];
}

- (void)playSound:(NSString *)soundType {
	if (staySilent)
		return;

    NSString *path = [[NSBundle mainBundle] pathForResource:[clickSounds objectForKey:soundType] 
													 ofType:@"mp3"];
    NSURL *file = [[NSURL alloc] initFileURLWithPath:path];
	
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
    [file release];
	
    [player prepareToPlay];
    [player setDelegate:self];
	[player play];
	// FIXME: track down 'AddRunningClient starting device on non-zero client count' error.
}

- (IBAction)pageFunctionButtons {
	// The 'f' key scrolls through multiple pages of red buttons
	if (++functionButtonsPosition == 3)
		functionButtonsPosition = 0;
	
	[functionButtonScrollView setContentOffset:CGPointMake(functionButtonsPosition * 320, 0) animated:YES];
}

// Lumping all the digits into a single method
- (IBAction)digitClicked:(id)sender {
	[self playSound:@"digit"];
	
	if (clearNextButtonPress)
		[self resetData];

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
	[self playSound:@"del"];

	if (clearNextButtonPress)
		[self resetData];
	
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
		[displayString replaceOccurrencesOfString:@"-" withString:@""
										  options:NSLiteralSearch 
											range:NSMakeRange(0, [displayString length])];
	} else
		return;
	
	[self playSound:@"negate"];
	[displayLabel setText:displayString];	
	currentValue *= -1.0f;
}

- (IBAction)decimalClicked {
	[self playSound:@"decimal"];

	if (clearNextButtonPress)
		[self resetData];		
	
	// Only add a decimal point if we don't already have one
	if (!decimalMode) {
		[displayString appendString:@"."];
		[displayLabel setText:displayString];
		decimalMode = YES;
	}
}

- (IBAction)operationClicked:(id)sender {
	[self playSound:@"operation"];

	// Set the operation icon and remember the operation type
	UIButton *button = (UIButton *)sender;
	[self setOperationType:button.titleLabel.text];
	[operationIndicator setText:operationType]; 
	currentOperation = button.tag;

	// If the last value hasn't been added to the history yet, do so and remember it
	// FIXME: Doesn't work for memory 
	if (!clearNextButtonPress)
		[valueHistory addObject:[NSNumber numberWithDouble:currentValue]];

	clearNextButtonPress = YES;
}


- (void)runMathOperation {

}

- (IBAction)equalsClicked {	
	double operand1, operand2;
	
	// Do nothing if there's no current, active operation	
	if (!currentOperation)
		return;
	
	// Make sure we have this tag ID mapped to a math operation...
	if (currentOperation > [operationMethods count]) {
		NSLog(@"No math operation defined for tag %d", currentOperation);
		return;
	}

	// ...and that a method exists for the math operation of that name
	NSString *operationMethod = [NSString stringWithFormat:@"%@Operand:withOperand:",
								 [operationMethods objectAtIndex:(currentOperation - 1)]];
	SEL operationSelector = NSSelectorFromString(operationMethod);
	if (![self respondsToSelector:operationSelector]) {
		NSLog(@"Math operation %@ (tag %d) has no method defined", operationMethod, currentOperation);
		return;
	}	
	
	// Define our operands. For repeat operations (hitting equal again) use the last manually entered value.
	operand1 = [[valueHistory lastObject] doubleValue];
	if (clearNextButtonPress) {
		operand2 = lastEnteredValue;
	} else {
		operand2 = currentValue;
		[valueHistory addObject:[NSNumber numberWithDouble:currentValue]];
	}
	lastEnteredValue = operand2;	

	// Dynamically route to the correct operations method
	int error = 0;
	@try {
		currentValue = [[self performSelector:operationSelector 
								   withObject:[NSNumber numberWithDouble:operand1] 
								   withObject:[NSNumber numberWithDouble:operand2]] 
						doubleValue];
	}
	@catch (NSException *exception) {
		[self playSound:@"error"];
		error = 1;
		
		[displayLabel setText:[exception reason]];
	}
	
	if (!error) {
		[self playSound:@"equals"];

		// hitting equal twice only saves the last result in a chain
		if(clearNextButtonPress)
			[valueHistory removeLastObject];
		[valueHistory addObject:[NSNumber numberWithDouble:currentValue]];
		
		[self setDisplayString:[NSMutableString stringWithFormat:@"%g", currentValue]];
		[displayLabel setText:displayString];
	}

	clearNextButtonPress = YES;
}

- (IBAction)clearClicked {
	[self playSound:@"clear"];

	// Hitting clear twice or after the result of an operation cancels out saved operation type
	if ([displayString isEqualToString:@"0"] || clearNextButtonPress) {
		[self setOperationType:@""];
		currentOperation = 0;
		[operationIndicator setText:@""];
	}
	
	[self resetData];
	[displayLabel setText:displayString];
}

- (IBAction)memoryClicked:(id)sender {
	[self playSound:@"memory"];
	
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
		// FIXME: Hitting equal twice doesn't work after mr
		[self setDisplayString:[NSMutableString stringWithFormat:@"%g", memoryValue]];
		
		[displayLabel setText:displayString];
		currentValue = memoryValue;
		clearNextButtonPress = YES;
	}
}

- (IBAction)showSettings {
	
}

- (IBAction)showAbout {
	
}

// One function per operation type
// TODO: return the result (and take 2 operator from stack?) 
- (NSNumber *)addOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	return [NSNumber numberWithDouble:([operand1 doubleValue] + [operand2 doubleValue])];
}

- (NSNumber *)subtractOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	return [NSNumber numberWithDouble:([operand1 doubleValue] - [operand2 doubleValue])];
}

- (NSNumber *)multiplyOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	return [NSNumber numberWithDouble:([operand1 doubleValue] * [operand2 doubleValue])];
}

- (NSNumber *)divideByOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	if (operand2)
		return [NSNumber numberWithDouble:([operand1 doubleValue] / [operand2 doubleValue])];
	else {
		NSException *exception = [NSException exceptionWithName:@"DivideByZero" reason:@"divide by zero" userInfo:nil];
		[exception raise];
		return 0;
	}
}

- (IBAction)squareRootOperation {
	
}

- (NSNumber *)powerOfOperand:(NSNumber *)operand1 withOperand:(NSNumber *)operand2 {
	return [NSNumber numberWithDouble:0.0f];
}

- (IBAction)powerOfTwoOperation {
	
}

- (IBAction)oneDividedByOperation {
	
}


- (void)dealloc {
	[displayLabel release];
	[versionLabel release];
	[memoryIndicator release];
	[operationIndicator release];
	[functionButtonScrollView release];
	
	[operationType release];
	[displayString release];
	[valueHistory release];
	[operationMethods release];
	[clickSounds release];

	[super dealloc];
}

@end
