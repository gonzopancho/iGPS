//
//  LocationProvider.m
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 11/23/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "LocationProvider.h"
#import "Constants.h"

//  Prevody medzi jednotlivymi jednotkami
#define M_TO_KM_RATIO 0.001
#define M_TO_FEET_RATIO 3.28083
#define M_TO_MILES_RATIO 0.000621371192
#define MS_TO_KMH_RATIO 3.6
#define MS_TO_MPH_RATIO 2.2369362920544
#define MS_TO_KT_RATIO 1.9438612860586
#define MS_TO_FPSEC_RATIO 3.28084


//  Lokalizovane retazce
#define kLSInvalid NSLocalizedString(@"Invalid",nil)

#define kLSNorth NSLocalizedString(@"N",nil)
#define kLSNorthEast NSLocalizedString(@"NE",nil)
#define kLSNorthWest NSLocalizedString(@"NW",nil)
#define kLSEast NSLocalizedString(@"E",nil)
#define kLSSouth NSLocalizedString(@"S",nil)
#define kLSSouthEast NSLocalizedString(@"SE",nil)
#define kLSSouthWest NSLocalizedString(@"SW",nil)
#define kLSWest NSLocalizedString(@"W",nil)

#define kLSAboveSeaLevel NSLocalizedString(@"above sea level",nil)
#define kLSBelowSeaLevel NSLocalizedString(@"below sea level",nil)

#define kLSFoots NSLocalizedString(@"ft",nil)
#define kLSMiles NSLocalizedString(@"miles",nil)

//  Sukromne atributy a metody
@interface LocationProvider ()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLHeading *currentHeading;
@property (retain) NSDictionary *userDefaultsValues;
@property (nonatomic, assign) BOOL isHeadingValid;

@end



//  Implementacia triedy
@implementation LocationProvider

//  Automaticky generovane metod accessorov
@synthesize locationManager;
@synthesize userDefaultsValues;
@synthesize currentHeading;
@synthesize delegate;
@synthesize isHeadingValid;


#pragma mark -
#pragma mark Initialization


