//
//  LocalizationHandler.m
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 1/10/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "LocalizationHandler.h"
#import <dispatch/dispatch.h>


@implementation LocalizationHandler

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
    
    [self setupBundle];
}

- (void)setupKeyValueObserverving {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];   
    
    [center addObserver:self
             forKeyPath:@"AppleLanguages"
                options:NSKeyValueObservingOptionNew
                context:nil];
}
         

- (void)setupBundle {
    
    dispatch_queue_t bundleQueue = dispatch_queue_create("dispatchQueue", NULL);
    dispatch_async(bundleQueue, ^{
        
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];    
        NSString *language = [languages objectAtIndex:0];
        
        if ([language isEqualToString:@"en"]) language = @"English";
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",language] ofType:@"lproj"];
            //NSLog(@"bundlePath: %@",bundlePath);
        self.bundle = [NSBundle bundleWithPath:bundlePath];
        
    });
    dispatch_release(bundleQueue);
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
    
        //NSLog(@"localizedString bundle: %@",[self.bundle description]);
    NSString *value = [self.bundle localizedStringForKey:key value:nil table:nil];
    
        // NSLog(@"localizedString %@",[value description]);
    if (value)
        return value;
        // and maybe fall-back to the default localized string loading
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
