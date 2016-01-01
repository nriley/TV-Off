//
//  TOViewController.m
//  TV Off
//
//  Created by Nicholas Riley on 1/1/16.
//  Copyright © 2016 Nicholas Riley. All rights reserved.
//

#import "TOViewController.h"

@interface UIApplication (Private)
- (void)terminateWithSuccess;
@end

@implementation TOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnOffTV) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)turnOffTV {
    [self.spinner startAnimating];
    self.statusLabel.text = @"Turning off…";
    
    NSURLSessionTask *shutDownActivityTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://redeye.hpn.sabi.net:8080/redeye/rooms/0/activities/launch?activityId=-1"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.statusLabel.text = @"";
            if (((NSHTTPURLResponse *)response).statusCode == 200) {
                [[UIApplication sharedApplication] terminateWithSuccess];
            } else {
                [self reportFailure:response.description];
            }
        });
    }];

    // artificial delay so we appear to be doing something
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shutDownActivityTask resume];
    });
}

- (void)reportFailure:(NSString *)failureMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to turn off TV" message:failureMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self turnOffTV];
        });
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] terminateWithSuccess];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
