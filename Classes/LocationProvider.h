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

@property (nonatomic, retain) id <LocationProviderDelegate> delegate;



- (id)init;
- (void)setupLocationManager;

- (void)startUpdatingLocationAndHeading;
- (void)stopUpdatingLocationAndHeading;
- (void)startUpdatingHeading;
- (void)stopUpdatingHeading;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)setAccuracy:(id)newAccuracy;
- (void)setDistanceFilter:(id)newFilter;

- (void)updateDefaults:(NSNotification *)aNotification;

- (NSString *)convertLatitudeToDMS:(float)latitude;
- (NSString *)latitudeInDegDec;
- (NSString *)latitudeInDMS;
- (NSString *)latitudeByUserDefaults;

- (NSString *)convertLongitudeToDMS:(float)longitude;
- (NSString *)longitudeInDegDec;
- (NSString *)longitudeInDMS;
- (NSString *)longitudeByUserDefaults;

- (NSString *)altitudeInMetres;
- (NSString *)altitudeInKilometres;
- (NSString *)altitudeInFeet;
- (NSString *)altitudeInMiles;
- (NSString *)altitudeByUserDefaults;

- (NSString *)speedInKilometersPerHour;
- (NSString *)speedInMetresPerSecond;
- (NSString *)speedInMilesPerHour;
- (NSString *)speedInKnots;
- (NSString *)speedInFeetPerSecond;
- (NSString *)speedByUserDefaults;

- (NSString *)magneticHeading;
- (NSString *)trueHeading;
- (NSString *)headingByUserDefaults;

- (NSString *)courseInDegrees;
- (NSString *)courseMixed;
- (NSString *)courseByUserDefaults;

- (NSString *)verticalAccuracyInMeters;
- (NSString *)verticalAccuracyInKilometres;
- (NSString *)verticalAccuracyInFeet;
- (NSString *)verticalAccuracyInMiles;
- (NSString *)veritcalAccuracyByUserDefaults;

- (NSString *)horizontalAccuracyInMeters;
- (NSString *)horizontalAccuracyInKilometres;
- (NSString *)horizontalAccuracyInFeet;
- (NSString *)horizontalAccuracyInMiles;
- (NSString *)horizontalAccuracyByUserDefaults;

@end


