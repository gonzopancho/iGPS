//
//  LocalizationHandler.h
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Trieda LocalizationHandler
//  Je trieda vykonávajúcu lokalizovanie objektových reťazcov, 
//  prostredníctvom svojej singleton instancie.

@interface LocalizationHandler : NSObject {
    

}

//  pole jazykov
@property (retain) NSArray *appleLanguages;

//  balik v ktorom sa nachadzaju lokalizovane subory
@property (nonatomic,retain) NSBundle *bundle;

//  Triedna metóda zaisťujúca prístup k singletom inštancií.
+ (LocalizationHandler *)sharedHandler;

//  Metóda nahrádzajúca systémovú funkciu NSLocalizedString, 
//  potrebnú pre samotné lokalizovanie objektových reťazcov.
- (NSString *)localizedString:(NSString *)key;

- (void)setupKeyValueObserverving;
- (void)setupBundle;

    //metody ktore musia byt implementovane
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id)retain;
- (unsigned)retainCount;
- (void)release;
- (id)autorelease;

@end
