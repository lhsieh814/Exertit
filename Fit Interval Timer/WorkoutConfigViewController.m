//
//  WorkoutConfigViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2/16/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "WorkoutConfigViewController.h"
#import "Exercise.h"
#import "AllExercisesTableViewController.h"

@interface WorkoutConfigViewController ()

@end

@implementation WorkoutConfigViewController

UIToolbar *pickerToolbar;
NSTimeInterval nsTimeInterval;
NSString *seconds;
NSString *minutes;
bool createdNewExerciseSetting;

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
    self.timePicker = [[UIPickerView alloc] init];
    self.timePicker.showsSelectionIndicator = YES;
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    self.timePicker.backgroundColor = [UIColor whiteColor];
    self.durationText.inputView = self.timePicker;

    // Done bar button
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
    
    pickerToolbar.items = [NSArray arrayWithObjects:space, done, nil];
    self.durationText.inputAccessoryView = pickerToolbar;
    
    // NSTimeInterval set to 0
    nsTimeInterval = 0.0;
    
    // Set the minutes and seconds to nil to avoid messing up next picker's values
    minutes = nil;
    seconds = nil;

    [self initialSetup];
    
    // Color and text customizations
    [self.selectedExerciseButton setTitleColor:themeNavBar4 forState:UIControlStateNormal];
    self.selectedExerciseArrow.textColor = themeNavBar4;
    self.repsStepperItem.tintColor = themeNavBar4;
    self.setsStepperItem.tintColor = themeNavBar4;
    [self changeTextFieldBorderAndTextColor];

    // Dismiss keyboard when outside is touched
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

// called everytime we enter the view
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set the values to the textfields and steppers
-(void)initialSetup
{
    if (!self.exerciseSetting) {
        // Initialize newExericse object
        self.exerciseSetting = [ExerciseSetting createEntity];
        createdNewExerciseSetting = YES;
    } else {
        // Editing the settings
        createdNewExerciseSetting = NO;
        
        [self.selectedExerciseButton setTitle:self.exerciseSetting.baseExercise.exerciseName forState:UIControlStateNormal];
        
        NSInteger repInt = [self.exerciseSetting.reps integerValue];
        NSInteger setInt = [self.exerciseSetting.sets integerValue];
        
        self.repsText.text = [NSString stringWithFormat: @"%02ld", (long)repInt];
        self.setsText.text = [NSString stringWithFormat: @"%02ld", (long)setInt];
        self.weightLabel.text = [NSString stringWithFormat:@"%d", [self.exerciseSetting.weight intValue]];
        [self.repsStepperItem setValue:[self.exerciseSetting.reps doubleValue]];
        [self.setsStepperItem setValue:[self.exerciseSetting.sets doubleValue]];
        
        // Set the saved values for the time picker and time label
        int totalTimeInSeconds = [self.exerciseSetting.timeInterval intValue];
        int min = totalTimeInSeconds / 60;
        int sec = (totalTimeInSeconds % 60) / 5;
        self.durationText.text = [NSString stringWithFormat:@"%@:%@", [self.minArray objectAtIndex:min], [self.secArray objectAtIndex:sec]];
        
        [self.timePicker selectRow:min inComponent:0 animated:YES];
        [self.timePicker selectRow:sec inComponent:1 animated:YES];
        
        minutes = [NSString stringWithFormat:@"%02zd", min];
        seconds = [NSString stringWithFormat:@"%02zd", sec * 5];
    }
}

/* Change all the textfields' border color and text color*/
-(void)changeTextFieldBorderAndTextColor
{
    for (UITextField *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [[subView layer] setBorderColor:[themeNavBar4 CGColor]];
            subView.layer.borderWidth= 1.0f;
            subView.layer.cornerRadius = 8.0f;
        }
    }
    
    self.durationText.textColor = themeNavBar4;
    self.weightLabel.textColor = themeNavBar4;
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"selectExercise"]) {
        AllExercisesTableViewController *allExercisesTableViewController = segue.destinationViewController;
                
        // Set the title of next controller
        allExercisesTableViewController.title = @"Select Exercise";
        // Hide the sidebar button
        allExercisesTableViewController.navigationItem.leftBarButtonItem = nil;
        
        // Set the delegate
        allExercisesTableViewController.delegate = self;
    }
}

/* UIPickerViewDataSource */

// Time picker Done button
-(void)pickerDone
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (seconds == nil) {
        seconds = @"00";
    }
    if (minutes == nil) {
        minutes = @"00";
    }
    nsTimeInterval = [minutes doubleValue] * 60 + [seconds doubleValue];
    self.durationText.text = [NSString stringWithFormat:@"%@:%@", minutes, seconds];
    
    [self.durationText resignFirstResponder];
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
    if (component == 1) {
        seconds = [self.secArray objectAtIndex:row];
    } else {
        minutes = [self.minArray objectAtIndex:row];
    }
}

/* Hide keyboard when empty space is touched */
-(void)dismissKeyboard {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    UIView *v = self.view;
    
    if ([v isEqual:0]) {
        NSLog(@"hello");
    }
    
    [self.view endEditing:YES];
}

/* Bar buttons */

- (IBAction)done:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.exerciseSetting.reps = [NSNumber numberWithInteger:[self.repsText.text integerValue]];
    self.exerciseSetting.sets = [NSNumber numberWithInteger:[self.setsText.text integerValue]];
    self.exerciseSetting.weight = [NSNumber numberWithInteger:[self.weightLabel.text integerValue]];
    self.exerciseSetting.timeInterval = [NSNumber numberWithDouble:nsTimeInterval];

    // Only need to set the index if it is a new ExerciseSetting- not when editting
    if (createdNewExerciseSetting) {
        int size = (int)[self.workout.exerciseGroup count];
        self.exerciseSetting.index = [NSNumber numberWithInt:size];
    }
    
    [self.workout addExerciseGroupObject:self.exerciseSetting];
    [self saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"createNewExerciseSetting = %d", createdNewExerciseSetting);
    if (createdNewExerciseSetting) {
        NSLog(@"wrong");
        // Delete the newly created exercise entity
        [self.exerciseSetting deleteEntity];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* Save data */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

/* Steppers for reps and sets */

- (IBAction)repsStepper:(UIStepper *)sender {
    
    double value = [sender value];
    [self.repsText setText:[NSString stringWithFormat:@"%02d", (int)value] ];
}

- (IBAction)setsStepper:(UIStepper *)sender {

    double value = [sender value];
    [self.setsText setText:[NSString stringWithFormat:@"%02d", (int)value] ];
}

#pragma mark - AllExercisesTableViewControllerDelegate

// Pass the selected Exercise object
- (void)allExercisesViewControllerDidSelectWorkout:(AllExercisesTableViewController *)controller didSelectExercise:(Exercise *)exercise
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // display the selected exercise's name
    [self.selectedExerciseButton setTitle:exercise.exerciseName forState:UIControlStateNormal];

    self.exerciseSetting.baseExercise = exercise;
    NSLog(@"%@", self.exerciseSetting.baseExercise);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
