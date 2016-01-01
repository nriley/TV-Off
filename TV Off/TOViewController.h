//
//  TOViewController.h
//  TV Off
//
//  Created by Nicholas Riley on 1/1/16.
//  Copyright © 2016 Nicholas Riley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)turnOffTV;

@end

