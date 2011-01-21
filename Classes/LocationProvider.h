//
//  LocationProvider.h
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 11/23/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol LocationProviderDelegate <NSObject>
@required
- (void)locationProviderDidUpdateLocation;
@optional
- (void)locationProviderDidUpdateLatitude;
- (void)locationProviderDidUpdateLongitude;
- (void)locationProviderDidUpdateAltitude;
- (void)locationProviderDidUpdateSpeed;
- (void)locationProviderDidUpdateCourse;
- (void)locationProviderDidUpdateHeading;
- (void)locationProviderDidUpdateHorizontalAccuracy;
- (void)locationProviderDidUpdateVerticalAccuracy;
@end

@interface LocationProvider : NSObject <CLLocationManagerDelegate>  {

}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLHeading *currentHeading;
@property (nonatomic, retain) id <LocationProviderDelegate> delegate;

@property (nonatomic, assign) BOOL isSpeedValid;
@property (nonatomic, assign) BOOL isHeadingValid;



- (id)init;

- (void)startUpdatingLocationAndHeading;
- (void)stopUpdatingLocationAndHeading;
- (void)startUpdatingHeading;
- (void)stopUpdatingHeading;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)setAccuracy:(int)newAccuracy;
- (void)setDistanceFilter:(int)newFilter;

- (NSString *)latitudeInDegDec;
- (NSString *)latitudeInDMS;
- (NSString *)longitudeInDegDec;
- (NSString *)longitudeInDMS;

- (NSString *)altitudeInMetres;
- (NSString *)altitudeInKilometres;
- (NSString *)altitudeInFeet;
- (NSString *)altitudeInMiles;

- (NSString *)speedInKilometersPerHour;
- (NSString *)speedInMetresPerSecond;
- (NSString *)speedInMilesPerHour;
- (NSString *)speedInKnots;
- (NSString *)speedInFeetPerSecond;

- (NSString *)magneticHeading;
- (NSString *)trueHeading;

- (NSString *)courseInDegrees;
- (NSString *)courseMixed;

- (NSString *)verticalAccuracyInMeters;
- (NSString *)verticalAccuracyInKilometres;
- (NSString *)verticalAccuracyInFeet;
- (NSString *)verticalAccuracyInMiles;

- (NSString *)horizontalAccuracyInMeters;
- (NSString *)horizontalAccuracyInKilometres;
- (NSString *)horizontalAccuracyInFeet;
- (NSString *)horizontalAccuracyInMiles;

    //setAccuracy
    //setDistanceFilter
    //poriesit zobrazenie priznaku aktualizovania

@end


