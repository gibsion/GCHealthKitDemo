//
//  GCHealthManager.m
//  GCHealthKitDemo
//
//  Created by APPLE on 2017/2/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import "GCHealthManager.h"
#import <UIKit/UIKit.h>
@interface GCHealthManager ()

@property (strong, nonatomic) HKHealthStore *healthStore;

@end

@implementation GCHealthManager

+(instancetype)shareManager {
    static GCHealthManager *gcHealthManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!gcHealthManager) {
            gcHealthManager = [GCHealthManager new];
            gcHealthManager.healthStore = [[HKHealthStore alloc] init];
        }
    });
    
    return gcHealthManager;
}

-(void)requestAuthorized:(void (^)(BOOL success, NSError * _Nullable error))completion {
    HKObjectType *objHeightType = [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierHeight];
    HKObjectType *objBodyMassType = [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierBodyMass];
    HKObjectType *objStepCountType = [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierStepCount];
    HKObjectType *objwalkingRunningType = [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKObjectType *objCyclingType = [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceCycling];
    
    NSSet *readTypes = [NSSet setWithObjects: objHeightType, objBodyMassType, objStepCountType, objwalkingRunningType, objCyclingType, nil];
    NSSet *writeTypes = [NSSet setWithObjects: objHeightType, objBodyMassType, objStepCountType, objwalkingRunningType, objCyclingType, nil];
    [self.healthStore requestAuthorizationToShareTypes: writeTypes readTypes: readTypes completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@" 请求健康授权成功!");
        } else {
            NSLog(@" 请求健康授权失败:%@", error);
        }
        
        if (completion) {
            completion(success, error);
        }
    }];
}


-(void)getStepCountWithstartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate completeHandle: (void (^)(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error))completion{
    HKSampleType *stepCountType = [HKSampleType quantityTypeForIdentifier: HKQuantityTypeIdentifierStepCount];
    NSPredicate *preicate = [HKQuery predicateForSamplesWithStartDate: startDate endDate: endDate options: HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDesctiptor = [NSSortDescriptor sortDescriptorWithKey: HKSampleSortIdentifierStartDate ascending: YES];
    HKSampleQuery *samplequery = [[HKSampleQuery alloc] initWithSampleType: stepCountType
                                                                predicate: preicate
                                                                    limit: HKObjectQueryNoLimit
                                                          sortDescriptors: @[sortDesctiptor]
                                                            resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                                                if (completion) {
                                                                    completion(query, results, error);
                                                                }
    }];
    
    [self.healthStore executeQuery: samplequery];
}

-(void)getDistanceWalkingRunningWithstartDate:(NSDate *)startDate
                                   andEndDate:(NSDate *)endDate
                               completeHandle: (void (^)(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error))completion {
    HKSampleType *walkingRunningType = [HKSampleType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSPredicate *preicate = [HKQuery predicateForSamplesWithStartDate: startDate endDate: endDate options: HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDesctiptor = [NSSortDescriptor sortDescriptorWithKey: HKSampleSortIdentifierStartDate ascending: YES];
    HKSampleQuery *samplequery = [[HKSampleQuery alloc] initWithSampleType: walkingRunningType
                                                                 predicate: preicate
                                                                     limit: HKObjectQueryNoLimit
                                                           sortDescriptors: @[sortDesctiptor]
                                                            resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                                                if (completion) {
                                                                    completion(query, results, error);
                                                                }
                                                            }];
    
    [self.healthStore executeQuery: samplequery];
}


-(void)getDistanceCyclingWithstartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate completeHandle: (void (^)(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error))completion{
    HKSampleType *distanceCyclingType = [HKSampleType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceCycling];
    NSPredicate *preicate = [HKQuery predicateForSamplesWithStartDate: startDate endDate: endDate options: HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDesctiptor = [NSSortDescriptor sortDescriptorWithKey: HKSampleSortIdentifierStartDate ascending: YES];
    HKSampleQuery *samplequery = [[HKSampleQuery alloc] initWithSampleType: distanceCyclingType
                                                                 predicate: preicate
                                                                     limit: HKObjectQueryNoLimit
                                                           sortDescriptors: @[sortDesctiptor]
                                                            resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                                                                if (completion) {
                                                                    completion(query, results, error);
                                                                }
                                                            }];
    
    [self.healthStore executeQuery: samplequery];
}

-(void)insertStepCount:(double) stepCount withStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    [self getStepCountWithstartDate: startDate andEndDate: endDate completeHandle:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (!error && results) {
            NSPredicate *predicate =[HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
            HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierStepCount];
            HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
                HKQuantity *sum = [result sumQuantity];
                double newStep = stepCount;//sum ? stepCount - [sum doubleValueForUnit: [HKUnit countUnit]] : stepCount;
                HKQuantitySample *stepCountSample = [self correlationSampleWithData: newStep startDate: startDate andEndDate: endDate forQuantityType:quantityType unit: [HKUnit countUnit]];
                [self.healthStore saveObject: stepCountSample withCompletion:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        NSLog(@"添加步数%g成功", newStep);
                    } else {
                        NSLog(@"添加步数%g失败", newStep);
                    }
                }];
            }];
            
            [self.healthStore executeQuery: query];
        }
    }];
}

