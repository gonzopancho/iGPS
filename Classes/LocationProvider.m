//
//  LocationProvider.m
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 11/23/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "LocationProvider.h"
#import "GPSDataFormatter.h"
#import "Constants.h"


@implementation LocationProvider

@synthesize locationManager;
@synthesize userDefaultsValues;
@synthesize currentHeading;
@synthesize delegate;
@synthesize isHeadingValid;


#pragma mark -
#pragma mark Initialization


- (void)setupUserDefaultsValues {
    
    NSNumber *speed    = [[NSUserDefaults standardUserDefaults] objectForKey:kSpeedKey];
    NSNumber *accuracy = [[NSUserDefaults standardUserDefaults] objectForKey:kAccuracyKey];
    NSNumber *accUnits = [[NSUserDefaults standardUserDefaults] objectForKey:kAccUnitsKey];
    NSNumber *altitude = [[NSUserDefaults standardUserDefaults] objectForKey:kAltitudeKey];
    NSNumber *north    = [[NSUserDefaults standardUserDefaults] objectForKey:kNorthKey];
    NSNumber *distance = [[NSUserDefaults standardUserDefaults] objectForKey:kDistanceKey];
    NSNumber *course   = [[NSUserDefaults standardUserDefaults] objectForKey:kCourseKey];
    NSNumber *coords   = [[NSUserDefaults standardUserDefaults] objectForKey:kCoordsKey];
    
    self.userDefaultsValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               speed,kSpeedKey,
                               accuracy,kAccuracyKey,
                               accUnits,kAccUnitsKey,
                               altitude,kAltitudeKey,
                               north,kNorthKey,
                               distance,kDistanceKey,
                               course,kCourseKey,
                               coords,kCoordsKey,nil];
}

- (void)setupKeyValueObserverving {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accuracyChanged:)
                                                 name:kAccuracyKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(distanceFilterChanged:) 
                                                 name:kDistanceKey
                                               object:nil];
    
        //notifications for methods change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDefaults:)
                                                 name:kNorthKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDefaults:)
                                                 name:kCoordsKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDefaults:)
                                                 name:kAccUnitsKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDefaults:)
                                                 name:kAltitudeKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDefaults:)
                                                 name:kSpeedKey
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDefaults:)
                                                 name:kCourseKey
                                               object:nil];
    
    
}


- (id)init {
    
    if ((self = [super init])) {
        NSLog(@"LocationProvider INIT");
        [self setupUserDefaultsValues];
        [self setupKeyValueObserverving];
        [self setupLocationManager];
    }
    return self;
}

- (void)setupLocationManager {
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    
    self.locationManager.delegate = self;
    [self setAccuracy:[self.userDefaultsValues objectForKey:kAccuracyKey]];
    [self setDistanceFilter:[self.userDefaultsValues objectForKey:kDistanceKey]];
}


- (BOOL)isDoubleValid:(double)value {
    
    return (value >= 0);
}


#pragma mark -
#pragma mark LocationProvider life cycle


- (void)updateDefaults:(NSNotification *)aNotification {
    
    NSMutableDictionary * newDefaults = [NSMutableDictionary dictionary];
    
    if (self.userDefaultsValues) {
        newDefaults = [self.userDefaultsValues mutableCopy];
    } 
    
    [newDefaults setObject:[aNotification object] forKey:[aNotification name]];

    self.userDefaultsValues = newDefaults;
    [newDefaults release];
    
    NSLog(@"userDefaultsValues: %@",[self.userDefaultsValues description]);
    
}

- (void)accuracyChanged:(NSNotification *)aNotification {
    
    [self setAccuracy:[aNotification object]];
}

- (void)distanceFilterChanged:(NSNotification *)aNotification {
    
    [self setDistanceFilter:[aNotification object]];
    
}


- (void)setAccuracy:(id)newAccuracy {
    
    if ([newAccuracy isKindOfClass:[NSNumber class]]) {
        NSNumber *accuracy = newAccuracy;        
            
        switch ([accuracy intValue]) {
            case 1:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                break;
            case 2:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                break;
            case 3:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                break;
            case 4:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
                break;
            case 5:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
                break;
            default:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                break;
        }
        
        
    }
    
            
}


- (void)setDistanceFilter:(id)newFilter {
    
    if ([newFilter isKindOfClass:[NSNumber class]]) {
        NSNumber *distanceFilter = newFilter;
        
        if ([distanceFilter doubleValue] != self.locationManager.distanceFilter) {
            self.locationManager.distanceFilter = [distanceFilter doubleValue];
        }
    }
    
    
    
}

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


    //Latitude