- (void)setupUserDefaultsValues {
    
    
    //nacitanie hodnot
    NSNumber *speed    = [[NSUserDefaults standardUserDefaults] objectForKey:kSpeedKey];
    NSNumber *accuracy = [[NSUserDefaults standardUserDefaults] objectForKey:kAccuracyKey];
    NSNumber *accUnits = [[NSUserDefaults standardUserDefaults] objectForKey:kAccUnitsKey];
    NSNumber *altitude = [[NSUserDefaults standardUserDefaults] objectForKey:kAltitudeKey];
    NSNumber *north    = [[NSUserDefaults standardUserDefaults] objectForKey:kNorthKey];
    NSNumber *distance = [[NSUserDefaults standardUserDefaults] objectForKey:kDistanceKey];
    NSNumber *course   = [[NSUserDefaults standardUserDefaults] objectForKey:kCourseKey];
    NSNumber *coords   = [[NSUserDefaults standardUserDefaults] objectForKey:kCoordsKey];
    
    //vytvorenie slovnika a priradenie atributu userDefaultsValue
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

//  Metoda prostrednictom predaneho selektoru uskutocni metodu predanu ako hodnotu selektora
- (void)notifyDelegateWithSelector:(SEL)aSelector {
    
    //  ak rozumnie delegat metode, metoda sa vykona
    if ([[self delegate] respondsToSelector:aSelector]) {
        [[self delegate] performSelector:aSelector];
    }
}

- (void)defaultsChanged:(NSNotification *)aNotification {
    
    //  slovnikova reprezentacia objektu spravy - uzivatelkskym nastaveniam
    NSDictionary *dict = [[aNotification object] dictionaryRepresentation];
    
    
    //  skontroluje hodnoty pre pre dane kluce.
    //  pri zisteni zmeny aktualizuje userDefaultsValues a upozorni delegata o vykonanej zmene
    if (![[dict objectForKey:kSpeedKey] isEqualToNumber:[self.userDefaultsValues objectForKey:kSpeedKey]]) {
        
        [self updateDefaults:[NSNotification notificationWithName:kSpeedKey object:[dict objectForKey:kSpeedKey]]];
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateSpeed)];
        
    }
    if (![[dict objectForKey:kAccuracyKey] isEqualToNumber:[self.userDefaultsValues objectForKey:kAccuracyKey]]) {
        
        [self updateDefaults:[NSNotification notificationWithName:kAccuracyKey object:[dict objectForKey:kAccuracyKey]]];

    }
    if (![[dict objectForKey:kAccUnitsKey] isEqualToNumber:[self.userDefaultsValues objectForKey:kAccUnitsKey]]) {
        
        [self updateDefaults:[NSNotification notificationWithName:kAccUnitsKey object:[dict objectForKey:kAccUnitsKey]]];
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateHorizontalAccuracy)];
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateVerticalAccuracy)];
        
    }
    if (![[dict objectForKey:kAltitudeKey] isEqualToNumber:[self.userDefaultsValues objectForKey:kAltitudeKey]]) {
        
        [self updateDefaults:[NSNotification notificationWithName:kAltitudeKey object:[dict objectForKey:kAltitudeKey]]];
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateAltitude)];
        
    }
    if (![[dict objectForKey:kNorthKey] isEqualToNumber:[self.userDefaultsValues objectForKey:kNorthKey]]) {
        
        [self updateDefaults:[NSNotification notificationWithName:kNorthKey object:[dict objectForKey:kNorthKey]]];
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateHeading)];

    }
    if (![[dict objectForKey:kDistanceKey] isEqualToNumber:[self.userDefaultsValues objectForKey:kDistanceKey]]) {
        
        [self updateDefaults:[NSNotification notificationWithName:kDistanceKey object:[dict objectForKey:kDistanceKey]]];

    }
    if (![[dict objectForKey:kCourseKey] isEqualToNumber:[self.userDefaultsValues objectForKey:kCourseKey]]) {
        
        [self updateDefaults:[NSNotification notificationWithName:kCourseKey object:[dict objectForKey:kCourseKey]]];
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateCourse)];

    }
    if (![[dict objectForKey:kCoordsKey] isEqualToNumber:[self.userDefaultsValues objectForKey:kCoordsKey]]) {
        
        [self updateDefaults:[NSNotification notificationWithName:kCoordsKey object:[dict objectForKey:kCoordsKey]]];
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateLatitude)];
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateLongitude)];

    }
    
}

//  Metoda nastavi KVO
- (void)setupKeyValueObserverving {
    
    //  Na zmenu presnosti
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accuracyChanged:)
                                                 name:kAccuracyKey
                                               object:nil];
    
    //  Na zmenu filtra vzdialenosti
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(distanceFilterChanged:) 
                                                 name:kDistanceKey
                                               object:nil];
    
    //  Na ostatne zmeny v nastaveniach
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];    
    
}

//  Konstruktor.
- (id)init {
    
    if ((self = [super init])) {

        [self setupUserDefaultsValues];
        [self setupKeyValueObserverving];
        [self setupLocationManager];
        
    }
    return self;
}

//  Metoda nastavi location managera.
- (void)setupLocationManager {
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    // urci delegata
    self.locationManager.delegate = self;
    
    // nastav presnost podla hodnoty userDefaultsValues
    [self setAccuracy:[self.userDefaultsValues objectForKey:kAccuracyKey]];
    
    // nastav filter vzdialenosti podla hodnoty userDefaultsValues
    [self setDistanceFilter:[self.userDefaultsValues objectForKey:kDistanceKey]];
}


// Metoda vracia BOOL YES ak je cislo vacsie ako 0, inak BOOL NO.
- (BOOL)isDoubleValid:(double)value {
    
    return (value >= 0);
}

// Metoda prevedie cislo na stupne, minuty a sekundy a vrati ho ako retazec
- (NSString *)degreeStringFromDecimal:(float)number {
    
    int degrees = number;
    number = (number - degrees) * 60;
    int minutes = number;
    int seconds = (number - minutes) * 60;
    
    return [NSString stringWithFormat:@"%d˚%d'%d\"",degrees,minutes,seconds];
    
}


#pragma mark -
#pragma mark LocationProvider life cycle


