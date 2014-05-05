//
//  IntervalTimerViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/5/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "IntervalTimerViewController.h"
#import "SWRevealViewController.h"
#import "RunIntervalTrainerViewController.h"

@interface IntervalTimerViewController ()

@end

@implementation IntervalTimerViewController

UIToolbar *pickerToolbar;
NSString *seconds;
NSString *minutes;
UITextField *selectedTextField;
bool isSetWarmup, isSetLowInterval, isSetHighInterval, isSetCooldown, isSetRepetition;
CGRect activeTextFieldRect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Slide out menu intialization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Initialize time array with times value to pick from
    self.minArray = [[NSMutableArray alloc] init];
    self.secArray = [[NSMutableArray alloc] init];
    
    NSArray *minSingleDigits = [[NSArray alloc] initWithObjects:@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07"
                                , @"08", @"09", nil];
    NSArray *secSingleDigits = [[NSArray alloc] initWithObjects:@"00", @"05", nil];
    
    [self.minArray addObjectsFromArray:minSingleDigits];
    [self.secArray addObjectsFromArray:secSingleDigits];
    
    for (int j = 10; j < 60; j++) {
        [self.minArray addObject:[NSString stringWithFormat:@"%d", j]];
    }
    
    for (int i = 2; i < 12; i++) {
        [self.secArray addObject:[NSString stringWithFormat:@"%d", i*5]];
    }
    
    // Time pick initialization
    //    self.timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 500, self.timePicker.frame.size.width, self.timePicker.frame.size.height)];
    self.timePicker = [[UIPickerView alloc] init];
    self.timePicker.showsSelectionIndicator = YES;
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    self.timePicker.backgroundColor = [UIColor whiteColor];
    
    self.warmupDuration.inputView = self.timePicker;
    self.lowIntervalDuration.inputView = self.timePicker;
    self.highIntervalDuration.inputView = self.timePicker;
    self.cooldownDuration.inputView = self.timePicker;
    
    // Done bar button
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
    
    pickerToolbar.items = [NSArray arrayWithObjects:space, done, nil];
    self.warmupDuration.inputAccessoryView = pickerToolbar;
    self.lowIntervalDuration.inputAccessoryView = pickerToolbar;
    self.highIntervalDuration.inputAccessoryView = pickerToolbar;
    self.cooldownDuration.inputAccessoryView = pickerToolbar;
    
    // Change the textfields' border color
    [self changeTextFieldBorderColor];
    
    // Set the textfields' text to default value saved
    [self getDefaultTextFieldData];
     
    // Set the textfield values as set
    isSetWarmup = isSetLowInterval = isSetHighInterval = isSetCooldown = isSetRepetition = YES;
    
    [self.startButton setTitleColor:themeNavBar6 forState:UIControlStateNormal];
    
    // Move view up when showing keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // Tap gesture: hide keyboard when taping on view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardOnTap:)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];

    self.warmupDuration.delegate = self;
    self.lowIntervalDuration.delegate = self;
    self.highIntervalDuration.delegate = self;
    self.cooldownDuration.delegate = self;
    self.repetitions.delegate = self;
}

// called everytime we enter the view
- (void)viewDidAppear:(BOOL)animated
{
    if (isSetWarmup && isSetLowInterval && isSetHighInterval && isSetCooldown && isSetRepetition) {
        [self.startButton setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Change all the textfields' border color */
-(void)changeTextFieldBorderColor
{    
    for (UITextField *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [[subView layer] setBorderColor:[themeGrey2 CGColor]];
            subView.layer.borderWidth= 1.0f;
            subView.layer.cornerRadius = 8.0f;
            subView.textColor = [UIColor blackColor];
        }
    }
}

/* Called when a text field is active */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Save the active textfield's coordinates
    activeTextFieldRect = textField.frame;
}

- (IBAction)hideKeyboardOnTap:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    [self.scrollView endEditing:YES];
}

/* Show keyboard: called when UIKeyboardDidShowNotification is sent */
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Get the height of the keyboard
    NSDictionary *info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Get scoll view frame size
    CGRect aRect = self.scrollView.frame;

    aRect.size.height -= keyboardSize.height + self.navigationController.navigationBar.frame.origin.y + 15;
    
    UIEdgeInsets contectInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contectInsets;
    self.scrollView.scrollIndicatorInsets = contectInsets;
    
    // Only scroll if text field is hidden by keyboard
    // Check is textfield's point is within aRect (area not hidden by keyboard)
    if (!CGRectContainsPoint(aRect, activeTextFieldRect.origin)) {
        NSLog(@"need to scroll");
        CGPoint scrollPoint = CGPointMake(0.0, activeTextFieldRect.origin.y - keyboardSize.height);
        [self.scrollView setContentOffset:scrollPoint];
    }
    
}

/* Hide keyboard: called when UIKeyboardWillHideNotification is sent */
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

/* UIPickerViewDataSource */

