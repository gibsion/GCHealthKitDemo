//
//  GCHealthManager.h
//  GCHealthKitDemo
//
//  Created by APPLE on 2017/2/20.
//  Copyright © 2017年 Gibson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface GCHealthManager : NSObject

+(instancetype)shareManager;
-(void)requestAuthorized:(void (^)(BOOL success, NSError * _Nullable error)) completion;
-(void)getStepCountWithstartDate:(NSDate *)startDate
                      andEndDate:(NSDate *)endDate
                  completeHandle: (void (^)(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error))completion;

-(void)getDistanceWalkingRunningWithstartDate:(NSDate *)startDate
                      andEndDate:(NSDate *)endDate
                  completeHandle: (void (^)(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error))completion;

-(void)getDistanceCyclingWithstartDate:(NSDate *)startDate
                            andEndDate:(NSDate *)endDate
                        completeHandle: (void (^)(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error))completion;

-(void)insertStepCount:(double) stepCount withStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
-(void)addDistanceCyclingData:(double)distance withStartDate:(NSDate *)startDate andEndDate:(NSDate *) endDate;

-(void)deleteDistanceCycling;
@end
