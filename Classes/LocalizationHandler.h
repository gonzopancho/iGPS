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
- (void)setupKeyValueObserverving;
- (void)setupBundle;
- (NSString *)localizedString:(NSString *)key;


+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (id)retain;
- (unsigned)retainCount;
- (void)release;
- (id)autorelease;

@end
