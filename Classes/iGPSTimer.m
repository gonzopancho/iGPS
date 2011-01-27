//
//  iGPSTimer.m
//  iGPS
//
//  Created by Jakub Petrík on 1/25/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import "iGPSTimer.h"


@implementation iGPSTimer

@synthesize scheduler;
@synthesize startInterval;
@synthesize stopInterval;


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

- (void)stop {
    
    [self.scheduler invalidate];
    
}


- (void)sendElapsedTimeNotification {
    
    self.startInterval = [NSDate timeIntervalSinceReferenceDate];
    
    NSNumber *elapsedTime = [NSNumber numberWithDouble:self.startInterval - self.stopInterval];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"elapsedTime" 
                                                        object:elapsedTime];
    
}

- (void)dealloc {

    [scheduler release];
    [super dealloc];
    
}


@end