//  Aktualizuje slovnik userDefaultsValues
- (void)updateDefaults:(NSNotification *)aNotification {
    
    NSMutableDictionary * newDefaults = [NSMutableDictionary dictionary];
    
    if (self.userDefaultsValues) {
        newDefaults = [self.userDefaultsValues mutableCopy];
    } 
    
    [newDefaults setObject:[aNotification object] forKey:[aNotification name]];
    

    self.userDefaultsValues = newDefaults;
    [newDefaults release];
    
}

//  Nastavi novozvolenu pozadovanu presnost pomocou notifikacie predanej ako argument.
- (void)accuracyChanged:(NSNotification *)aNotification {
    
    [self setAccuracy:[aNotification object]];
            NSLog(@"accuracy set");

}

//  Nastavi novozvoleny filter vzdialenosti pomocou notifikacie predanej ako argument.
- (void)distanceFilterChanged:(NSNotification *)aNotification {
    
    [self setDistanceFilter:[aNotification object]];
            NSLog(@"distanceFilter set");
    
}

// Podla novej hodnoty nastavi pozadovanu presnost atributu locationManager.
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

// Podla novej hodnoty nastavi filter vzdialenosti atributu locationManager.
- (void)setDistanceFilter:(id)newFilter {
    
    if ([newFilter isKindOfClass:[NSNumber class]]) {
        NSNumber *distanceFilter = newFilter;
        
        switch ([distanceFilter intValue]) {
            case 1:
                self.locationManager.distanceFilter = 50;
                break;
            case 2:
                self.locationManager.distanceFilter = 100;
                break;
            case 3:
                self.locationManager.distanceFilter = 150;
                break;
            case 4:
                self.locationManager.distanceFilter = 300;
                break;
            case 5:
                self.locationManager.distanceFilter = 500;
                break;
            case 6:
                self.locationManager.distanceFilter = 700;
                break;
            case 7:
                self.locationManager.distanceFilter = 1000;
                break;
            case 8:
                self.locationManager.distanceFilter = 1500;
                break;
            case 9:
                self.locationManager.distanceFilter = 2000;
                break;
            case 10:
                self.locationManager.distanceFilter = 2500;
                break;
            case 11:
                self.locationManager.distanceFilter = 3000;
                break;
            default:
                self.locationManager.distanceFilter = 10;
                break;
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

- (NSString *)convertLatitudeToDMS:(float)latitude {
    
    if (latitude < 0) return [NSString stringWithFormat:@"%@ %@",[self degreeStringFromDecimal:fabs(latitude)],kLSSouth];
    return [NSString stringWithFormat:@"%@ %@",[self degreeStringFromDecimal:latitude],kLSNorth];
}

- (NSString *)latitudeInDegDec {
    
    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        return kLSInvalid; 
    }
    return [NSString stringWithFormat:@"%f˚",self.locationManager.location.coordinate.latitude];
}

- (NSString *)latitudeInDMS {
    
    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        return kLSInvalid;
    }
    
    return [NSString stringWithFormat:@"%@",[self convertLatitudeToDMS:self.locationManager.location.coordinate.latitude]];   
}

- (NSString *)latitudeByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kCoordsKey];
    
    if ([defaultsValue intValue] == 0) return [self latitudeInDMS];
    
    return [self latitudeInDegDec];
}


    //Longitude

- (NSString *)convertLongitudeToDMS:(float)longitude {
    
    if (longitude < 0) return [NSString stringWithFormat:@"%@ %@",[self degreeStringFromDecimal:fabs(longitude)],kLSWest];
    return [NSString stringWithFormat:@"%@ %@",[self degreeStringFromDecimal:longitude],kLSEast];    
}

- (NSString *)longitudeInDegDec {
    return [NSString stringWithFormat:@"%f˚",self.locationManager.location.coordinate.longitude];
}

- (NSString *)longitudeInDMS {
    return [NSString stringWithFormat:@"%@",[self convertLongitudeToDMS:self.locationManager.location.coordinate.longitude]];
}

- (NSString *)longitudeByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kCoordsKey];
    
    if ([defaultsValue intValue] == 0) return [self longitudeInDMS];
    
    return [self longitudeInDegDec];
}


    //Altitude

- (int)altitudeBelowSeaLevel:(double)altitude {
    
    if (altitude < 0) {
        return -1;
    }
    if (altitude > 0) {
        return 1;
    }
    return 0;
    
}