- (NSString *)latitudeInDegDec {
    return [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
}

- (NSString *)latitudeInDMS {
    return [NSString stringWithFormat:@"%@",[GPSDataFormatter latitudeInDMS:self.locationManager.location.coordinate.latitude]];   
}

- (NSString *)latitudeByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kCoordsKey];
    
    if ([defaultsValue intValue] == 0) return [self latitudeInDegDec];
    
    return [self latitudeInDMS];
}


    //Longitude

- (NSString *)longitudeInDegDec {
    return [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
}

- (NSString *)longitudeInDMS {
    return [NSString stringWithFormat:@"%@",[GPSDataFormatter longitudeInDMS:self.locationManager.location.coordinate.longitude]];
}

- (NSString *)longitudeByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kCoordsKey];
    
    if ([defaultsValue intValue] == 0) return [self longitudeInDegDec];
    
    return [self longitudeInDMS];
}


    //Altitude

- (NSString *)altitudeInMetres {
    return [NSString stringWithFormat:@"%.3f m",self.locationManager.location.altitude];
}

- (NSString *)altitudeInKilometres {
    return [NSString stringWithFormat:@"%.3f km",self.locationManager.location.altitude * 0.001];
}

- (NSString *)altitudeInFeet {
    return [NSString stringWithFormat:@"%.3f %@",
            self.locationManager.location.altitude * 3.28083, 
            NSLocalizedString(@"ft",nil)];    
}

- (NSString *)altitudeInMiles {
    return [NSString stringWithFormat:@"%.4f %@",
            self.locationManager.location.altitude * 0.000621371192,
            NSLocalizedString(@"miles",nil)]; 
}

- (NSString *)altitudeByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kAltitudeKey];
    
    switch ([defaultsValue intValue]) {
        case 1:
            return [self altitudeInKilometres];
            break;
        case 2:
            return [self altitudeInFeet];
            break;
        case 3:
            return [self altitudeInMiles];
            break;
        default:
            return [self altitudeInMetres];
            break;
    }

    
}


    //Speed


- (NSString *)speedInMetresPerSecond {
   
    if (![self isDoubleValid:self.locationManager.location.speed]) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    return [NSString stringWithFormat:@"%.2f m/s",self.locationManager.location.speed];
}

- (NSString *)speedInKilometersPerHour {
    
    if (![self isDoubleValid:self.locationManager.location.speed]) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    return [NSString stringWithFormat:@"%.2f km/h",self.locationManager.location.speed * 3.6];
}

- (NSString *)speedInMilesPerHour {
    
    if (![self isDoubleValid:self.locationManager.location.speed]) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    return [NSString stringWithFormat:@"%.2f mph",self.locationManager.location.speed * 2.24];
}

- (NSString *)speedInKnots {
    
    if (![self isDoubleValid:self.locationManager.location.speed]) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    return [NSString stringWithFormat:@"%.2f %@",self.locationManager.location.speed * 1.94,NSLocalizedString(@"knots",nil)];
}

- (NSString *)speedInFeetPerSecond {
    
    if (![self isDoubleValid:self.locationManager.location.speed]) return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    return [NSString stringWithFormat:@"%.2f ft/s",self.locationManager.location.speed * 3.28];
}

- (NSString *)speedByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kSpeedKey];
    
    switch ([defaultsValue intValue]) {
        case 1:
            return [self speedInMetresPerSecond];
            break;
        case 2:
            return [self speedInMilesPerHour];
            break;
        case 3:
            return [self speedInKnots];
            break;
        case 4:
            return [self speedInFeetPerSecond];
            break;
        default:
            return [self speedInKilometersPerHour];
            break;
    }
    
}

    //Heading

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

- (NSString *)headingByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kNorthKey];
    
    if ([defaultsValue intValue] == 0) return [self trueHeading];
    
    return [self magneticHeading];
    
}


    //Course

- (NSString *)courseInDegrees {
    
    if ([self isDoubleValid:self.locationManager.location.course]) {
        return [NSString stringWithFormat:@"%.1f˚",self.locationManager.location.course];
    } else return [NSString stringWithString:NSLocalizedString(@"Updating...",@"Aktualizujem...")];
    
}

