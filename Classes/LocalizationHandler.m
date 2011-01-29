//
//  LocalizationHandler.m
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "LocalizationHandler.h"
#import "Constants.h"

@implementation LocalizationHandler

@synthesize appleLanguages;
@synthesize bundle;

static LocalizationHandler *sharedLocalizator = nil;

- (id)init {
    
    if ((self = [super init])) {
        
        //  Nastav KVO
        [self setupKeyValueObserverving];
    }
    return self;
}


//  Navratova metoda pre accessor bundle.
- (NSBundle *)bundle {
    
    // Ak je bundle nil, nastav ho.
    if (!bundle) {
        [self setupBundle];
    }
    
    return bundle;
}


// Metoda volana pri obdrzani sparvy o vykonanej zmene v uzivatelskych nastaveniach.
- (void)defaultsChanged:(NSNotification *)aNotification {
    
    //  Ak sa zmenilo pole jazykov aktualizuj pole appleLanguages a nastav bundle
    if (![sharedLocalizator.appleLanguages isEqualToArray:[[[aNotification object] dictionaryRepresentation] objectForKey:kAppleLanguages]]) {
        
        sharedLocalizator.appleLanguages = [[[aNotification object] dictionaryRepresentation] objectForKey:kAppleLanguages];
        
        [self setupBundle];
        NSLog(@"LocalizationHandler defaultsChanged" );
    }
    
    
}

//  Nastav KVO.
- (void)setupKeyValueObserverving {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(defaultsChanged:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];   
}



//  Nastav bundle
- (void)setupBundle {
            
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:kAppleLanguages];    
    NSString *language = [languages objectAtIndex:0];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",language] ofType:@"lproj"];
    sharedLocalizator.bundle = [NSBundle bundleWithPath:bundlePath];
}

//  Triedna metóda zaisťujúca prístup k singletom inštancií.
+ (LocalizationHandler *)sharedHandler {
    @synchronized(self) {
        if (sharedLocalizator == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedLocalizator;
}

//  Metoda lokalizuje retaz podla kluca predaneho ako argument
- (NSString *)localizedString:(NSString *)key {
    
    NSString *value = [sharedLocalizator.bundle localizedStringForKey:key value:nil table:nil];
    
    //  V pripade neuspechu ziskania lokalizovaneho retazca v nastavenom baliku zdrojov, vrati povodny.
    if (value) return value;
    return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
}

// Triedna metoda alokacie podla predanej pamatovej zony  
+ (id)allocWithZone:(NSZone *)zone {
    
    //  mutex
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
    
    return UINT_MAX;  //naznacuje ze objekt nemoze byt uvolneny
}

- (void)release {
    
        //nerob nic, objekt nemoze byt uvolneny
}

- (id)autorelease {
    
    return self;
}

@end
