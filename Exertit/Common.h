//
//  Common.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-20.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

// Navigation bar color
#define themeNavBar [UIColor colorWithRed:(0.0f/255.0f) green:(149.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0]
#define themeNavBar2 [UIColor colorWithRed:(0.0f/255.0f) green:(140.0f/255.0f) blue:(171.0f/255.0f) alpha:1.0]
#define themeNavBar3 [UIColor colorWithRed:(0.0f/255.0f) green:(163.0f/255.0f) blue:(128.0f/255.0f) alpha:1.0]
#define themeNavBar4_old [UIColor colorWithRed:(0.0f/255.0f) green:(155.0f/255.0f) blue:(176.0f/255.0f) alpha:1.0]
#define themeNavBar4 [UIColor colorWithRed:(0.0f/255.0f) green:(182.0f/255.0f) blue:(207.0f/255.0f) alpha:1.0]
#define themeNavBar5 [UIColor colorWithRed:(14.0f/255.0f) green:(130.0f/255.0f) blue:(128.0f/255.0f) alpha:1.0]
#define themeNavBar6 [UIColor colorWithRed:(0.0f/255.0f) green:(207.0f/255.0f) blue:(169.0f/255.0f) alpha:1.0]

// Apple color
#define appleRed [UIColor colorWithRed:(252.0f/255.0f) green:(87.0f/255.0f) blue:(93.0f/255.0f) alpha:1.0]
#define appleYellow [UIColor colorWithRed:(254.0f/255.0f) green:(240.0f/255.0f) blue:(136.0f/255.0f) alpha:1.0]
#define appleBlue [UIColor colorWithRed:(54.0f/255.0f) green:(162.0f/255.0f) blue:(231.0f/255.0f) alpha:1.0]
#define appleGreen [UIColor colorWithRed:(136.0f/255.0f) green:(226.0f/255.0f) blue:(83.0f/255.0f) alpha:1.0]
#define darkGreen [UIColor colorWithRed:(0.0f/255.0f) green:(153.0f/255.0f) blue:(66.0f/255.0f) alpha:1.0]

// Tableview color
#define lightBlue [UIColor colorWithRed:(232.0f/255.0f) green:(252.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0]
#define mediumBlue [UIColor colorWithRed:(219.0f/255.0f) green:(250.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0]
//#define darkBlue [UIColor colorWithRed:(0.0f/255.0f) green:(65.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0]
#define grey [UIColor colorWithRed:(145.0f/255.0f) green:(145.0f/255.0f) blue:(145.0f/255.0f) alpha:1.0]

// Slide menu
//#define darkBlue [UIColor colorWithRed:(41.0f/255.0f) green:(51.0f/255.0f) blue:(51.0f/255.0f) alpha:1.0]
#define darkBlue [UIColor colorWithRed:(30.0f/255.0f) green:(33.0f/255.0f) blue:(33.0f/255.0f) alpha:1.0]

// Interval trainer high and low labels
#define themeBlue [UIColor colorWithRed:(81.0/255.0f) green:(163.0/255.0f) blue:(245.0/255.0f) alpha:1.0]
#define themeOrange [UIColor colorWithRed:(252.0/255.0f) green:(159.0/255.0f) blue:(53.0/255.0f) alpha:1.0]
#define themeRed [UIColor colorWithRed:(251.0/255.0f) green:(53.0/255.0f) blue:(8.0/255.0f) alpha:1.0]
#define themeGreen [UIColor colorWithRed:(0.0/255.0f) green:(212.0/255.0f) blue:(123.0/255.0f) alpha:1.0]

// Text box color
#define themeGrey [UIColor colorWithRed:(84.0f/255.0f) green:(84.0f/255.0f) blue:(84.0f/255.0f) alpha:1.0]
#define themeGrey2 [UIColor colorWithRed:(160.0f/255.0f) green:(160.0f/255.0f) blue:(160.0f/255.0f) alpha:1.0]

// RunWorkout: next/previous exercise buttons
#define previousColor [UIColor colorWithRed:(149.0f/255.0f) green:(222.0f/255.0f) blue:(232.0f/255.0f) alpha:1.0]
//#define previousColor [UIColor colorWithRed:(122.0f/255.0f) green:(203.0f/255.0f) blue:(214.0f/255.0f) alpha:1.0]
//#define nextColor [UIColor colorWithRed:(95.0f/255.0f) green:(207.0f/255.0f) blue:(222.0f/255.0f) alpha:1.0]
#define nextColor [UIColor colorWithRed:(75.0f/255.0f) green:(189.0f/255.0f) blue:(204.0f/255.0f) alpha:1.0]

// Max length of names
#define WORKOUT_MAX_LENGTH 20
#define EXERCISE_MAX_LENGTH 20
#define NOTE_MAX_LENGTH 300

// Detect Iphone 5 device
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

@interface Common : NSObject

@end
