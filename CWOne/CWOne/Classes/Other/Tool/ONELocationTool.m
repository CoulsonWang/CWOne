//
//  ONELocationTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONELocationTool.h"

static ONELocationTool *_instance;

@interface ONELocationTool () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) void (^completion)(NSString *);

@end

@implementation ONELocationTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ONELocationTool alloc] init];
    });
    return _instance;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _locationManager = locationManager;
    }
    return _locationManager;
}

- (void)requestLocationAndGetCityNameWithCompletion:(void (^)(NSString *))completion {
    self.completion = completion;
    CLAuthorizationStatus status = [ONEAuthorizationTool getCurrentLocationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self.locationManager requestWhenInUseAuthorization];
        });
        completion(nil);
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager requestLocation];
    } else {
        completion(nil);
    }
    
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (self.completion) {
        if (locations.count == 0) {
            self.completion(nil);
        } else {
            CLLocation *location = locations.firstObject;
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (!error) {
                    if (placemarks.count == 0) {
                        self.completion(nil);
                    } else {
                        CLPlacemark *placeMark = placemarks.firstObject;
                        NSString *cityName = placeMark.locality;
                        if (!cityName) {
                            cityName = placeMark.administrativeArea;
                        }
                        self.completion(cityName);
                    }
                } else {
                    self.completion(nil);
                }
            }];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}
@end
