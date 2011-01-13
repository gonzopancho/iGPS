//
//  LocationProvider.m
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 11/23/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "LocationProvider.h"
#import "GPSDataFormatter.h"


@implementation LocationProvider

@synthesize locationManager;
@synthesize currentHeading;
@synthesize delegate;
@synthesize isSpeedValid;
@synthesize isHeadingValid;



#pragma mark -
#pragma mark Initialization

- (id)initAndStartMonitoringLocation {
    
    if ((self = [super init])) {
       
        [self startUpdatingLocationAndHeading];
    }
    return self;
}

- (void)setupLocationManager {
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
}

- (BOOL)isSpeedValid {
    
    if (self.locationManager.location.speed < 0) isSpeedValid = NO;
    else isSpeedValid = YES;
    
    return isSpeedValid;
}


#pragma mark -
#pragma mark LocationProvider life cycle

- (void)startUpdatingLocationAndHeading {
    
    [self performSelector:@selector(startUpdatingLocation)];
    [self performSelector:@selector(startUpdatingHeading)];
    
}
- (void)stopUpdatingLocationAndHeading {
    
    [self performSelector:@selector(stopUpdatingLocation)];
    [self performSelector:@selector(stopUpdatingHeading)];
    
}
- (void)startUpdatingHeading {
    
    if ([CLLocationManager headingAvailable]) {
        if (!self.locationManager) {
            [self setupLocationManager];
        }
        [self.locationManager startUpdatingHeading];
    }
    
}
- (void)stopUpdatingHeading {
    
    [self.locationManager stopUpdatingHeading];
    
}
- (void)startUpdatingLocation {
    
    if ([CLLocationManager locationServicesEnabled]) {
        if (!self.locationManager) {
            [self setupLocationManager];
        }
        [self.locationManager startUpdatingLocation];
    }
    
}
- (void)stopUpdatingLocation {
    
    [self.locationManager stopUpdatingLocation];
    
}


#pragma mark -
#pragma mark Latitude and Longitude

- (NSString *)latitudeInDegDec {
    return [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
}

- (NSString *)latitudeInDMS {
    return [NSString stringWithFormat:@"%@",[GPSDataFormatter latitudeInDMS:self.locationManager.location.coordinate.latitude]];   
}

- (NSString *)longitudeInDegDec {
    return [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
}

- (NSString *)longitudeInDMS {
    return [NSString stringWithFormat:@"%@",[GPSDataFormatter longitudeInDMS:self.locationManager.location.coordinate.longitude]];
}


#pragma mark -
#pragma mark Altitude

- (NSString *)altitudeInMetres {
    return [NSString stringWithFormat:@"%.3f m",self.locationManager.location.altitude];
}

- (NSString *)altitudeInKilometres {
    return [NSString stringWithFormat:@"%.3f km",self.locationManager.location.altitude * 0.001];
}

- (NSString *)altitudeInFeet {
    return [NSString stringWithFormat:@"%.3f ft",self.locationManager.location.altitude * 3.28083];    
}

- (NSString *)altitudeInMiles {
    return [NSString stringWithFormat:@"%.4f miles",self.locationManager.location.altitude * 0.000621371192]; 
}


#pragma mark -
#pragma mark Speed


- (NSString *)speedInMetresPerSecond {
   
    if (!self.isSpeedValid) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    else return [NSString stringWithFormat:@"%.2f m/s",self.locationManager.location.speed];
}

- (NSString *)speedInKilometersPerHour {
    
    if (!self.isSpeedValid) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    else return [NSString stringWithFormat:@"%.2f km/h",self.locationManager.location.speed * 3.6];
}

- (NSString *)speedInMilesPerHour {
    
    if (!self.isSpeedValid) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    else return [NSString stringWithFormat:@"%.2f mph",self.locationManager.location.speed * 2.24];
}

- (NSString *)speedInKnots {
    
    if (!self.isSpeedValid) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    else return [NSString stringWithFormat:@"%.2f knots",self.locationManager.location.speed * 1.94];
}

- (NSString *)speedInFeetPerSecond {
    
    if (!self.isSpeedValid) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    else return [NSString stringWithFormat:@"%.2f ft/s",self.locationManager.location.speed * 3.28];
}


#pragma mark -
#pragma mark Heading

- (int)orientationFromDegrees:(float)degrees {
    
    int orientation = 0;
    
    if ((degrees >= 0.) && (degrees <= 44.9)) {
        orientation = 1; //North
    }
    if ((degrees >= 45.) && (degrees <= 89.9)) {
        orientation = 2; //NorthEast
    }
    if ((degrees >= 90.) && (degrees <= 134.9)) {
        orientation = 3; //East
    }
    if ((degrees >= 135.) && (degrees <= 179.9)) {
        orientation = 4; //SouthEast
    }
    if ((degrees >= 180.) && (degrees <= 224.9)) {
        orientation = 5; //South
    }
    if ((degrees >= 225.) && (degrees <= 269.9)) {
        orientation = 6; //SouthWest
    }
    if ((degrees >= 270) && (degrees <= 314.9)) {
        orientation = 7; //West
    }
    if ((degrees >= 315) && (degrees <= 359.9)) {
        orientation = 8; //NorthWest
    }
    
    return orientation;
}

- (NSString *)stringFromDegrees:(double)degrees {

    NSString *stringToReturn;
    double degreesValue = degrees;
    
    switch ([self orientationFromDegrees:degreesValue]) {
        case 1:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,NSLocalizedString(@"N",nil)];
            break;
        case 2:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,NSLocalizedString(@"NE",nil)];
            break;
        case 3:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,NSLocalizedString(@"E",nil)];
            break;
        case 4:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,NSLocalizedString(@"SE",nil)];
            break;
        case 5:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,NSLocalizedString(@"S",nil)];
            break;
        case 6:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,NSLocalizedString(@"SW",nil)];
            break;
        case 7:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,NSLocalizedString(@"W",nil)];
            break;
        case 8:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,NSLocalizedString(@"NW",nil)];
            break;
        default:
            stringToReturn = [NSString stringWithFormat:@"%.1f˚",degreesValue];
            break;
    }
    return stringToReturn;
    
}

