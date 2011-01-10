//
//  main.m
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2010 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>

    //#undef NSLocalizedString
    //#define NSLocalizedString(key, comment) MyLocalizedStringFunction(key)

/*void MyLocalizedStringFunction(NSString *key){
    
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *language = [languages objectAtIndex:0];
    NSBundle *bundle = [NSBundle bundleWithIdentifier:[NSString stringWithFormat:@"%@.lproj",language]];
    [bundle localizedStringForKey:key value:nil table:nil];
    
}
*/
int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
