//
//  LocalizationHandler.h
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 1/10/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalizationHandler : NSObject {
    

}

+ (LocalizationHandler *)sharedHandler;
- (NSString *)localizedString:(NSString *)key;

- (void)setupKeyValueObserverving;
- (void)setupBundle;

+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id)retain;
- (unsigned)retainCount;
- (void)release;
- (id)autorelease;

@end
