//
//  LocalizationHandler.m
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 1/10/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "LocalizationHandler.h"



@implementation LocalizationHandler

@synthesize appleLanguages;
@synthesize bundle;

static LocalizationHandler *sharedLocalizator = nil;

- (id)init {
    
    if ((self = [super init])) {
        [self setupKeyValueObserverving];
    }
    return self;
}

- (NSBundle *)bundle {
    
    if (bundle == nil) {
        [self setupBundle];
    }
    
    return bundle;
}

- (void)defaultsChanged:(NSNotification *)aNotification {
    
    if (![sharedLocalizator.appleLanguages isEqualToArray:[[[aNotification object] dictionaryRepresentation] objectForKey:@"AppleLanguages"]]) {
        
        sharedLocalizator.appleLanguages = [[[aNotification object] dictionaryRepresentation] objectForKey:@"AppleLanguages"];
        
        [self setupBundle];
        NSLog(@"LocalizationHandler defaultsChanged" );
    }
    
    
}

- (void)setupKeyValueObserverving {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];   
}



- (void)setupBundle {
            
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];    
    NSString *language = [languages objectAtIndex:0];
    
    if ([language isEqualToString:@"en"]) language = @"English";
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",language] ofType:@"lproj"];
    sharedLocalizator.bundle = [NSBundle bundleWithPath:bundlePath];
}


+ (LocalizationHandler *)sharedHandler {
    @synchronized(self) {
        if (sharedLocalizator == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedLocalizator;
}

- (NSString *)localizedString:(NSString *)key {
    
    NSString *value = [sharedLocalizator.bundle localizedStringForKey:key value:nil table:nil];
    
    if (value) return value;
    return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
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