- (NSString *)altitudeInMetres {
    
    double altitude = self.locationManager.location.altitude;
    
    switch ([self altitudeBelowSeaLevel:self.locationManager.location.altitude]) {
        case 1:
            return [NSString stringWithFormat:@"%.3f m %@",altitude,kLSAboveSeaLevel];
            break;
        case -1:
            return [NSString stringWithFormat:@"%.3f m %@",fabs(altitude),kLSBelowSeaLevel];
            break;
        default:
            return kLSInvalid;
            break;
    }

}

- (NSString *)altitudeInKilometres {
    
    double altitude = self.locationManager.location.altitude;
    
    switch ([self altitudeBelowSeaLevel:altitude]) {
        case 1:
            return [NSString stringWithFormat:@"%.3f km %@",altitude * M_TO_KM_RATIO,kLSAboveSeaLevel];
            break;
        case -1:
            return [NSString stringWithFormat:@"%.3f km %@",fabs(altitude) * M_TO_KM_RATIO,kLSBelowSeaLevel];
            break;
        default:
            return kLSInvalid;
            break;
    }
    
    return [NSString stringWithFormat:@"%.3f km",self.locationManager.location.altitude * M_TO_KM_RATIO];
}

- (NSString *)altitudeInFeet {
    
    double altitude = self.locationManager.location.altitude;
    
    switch ([self altitudeBelowSeaLevel:altitude]) {
        case 1:
            return [NSString stringWithFormat:@"%.3f %@ %@",altitude * M_TO_FEET_RATIO,kLSFoots,kLSAboveSeaLevel]; 
            break;
        case -1:
            return [NSString stringWithFormat:@"%.3f %@ %@",fabs(altitude) * M_TO_FEET_RATIO,kLSFoots,kLSBelowSeaLevel]; 
            break;
        default:
            return kLSInvalid;
            break;
    }
    
}

- (NSString *)altitudeInMiles {
    
    double altitude = self.locationManager.location.altitude;
    
    switch ([self altitudeBelowSeaLevel:altitude]) {
        case 1:
            return [NSString stringWithFormat:@"%.4f %@ %@",altitude * M_TO_MILES_RATIO,kLSMiles,kLSAboveSeaLevel];
            break;
        case -1:
            return [NSString stringWithFormat:@"%.4f %@ %@",fabs(altitude) * M_TO_MILES_RATIO,kLSMiles,kLSBelowSeaLevel];
            break;
        default:
            return kLSInvalid;
            break;
    }
    
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
   
    if (![self isDoubleValid:self.locationManager.location.speed]) return kLSInvalid;
    return [NSString stringWithFormat:@"%.2f m/s",self.locationManager.location.speed];
}

- (NSString *)speedInKilometersPerHour {
    
    if (![self isDoubleValid:self.locationManager.location.speed]) return kLSInvalid;
    return [NSString stringWithFormat:@"%.2f km/h",self.locationManager.location.speed * MS_TO_KMH_RATIO];
}

- (NSString *)speedInMilesPerHour {
    
    if (![self isDoubleValid:self.locationManager.location.speed]) return kLSInvalid;
    return [NSString stringWithFormat:@"%.2f mph",self.locationManager.location.speed * MS_TO_MPH_RATIO];
}

- (NSString *)speedInKnots {
    
    if (![self isDoubleValid:self.locationManager.location.speed]) return kLSInvalid;
    return [NSString stringWithFormat:@"%.2f %@",self.locationManager.location.speed * MS_TO_KT_RATIO,
            NSLocalizedString(@"knots",nil)];
}

- (NSString *)speedInFeetPerSecond {
    
    if (![self isDoubleValid:self.locationManager.location.speed]) return kLSInvalid;
    return [NSString stringWithFormat:@"%.2f ft/s",self.locationManager.location.speed * MS_TO_FPSEC_RATIO];
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

    double degreesValue = degrees;
    
    switch ([self orientationFromDegrees:degreesValue]) {
        case 1:
            return [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,kLSNorth];
            break;
        case 2:
            return [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,kLSNorthEast];
            break;
        case 3:
            return [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,kLSEast];
            break;
        case 4:
            return [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,kLSSouthEast];
            break;
        case 5:
            return [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,kLSSouth];
            break;
        case 6:
            return [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,kLSSouthWest];
            break;
        case 7:
            return [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,kLSWest];
            break;
        case 8:
            return [NSString stringWithFormat:@"%.1f˚ %@",degreesValue,kLSNorthWest];
            break;
        default:
            return [NSString stringWithFormat:@"%.1f˚",degreesValue];
            break;
    }
    
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
    }
    return kLSInvalid;
    
}

