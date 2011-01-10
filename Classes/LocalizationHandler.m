//
//  LocalizationHandler.m
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 1/10/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "LocalizationHandler.h"


@implementation LocalizationHandler

static LocalizationHandler *sharedLocalizator = nil;

+ (LocalizationHandler *)sharedHandler {
    @synchronized(self) {
        if (sharedLocalizator == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedLocalizator;
}

- (NSString *)localizedString:(NSString *)key {
    
    
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];    
    NSString *language = [languages objectAtIndex:0];
    
    
    if ([language isEqualToString:@"en"]) language = @"English";

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",language] ofType:@"lproj"];
    NSLog(@"bundlePath: %@",bundlePath);
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSLog(@"localizedString bundle: %@",[bundle description]);
    NSString *value = [bundle localizedStringForKey:key value:nil table:nil];
    
    NSLog(@"localizedString %@",value);
        //if (value)
        return value;
        // and maybe fall-back to the default localized string loading
        //return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedLocalizator == nil) {
            sharedLocalizator = [super allocWithZone:zone];
            return sharedLocalizator;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

- (id)retain {
    
    return self;
}

- (unsigned)retainCount {
    
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    
        //do nothing
}

- (id)autorelease {
    
    return self;
}

@end