- (NSString *)trueHeading {
    return [self stringFromDegrees:self.locationManager.heading.trueHeading];
    
}

- (NSString *)magneticHeading {
    return [self stringFromDegrees:self.locationManager.heading.magneticHeading];  
}


#pragma mark -
#pragma mark Course

- (BOOL)isCourseValid:(double)course {
    
    if (course == -1) return NO;
    else return YES;
}

- (NSString *)courseInDegrees {
    
    if ([self isCourseValid:self.locationManager.location.course]) {
        return [NSString stringWithFormat:@"%.1f˚",self.locationManager.location.course];
    } else return [NSString stringWithString:NSLocalizedString(@"Updating...",@"Aktualizujem...")];
    
}


- (NSString *)courseMixed {
    
    double courseDegrees = self.locationManager.location.course;
    NSString *stringToReturn;
    
    if ([self isCourseValid:courseDegrees]) {
        
        stringToReturn = [self stringFromDegrees:courseDegrees];
    } else stringToReturn = [NSString stringWithString:NSLocalizedString(@"Updating...",@"Aktualizujem...")];
    
    return stringToReturn;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (![newLocation isEqual:oldLocation]) {
        [[self delegate] locationProviderDidUpdateLocation];
        if (oldLocation.coordinate.latitude != newLocation.coordinate.latitude) {
            
            if ([[self delegate] respondsToSelector:@selector(locationProviderDidUpdateLatitude)]) {
                [[self delegate] locationProviderDidUpdateLatitude];
            }
            
        }
        
        if (oldLocation.coordinate.longitude != newLocation.coordinate.longitude) {
            
            if ([[self delegate] respondsToSelector:@selector(locationProviderDidUpdateLongitude)]) {
                [[self delegate] locationProviderDidUpdateLongitude];
            }
            
        }
        
        if (oldLocation.altitude != newLocation.altitude) {
            
            if ([[self delegate] respondsToSelector:@selector(locationProviderDidUpdateAltitude)]) {
                [[self delegate] locationProviderDidUpdateAltitude];
            }
            
        }
        
        if (oldLocation.speed != newLocation.speed) {
            
            if ([[self delegate] respondsToSelector:@selector(locationProviderDidUpdateSpeed)]) {
                [[self delegate] locationProviderDidUpdateSpeed];
            }
            
        }
        
        if (oldLocation.course != newLocation.course) {
            
            if ([[self delegate] respondsToSelector:@selector(locationProviderDidUpdateCourse)]) {
                [[self delegate] locationProviderDidUpdateCourse];
            }
            
        }
         
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  
    [newHeading retain];
    if ((self.currentHeading.magneticHeading != newHeading.magneticHeading)  
        ) {
        
        self.currentHeading = newHeading;
        isHeadingValid = YES;
        
        if ([self.delegate respondsToSelector:@selector(locationProviderDidUpdateHeading)]) {
            [self.delegate performSelector:@selector(locationProviderDidUpdateHeading)];
        }
        
    }
}
    

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"%@",[error localizedDescription]);
    
}


- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    
    return YES;
}


#pragma mark -
#pragma mark MemoryManagement


- (void)dealloc {
    [locationManager release];
    [delegate release];
    [super dealloc];
}

@end
