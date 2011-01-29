//
//  iGPSTimer.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "iGPSTimer.h"
#import "Constants.h"

@implementation iGPSTimer

@synthesize scheduler;
@synthesize startInterval;
@synthesize stopInterval;

//  metoda posle notifikaciu ktorej meno je hodonota konstany
//  kElapsedTime a objekt je pocet sekund od spustenia casomiery
- (void)sendElapsedTimeNotification {
    
    self.startInterval = [NSDate timeIntervalSinceReferenceDate];
    
    NSNumber *elapsedTime = [NSNumber numberWithDouble:self.startInterval - self.stopInterval];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kElapsedTimeKey 
                                                        object:elapsedTime];
}

//  Metoda zacne merat cas a nastavi instanciu na posielanie 
//  sprav s menon “elapsedTime” a objektom NSNumber reprezentujucim 
//  cas od volania tejto metody.
- (void)start {
    
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    
    self.startInterval = interval;
    self.stopInterval = interval;
    
    if (!self.scheduler) {
        
        self.scheduler = [NSTimer scheduledTimerWithTimeInterval:.1
                                                          target:self
                                                        selector:@selector(sendElapsedTimeNotification) 
                                                        userInfo:nil 
                                                         repeats:YES];
        
    }
        
}

//  zastavi posielanie sprav
- (void)stop {
    
    [self.scheduler invalidate];
    
}


//  destruktor
- (void)dealloc {

    [scheduler release];
    [super dealloc];
    
}


@end
