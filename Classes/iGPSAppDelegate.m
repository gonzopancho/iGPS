//
//  iGPSAppDelegate.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "iGPSAppDelegate.h"
#import "Constants.h"

@implementation iGPSAppDelegate

@synthesize window;
@synthesize tabBarController;   

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    
    
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kFirstNameKey];
    if (testValue == nil)
    {
            // no default values have been set, create them here based on what's in our Settings bundle info
            //
        NSString *pathStr = [[NSBundle mainBundle] bundlePath];
        NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
        NSDictionary *settingsDict  = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
            //NSLog(@"%@",[prefSpecifierArray description]);
        
        NSNumber *speedDefault    = [NSNumber numberWithInt:0];
        NSNumber *altitudeDefault = [NSNumber numberWithInt:0];
        NSNumber *northDefault    = [NSNumber numberWithInt:0];
        NSNumber *distanceDefault = [NSNumber numberWithInt:10];
        NSNumber *accuracyDefault = [NSNumber numberWithInt:0];
        NSNumber *accUnitsDefault = [NSNumber numberWithInt:0];
        NSNumber *courseDefault   = [NSNumber numberWithInt:0];
        NSNumber *coordsDefault   = [NSNumber numberWithInt:0];
        
        NSDictionary *prefItem;
        for (prefItem in prefSpecifierArray) {
            
            NSString *keyValueStr = [prefItem objectForKey:@"Key"];
            id defaultValue = [prefItem objectForKey:@"DefaultValue"];
            
            if ([keyValueStr isEqualToString:kSpeedKey]) {
                speedDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kAccuracyKey]) {
                accuracyDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kAltitudeKey]) {
                altitudeDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kNorthKey]) {
                northDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kDistanceKey]) {
                distanceDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kCourseKey]) {
                courseDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kAccUnitsKey]) {
                accUnitsDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kCoordsKey]) {
                coordsDefault = defaultValue;
            }
        }
        
            // since no default values have been set (i.e. no preferences file created), create it here     
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     speedDefault, kSpeedKey,
                                     accuracyDefault, kAccuracyKey,
                                     accUnitsDefault, kAccUnitsKey,
                                     altitudeDefault, kAltitudeKey,
                                     northDefault, kNorthKey,
                                     distanceDefault, kDistanceKey,
                                     courseDefault, kCourseKey,
                                     coordsDefault,kCoordsKey,
                                     nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
      
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    

    
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [tabBarController release];
	[window release];
	[super dealloc];
}


@end