- (NSString *)courseMixed {
    
    double courseDegrees = self.locationManager.location.course;
    NSString *stringToReturn;
    
    if ([self isDoubleValid:courseDegrees]) {
        
        stringToReturn = [self stringFromDegrees:courseDegrees];
    } else stringToReturn = [NSString stringWithString:NSLocalizedString(@"Updating...",@"Aktualizujem...")];
    
    return stringToReturn;
}

- (NSString *)courseByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kCourseKey];
    
    if ([defaultsValue intValue] == 0) return [self courseInDegrees];
    
    return [self courseMixed];
    
}

    //vertical accuracy

- (NSString *)verticalAccuracyInMeters {
    
    if (![self isDoubleValid:self.locationManager.location.verticalAccuracy]) {
        
        return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    }
    return [NSString stringWithFormat:@"%.2f m",self.locationManager.location.verticalAccuracy];
}


- (NSString *)verticalAccuracyInKilometres {

    if (![self isDoubleValid:self.locationManager.location.verticalAccuracy]) {
        
        return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    }
    return [NSString stringWithFormat:@"%.3f Km",self.locationManager.location.verticalAccuracy * 0.001];
}


- (NSString *)verticalAccuracyInFeet {
    
    if (![self isDoubleValid:self.locationManager.location.verticalAccuracy]) {
        
        return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    }
    return [NSString stringWithFormat:@"%.2f %@",
            self.locationManager.location.verticalAccuracy * 3.28083,
            NSLocalizedString(@"ft",nil)];
}


- (NSString *)verticalAccuracyInMiles {
    
    if (![self isDoubleValid:self.locationManager.location.verticalAccuracy]) {
        
        return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    }
    return [NSString stringWithFormat:@"%.4f %@",
            self.locationManager.location.verticalAccuracy * 0.000621371192,
            NSLocalizedString(@"miles",nil)];
}

- (NSString *)veritcalAccuracyByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kAccUnitsKey];
    
    switch ([defaultsValue intValue]) {
        case 1:
            return [self verticalAccuracyInKilometres];
            break;
        case 2:
            return [self verticalAccuracyInFeet];
            break;
        case 3:
            return [self verticalAccuracyInMiles];
            break;
        default:
            return [self verticalAccuracyInMeters];
            break;
    }
}



    //horizontal accuracy

- (NSString *)horizontalAccuracyInMeters {
    
    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        
        return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    }
    return [NSString stringWithFormat:@"%.2f m",self.locationManager.location.horizontalAccuracy];
}

- (NSString *)horizontalAccuracyInKilometres {

    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        
        return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    }
    return [NSString stringWithFormat:@"%.3f Km",self.locationManager.location.horizontalAccuracy * 0.001];
}

- (NSString *)horizontalAccuracyInFeet {
    
    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        
        return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    }
    return [NSString stringWithFormat:@"%.2f %@",
            self.locationManager.location.horizontalAccuracy * 3.28083,
            NSLocalizedString(@"ft",nil)];
}

- (NSString *)horizontalAccuracyInMiles {
    
    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        
        return NSLocalizedString(@"Updating...",@"Aktualizujem...");
    }
    return [NSString stringWithFormat:@"%.4f %@",
            self.locationManager.location.horizontalAccuracy * 0.000621371192,
            NSLocalizedString(@"miles",nil)];
}

- (NSString *)horizontalAccuracyByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kAccUnitsKey];
    
    switch ([defaultsValue intValue]) {
        case 1:
            return [self horizontalAccuracyInKilometres];
            break;
        case 2:
            return [self horizontalAccuracyInFeet];
            break;
        case 3:
            return [self horizontalAccuracyInMiles];
            break;
        default:
            return [self horizontalAccuracyInMeters];
            break;
    }
    
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
        
        if (oldLocation.verticalAccuracy != newLocation.verticalAccuracy) {
            if ([[self delegate] respondsToSelector:@selector(locationProviderDidUpdateVerticalAccuracy)]) {
                [[self delegate] locationProviderDidUpdateVerticalAccuracy];
            }
        }
        
        if (oldLocation.horizontalAccuracy != newLocation.horizontalAccuracy) {
            if ([[self delegate] respondsToSelector:@selector(locationProviderDidUpdateHorizontalAccuracy)]) {
                [[self delegate] locationProviderDidUpdateHorizontalAccuracy];
            }
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  
    if (self.currentHeading.trueHeading != newHeading.trueHeading) {
        
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [locationManager release];
    [delegate release];
    [super dealloc];
}

@end
