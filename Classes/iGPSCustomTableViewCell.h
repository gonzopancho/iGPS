//
//  iGPSCustomTableViewCell.h
//  iGPS
//
//  Created by Jakub Petrík on 12/29/10.
//  Copyright 2011 Jakub Petrík. All rights reserved.
//

#import <UIKit/UIKit.h>

//  Trieda iGPSCustomTableViewCell
//  vlastna bundka tabulky
@interface iGPSCustomTableViewCell : UITableViewCell {
    

}

//  Hlavny text bunky
@property (nonatomic, retain) IBOutlet UILabel *mainText;

//  Vedlasi text bunky
@property (nonatomic, retain) IBOutlet UILabel *detailText;

//  Metody nastavia hlavny a vedlajsi text bunky
- (void)setMainTextLabel:(NSString *)newMainText;
- (void)setDetailTextLabel:(NSString *)newDetailText;

@end
