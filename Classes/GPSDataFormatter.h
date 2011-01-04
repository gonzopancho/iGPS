//
//  GPSDataFormatter.h
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 12/21/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GPSDataFormatter : NSObject {

}

+ (NSString *)degreeStringFromDecimal:(float)number;
+ (NSString *)latitudeInDMS:(float)number;
+ (NSString *)longitudeInDMS:(float)number;

+ (NSString *)textValueFromDictionary:(NSDictionary *)dict;
+ (UISlider *)sliderFromDictionary:(NSDictionary *)dict;

@end
