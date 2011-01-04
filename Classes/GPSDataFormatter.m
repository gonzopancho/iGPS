//
//  GPSDataFormatter.m
//  CoreLocationUkazka
//
//  Created by Jakub Petrík on 12/21/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import "GPSDataFormatter.h"


@implementation GPSDataFormatter

+ (NSString *)degreeStringFromDecimal:(float)number {
    
    int degrees = number;
    number = (number - degrees) * 60;
    int minutes = number;
    int seconds = (number - minutes) * 60;
    
    return [NSString stringWithFormat:@"%d˚%d'%d\"",degrees,minutes,seconds];
    
}

+ (NSString *)latitudeInDMS:(float)number {
   
    if (number < 0) return [NSString stringWithFormat:@"%@ %@",[self degreeStringFromDecimal:number * -1.],NSLocalizedString(@"S",@"Juh")];
    else return [NSString stringWithFormat:@"%@ %@",[self degreeStringFromDecimal:number],NSLocalizedString(@"N",@"Sever")];
}

+ (NSString *)longitudeInDMS:(float)number {
    
        
    if (number < 0) return [NSString stringWithFormat:@"%@ %@",[self degreeStringFromDecimal:number * -1.],NSLocalizedString(@"W",@"Západ")];
    else return [NSString stringWithFormat:@"%@ %@",[self degreeStringFromDecimal:number],NSLocalizedString(@"E",@"Východ")];    
}

+ (NSString *)textValueFromDictionary:(NSDictionary *)dict {
    
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:[dict objectForKey:@"Key"]];
   
    return [[dict objectForKey:@"Titles"] objectAtIndex:[index intValue]];    
}

+ (UISlider *)sliderFromDictionary:(NSDictionary *)dict {
    
    UISlider *slider = [[[UISlider alloc] initWithFrame:CGRectMake(0, 0, 280, 23)] autorelease];
    
    NSNumber *max = [dict objectForKey:@"MaximumValue"];
    NSNumber *min = [dict objectForKey:@"MinimumValue"];
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"distance"];
    
    slider.maximumValue = [max floatValue];
    slider.minimumValue = [min floatValue];
    
    slider.value = [value floatValue];
    
    return slider;
}

@end