-(void)addDistanceCyclingData:(double)distance withStartDate:(NSDate *)startDate andEndDate:(NSDate *) endDate{
    [self getDistanceCyclingWithstartDate: startDate andEndDate: endDate completeHandle:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (!error && results) {
            double historyDistance =  0;
            for (NSInteger i = 0; i < results.count; i++) {
                HKQuantitySample *sample = results[i];
                historyDistance += [sample.quantity doubleValueForUnit: [HKUnit meterUnit]];
            }
            
            double tmpDistance = distance > historyDistance ? (distance - historyDistance) : distance;
            HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceCycling];
            HKQuantitySample *distanceCyclingSample = [self correlationSampleWithData: distance startDate: startDate andEndDate: endDate forQuantityType:quantityType unit: [HKUnit meterUnit]];
            [self.healthStore saveObject: distanceCyclingSample withCompletion:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"添加骑行记录成功!");
                } else {
                    NSLog(@"添加骑行记录失败: %@", error);
                }
            }];
            
        } else {
            NSLog(@"no history data!");
        }
    }];
}

-(HKQuantitySample *)correlationSampleWithData:(double)distance startDate:(NSDate *)startDate andEndDate:(NSDate *) endDate forQuantityType:(HKQuantityType *) quantityType unit:(HKUnit *) unit{
//    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceCycling];
    HKQuantity *distanceQuantity = [HKQuantity quantityWithUnit: unit doubleValue: distance];
    NSString *strName = [[UIDevice currentDevice] name];
    NSString *strModel = [[UIDevice currentDevice] model];
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
    
    HKDevice *device = [[HKDevice alloc] initWithName:strName manufacturer:@"Apple" model:strModel hardwareVersion:strModel firmwareVersion:strModel softwareVersion:strSysVersion localIdentifier:localeIdentifier UDIDeviceIdentifier:localeIdentifier];
    NSLog(@"device:%@",device);
    
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType: quantityType quantity: distanceQuantity startDate: startDate endDate: endDate device: device metadata: [NSDictionary dictionaryWithObject: @(0) forKey: @"HKWasUserEntered"]];
    
    return sample;
}

-(void)deleteDistanceCycling {
    HKSource *source = [HKSource defaultSource];
    NSPredicate *predicate = [HKQuery predicateForObjectsFromSource: source];
    HKQuantityType *distanceType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierDistanceCycling];
    [self.healthStore deleteObjectsOfType: distanceType predicate: predicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
        NSLog(@"删除骑行数据 %zd: %@", deletedObjectCount, error);
    }];
    
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierStepCount];
    [self.healthStore deleteObjectsOfType: stepCountType predicate: predicate withCompletion:^(BOOL success, NSUInteger deletedObjectCount, NSError * _Nullable error) {
        NSLog(@"删除步数数据 %zd: %@", deletedObjectCount, error);
    }];
}

@end
