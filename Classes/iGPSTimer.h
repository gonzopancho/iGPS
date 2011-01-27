//
//  iGPSTimer.h
//  iGPS
//
//  Created by Jakub Petrík on 1/25/11.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface iGPSTimer : NSObject {

}

@property (nonatomic, retain) NSTimer *scheduler;
@property (assign) NSTimeInterval startInterval;
@property (assign) NSTimeInterval stopInterval;


- (void)start;
- (void)sendElapsedTimeNotification;


@end