- (NSString *)courseMixed {
    
    double courseDegrees = self.locationManager.location.course;
    
    if ([self isDoubleValid:courseDegrees]) return [self stringFromDegrees:courseDegrees];
    
    return kLSInvalid;
}

- (NSString *)courseByUserDefaults {
    
    NSNumber *defaultsValue = (NSNumber *)[self.userDefaultsValues objectForKey:kCourseKey];
    
    if ([defaultsValue intValue] == 0) return [self courseInDegrees];
    
    return [self courseMixed];
    
}

    //vertical accuracy

- (NSString *)verticalAccuracyInMeters {
    
    if (![self isDoubleValid:self.locationManager.location.verticalAccuracy]) {
        
        return kLSInvalid;
    }
    return [NSString stringWithFormat:@"%.2f m",self.locationManager.location.verticalAccuracy];
}


- (NSString *)verticalAccuracyInKilometres {

    if (![self isDoubleValid:self.locationManager.location.verticalAccuracy]) {
        
        return kLSInvalid;
    }
    return [NSString stringWithFormat:@"%.3f Km",self.locationManager.location.verticalAccuracy * M_TO_KM_RATIO];
}


- (NSString *)verticalAccuracyInFeet {
    
    if (![self isDoubleValid:self.locationManager.location.verticalAccuracy]) {
        
        return kLSInvalid;
    }
    return [NSString stringWithFormat:@"%.2f %@",
            self.locationManager.location.verticalAccuracy * M_TO_FEET_RATIO,
            kLSFoots];
}


- (NSString *)verticalAccuracyInMiles {
    
    if (![self isDoubleValid:self.locationManager.location.verticalAccuracy]) {
        
        return kLSInvalid;
    }
    return [NSString stringWithFormat:@"%.4f %@",
            self.locationManager.location.verticalAccuracy * M_TO_MILES_RATIO,
            kLSMiles];
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
        
        return kLSInvalid;
    }
    return [NSString stringWithFormat:@"%.2f m",self.locationManager.location.horizontalAccuracy];
}

- (NSString *)horizontalAccuracyInKilometres {

    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        
        return kLSInvalid;
    }
    return [NSString stringWithFormat:@"%.3f Km",self.locationManager.location.horizontalAccuracy * M_TO_KM_RATIO];
}

- (NSString *)horizontalAccuracyInFeet {
    
    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        
        return kLSInvalid;
    }
    return [NSString stringWithFormat:@"%.2f %@",
            self.locationManager.location.horizontalAccuracy * M_TO_FEET_RATIO,
            kLSFoots];
}

- (NSString *)horizontalAccuracyInMiles {
    
    if (![self isDoubleValid:self.locationManager.location.horizontalAccuracy]) {
        
        return kLSInvalid;
    }
    return [NSString stringWithFormat:@"%.4f %@",
            self.locationManager.location.horizontalAccuracy * M_TO_MILES_RATIO,
            kLSMiles];
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
            
            [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateLatitude)];
        }
        
        if (oldLocation.coordinate.longitude != newLocation.coordinate.longitude) {
            
            [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateLongitude)];
        }
        
        if (oldLocation.altitude != newLocation.altitude) {
            
            [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateAltitude)];
        }
        
        if (oldLocation.speed != newLocation.speed) {
            
            [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateSpeed)];
        }
        
        if (oldLocation.course != newLocation.course) {
            
            [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateCourse)];            
        }
        
        if (oldLocation.verticalAccuracy != newLocation.verticalAccuracy) {
            
            [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateVerticalAccuracy)];
        }
        
        if (oldLocation.horizontalAccuracy != newLocation.horizontalAccuracy) {
            
            [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateHorizontalAccuracy)];
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  
    if (self.currentHeading.trueHeading != newHeading.trueHeading) {
        
        self.currentHeading = newHeading;
        isHeadingValid = YES;
        
        [self notifyDelegateWithSelector:@selector(locationProviderDidUpdateHeading)];
        
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