// Time picker Done button
-(void)pickerDone
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (seconds == NULL) {
        seconds = @"00";
    }
    if (minutes == NULL) {
        minutes = @"00";
    }
    
    if ([self.warmupDuration isFirstResponder]) {
        selectedTextField = self.warmupDuration;
        NSLog(@"1");
        
    } else if ([self.lowIntervalDuration isFirstResponder]) {
        selectedTextField = self.lowIntervalDuration;
        NSLog(@"2");
    } else if ([self.highIntervalDuration isFirstResponder]) {
        selectedTextField = self.highIntervalDuration;
        NSLog(@"3");

    } else if ([self.cooldownDuration isFirstResponder]) {
        selectedTextField = self.cooldownDuration;
        NSLog(@"4");

    } else if ([self.repetitions isFirstResponder]) {
        selectedTextField = self.repetitions;
        NSLog(@"5");

    }
    
    selectedTextField.text = [NSString stringWithFormat:@"%@:%@", minutes, seconds];
    [selectedTextField resignFirstResponder];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // 2 columns: min and sec
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (component == 1) {
        return [self.secArray count];
    } else {
        return [self.minArray count];
    }
}

/* UIPickerViewDelegate */

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (component == 1) {
        return [self.secArray objectAtIndex:row];
    } else {
        return [self.minArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (component == 1) {
        seconds = [self.secArray objectAtIndex:row];
    } else {
        minutes = [self.minArray objectAtIndex:row];
    }
}

/* Check if all the textfields have valid text, then enable the start button */
- (void)enableStartButton {
    if (isSetWarmup && isSetLowInterval && isSetHighInterval && isSetCooldown && isSetRepetition) {
        [self.startButton setEnabled:YES];
    }
}

/* Hide keyboard when empty space is touched */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    [self.scrollView endEditing:YES];
}

- (IBAction)setWarmup:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    activeTextFieldRect = self.warmupDuration.frame;
    
    if ([self.warmupDuration.text isEqualToString:@""]) {
        isSetWarmup = NO;
        [self.startButton setEnabled:NO];
    } else {
        isSetWarmup = YES;
    }
    [self enableStartButton];
    
}

- (IBAction)setLowInterval:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    activeTextFieldRect = self.lowIntervalDuration.frame;
    
    if ([self.lowIntervalDuration.text isEqualToString:@""] || [self.lowIntervalDuration.text isEqualToString:@"00:00"]) {
        isSetLowInterval = NO;
        [self.startButton setEnabled:NO];
    } else {
        isSetLowInterval = YES;
    }
    [self enableStartButton];
}

- (IBAction)setHighInterval:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    activeTextFieldRect = self.highIntervalDuration.frame;
    
    if ([self.highIntervalDuration.text isEqualToString:@""] || [self.highIntervalDuration.text isEqualToString:@"00:00"]) {
        isSetHighInterval = NO;
        [self.startButton setEnabled:NO];
    } else {
        isSetHighInterval = YES;
    }
    [self enableStartButton];
}

- (IBAction)setCooldown:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    activeTextFieldRect = self.cooldownDuration.frame;
    
    if ([self.cooldownDuration.text isEqualToString:@""]) {
        isSetCooldown = NO;
        [self.startButton setEnabled:NO];
    } else {
        isSetCooldown = YES;
    }
    [self enableStartButton];
}

- (IBAction)setRepetitionsNumber:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    activeTextFieldRect = self.cooldownDuration.frame;

    int repetitionText = [self.repetitions.text intValue];
    if ([self.repetitions.text isEqualToString:@""] || repetitionText == 0) {
        isSetRepetition = NO;
        [self.startButton setEnabled:NO];
    } else {
        isSetRepetition = YES;
    }
    
    [self enableStartButton];
}

- (IBAction)startIntervalTimer:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

}

/* Save the textfields' text as default */
- (IBAction)setDefault:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.warmupDuration.text forKey:@"warmup"];
    [defaults setObject:self.lowIntervalDuration.text forKey:@"lowInterval"];
    [defaults setObject:self.highIntervalDuration.text forKey:@"highInterval"];
    [defaults setObject:self.cooldownDuration.text forKey:@"cooldown"];
    [defaults setObject:self.repetitions.text forKey:@"repetitions"];
    
    [defaults synchronize];
}

/* Get the saved default textfields' text */
- (void)getDefaultTextFieldData
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.warmupDuration.text = [defaults objectForKey:@"warmup"];
    self.lowIntervalDuration.text = [defaults objectForKey:@"lowInterval"];
    self.highIntervalDuration.text = [defaults objectForKey:@"highInterval"];
    self.cooldownDuration.text = [defaults objectForKey:@"cooldown"];
    self.repetitions.text = [defaults objectForKey:@"repetitions"];
}

/* Enable or disable START button */
- (void)checkTextFieldForEnablingStartButton
{
    
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"RunInterval"]) {
        NSLog(@"********************* set the string value");
        RunIntervalTrainerViewController *runIntervalTrainerViewController = segue.destinationViewController;
        
        // Pass the textfield's duration values
        runIntervalTrainerViewController.warmupDuration = self.warmupDuration.text;
        runIntervalTrainerViewController.lowIntervalDuration = self.lowIntervalDuration.text;
        runIntervalTrainerViewController.highIntervalDuration = self.highIntervalDuration.text;
        runIntervalTrainerViewController.cooldownDuration = self.cooldownDuration.text;
        runIntervalTrainerViewController.repetitions = self.repetitions.text;
    }
}

@end
