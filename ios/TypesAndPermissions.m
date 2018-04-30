//
//  TypesAndPermissions.m
//  RNHkit
//
//  Created by HoJun Lee on 2018. 4. 4..
//  Copyright © 2018년 Facebook. All rights reserved.
//

#import "TypesAndPermissions.h"

@implementation RNHkit (TypesAndPermissions)

typedef NS_ENUM(NSInteger, UnitTypeMass) {
    gramUnit = 0,
    ounceUnit,
    poundUnit,
    stoneUnit,
};

typedef NS_ENUM(NSInteger, UnitTypeLength) {
    meterUnit = 0,
    inchUnit,
    footUnit,
    yardUnit,
    mileUnit,
};

typedef NS_ENUM(NSInteger, UnitTypeVolume) {
    literUnit = 0,
    fluidOunceUSUnit,
    fluidOunceImperialUnit,
    pintUSUnit,
    pintImperialUnit,
    cupUSUnit,
    cupImperialUnit,
};

typedef NS_ENUM(NSInteger, UnitTypePressure) {
    pascalUnit = 0,
    millimeterOfMercuryUnit,
    centimeterOfWaterUnit,
    atmosphereUnit,
};

typedef NS_ENUM(NSInteger, UnitTypeTime) {
    secondUnit = 0,
    minuteUnit,
    hourUnit,
    dayUnit,
};

typedef NS_ENUM(NSInteger, UnitTypeEnergy) {
    kilocalorieUnit = 0,
    smallCalorieUnit,
    largeCalorieUnit,
    jouleUnit,
};

typedef NS_ENUM(NSInteger, UnitTypeTemperature) {
    degreeCelsiusUnit = 0,
    degreeFahrenheitUnit,
    kelvinUnit,
};

typedef NS_ENUM(NSInteger, UnitTypeConductance) {
    siemenUnit = 0,
};

typedef NS_ENUM(NSInteger, UnitTypeScalar) {
    countUnit = 0,
    percentUnit,
};

- (NSDictionary *)unitStringDictionary {
    return @{
             @"grams": @"g",
             @"meters": @"m",
             @"liters": @"L",
             @"pascals": @"Pa",
             @"seconds": @"s",
             @"joules": @"J",
             @"kelvin": @"K",
             @"siemens": @"S",
             @"moles": @"mol",
             
             @"ounces": @"oz",
             @"pounds": @"lb",
             @"stones": @"st",
             
             @"inches": @"in",
             @"feet": @"ft",
             @"miles": @"mi",
             
             @"millimetersOfMercury": @"mmHg",
             @"centimetersOfWater": @"cmAq",
             @"atmospheres": @"atm",
             // [Volume]
             @"UScustomaryFluidOunces": @"fl_oz_us",
             @"ImperialFluidOunces": @"fl_oz_imp",
             @"UScustomaryPint": @"pt_us",
             @"ImperialPint": @"pt_imp",
             @"UScustomaryCup": @"cup_us",
             @"ImperialCup": @"cup_imp",
             // [Time]
             @"minutes": @"min",
             @"hours": @"hr",
             @"days": @"d",
             // [Energy]
             @"calories": @"cal",
             @"kilocalories": @"kcal",
             // [Temperature]
             @"Celsius": @"degC",
             @"Fahrenheit": @"degF",
             // [Pharmacology]
             @"international": @"IU",
             };
}


#pragma mark - HealthKit Permissions

- (NSDictionary *)readPermsDict {
    NSDictionary *readPerms = @{
                                // Characteristic Identifiers
                                @"DateOfBirth" : [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                @"BiologicalSex" : [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                // Body Measurements
                                @"Height" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                @"Weight" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                @"BodyMass" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                @"BodyFatPercentage" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage],
                                @"BodyMassIndex" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                @"LeanBodyMass" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass],
                                // Fitness Identifiers
                                @"Steps" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                @"StepCount" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                @"DistanceWalkingRunning" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                @"DistanceCycling" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                                @"BasalEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned],
                                @"ActiveEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                @"FlightsClimbed" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed],
                                @"NikeFuel" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierNikeFuel],
                                //        @"AppleExerciseTime" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierAppleExerciseTime],
                                // Nutrition Identifiers
                                @"DietaryEnergy" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
                                // Vital Signs Identifiers
                                @"HeartRate" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                @"BodyTemperature" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature],
                                @"BloodPressureSystolic" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic],
                                @"BloodPressureDiastolic" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic],
                                @"RespiratoryRate" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate],
                                // Results Identifiers
                                @"BloodGlucose" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose],
                                // Sleep
                                @"SleepAnalysis" : [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis],
                                // Mindfulness
                                @"MindfulSession" : [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierMindfulSession],
                                };
    return readPerms;
}


- (NSDictionary *)writePermsDict {
    NSDictionary *writePerms = @{
                                 // Body Measurements
                                 @"Height" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                 @"Weight" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                 @"BodyMass" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                 @"BodyFatPercentage" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage],
                                 @"BodyMassIndex" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                 @"LeanBodyMass" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass],
                                 // Fitness Identifiers
                                 @"Steps" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                 @"StepCount" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                 @"DistanceWalkingRunning" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                 @"DistanceCycling" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                                 @"BasalEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned],
                                 @"ActiveEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                 @"FlightsClimbed" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed],
                                 // Nutrition Identifiers
                                 @"DietaryEnergy" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
                                 // Sleep
                                 @"SleepAnalysis" : [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis],
                                 // Mindfulness
                                 @"MindfulSession" : [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierMindfulSession],
                                 };
    return writePerms;
}


// Returns HealthKit read permissions from options array
- (NSSet *)getReadPermsFromOptions:(NSArray *)options {
    NSDictionary *readPermDict = [self readPermsDict];
    NSMutableSet *readPermSet = [NSMutableSet setWithCapacity:1];
    for (NSString *optionKey in options) {
        HKObjectType *val = [readPermDict objectForKey:optionKey];
        if(val != nil) {
            [readPermSet addObject:val];
        }
    }
    return readPermSet;
}


// Returns HealthKit write permissions from options array
- (NSSet *)getWritePermsFromOptions:(NSArray *)options {
    NSDictionary *writePermDict = [self writePermsDict];
    NSMutableSet *writePermSet = [NSMutableSet setWithCapacity:1];
    for (NSString *optionKey in options) {
        HKObjectType *val = [writePermDict objectForKey:optionKey];
        if(val != nil) {
            [writePermSet addObject:val];
        }
    }
    return writePermSet;
}

@end
