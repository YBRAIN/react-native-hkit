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

typedef NS_ENUM(NSInteger, QueryInterval) {
    hourly = 0,
    daily,
    weekly,
    monthly
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

+ (NSDictionary *)intervalDict {
    NSDictionary *intervals = @{
                                @"hourly": @(hourly),
                                @"daily": @(daily),
                                @"weekly": @(weekly),
                                @"monthly": @(monthly)
                                };
    return intervals;
}

#pragma mark - HealthKit Permissions

+ (NSDictionary *)readPermissionsDict {
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
                                @"HeartRate" : [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
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


+ (NSDictionary *)writePermissionsDict {
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
                                 @"DistanceWalkingRunning" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],
                                 @"DistanceCycling" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                                 @"BasalEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned],
                                 @"ActiveEnergyBurned" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                 @"FlightsClimbed" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed],
                                 // Nutrition Identifiers
                                 @"Biotin" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryBiotin],
                                 @"Caffeine" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine],
                                 @"Calcium" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCalcium],
                                 @"Carbohydrates" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCarbohydrates],
                                 @"Chloride" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryChloride],
                                 @"Cholesterol" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCholesterol],
                                 @"Copper" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCopper],
                                 @"EnergyConsumed" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
                                 @"FatMonounsaturated" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatMonounsaturated],
                                 @"FatPolyunsaturated" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatPolyunsaturated],
                                 @"FatSaturated" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatSaturated],
                                 @"FatTotal" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFatTotal],
                                 @"Fiber" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFiber],
                                 @"Folate" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryFolate],
                                 @"Iodine" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryIodine],
                                 @"Iron" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryIron],
                                 @"Magnesium" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryMagnesium],
                                 @"Manganese" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryManganese],
                                 @"Molybdenum" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryMolybdenum],
                                 @"Niacin" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryNiacin],
                                 @"PantothenicAcid" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryPantothenicAcid],
                                 @"Phosphorus" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryPhosphorus],
                                 @"Potassium" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryPotassium],
                                 @"Protein" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryProtein],
                                 @"Riboflavin" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryRiboflavin],
                                 @"Selenium" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietarySelenium],
                                 @"Sodium" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietarySodium],
                                 @"Sugar" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietarySugar],
                                 @"Thiamin" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryThiamin],
                                 @"VitaminA" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminA],
                                 @"VitaminB12" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminB12],
                                 @"VitaminB6" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminB6],
                                 @"VitaminC" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminC],
                                 @"VitaminD" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminD],
                                 @"VitaminE" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminE],
                                 @"VitaminK" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryVitaminK],
                                 @"Zinc" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryZinc],
                                 @"Water" : [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryWater],
                                 // Sleep
                                 @"SleepAnalysis" : [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis],
                                 // Mindfulness
                                 @"MindfulSession" : [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierMindfulSession],
                                 };
    return writePerms;
}


// Returns HealthKit read permissions from options array
- (NSSet *)getReadPermsFromOptions:(NSArray *)options {
    NSDictionary *readPermDict = [RNHkit readPermissionsDict];
    NSMutableSet *readPermSet = [NSMutableSet setWithCapacity:1];
    
    for(int i=0; i<[options count]; i++) {
        NSString *optionKey = options[i];
        HKObjectType *val = [readPermDict objectForKey:optionKey];
        if(val != nil) {
            [readPermSet addObject:val];
        }
    }
    return readPermSet;
}


// Returns HealthKit write permissions from options array
- (NSSet *)getWritePermsFromOptions:(NSArray *)options {
    NSDictionary *writePermDict = [RNHkit writePermissionsDict];
    NSMutableSet *writePermSet = [NSMutableSet setWithCapacity:1];
    
    for(int i=0; i<[options count]; i++) {
        NSString *optionKey = options[i];
        HKObjectType *val = [writePermDict objectForKey:optionKey];
        if(val != nil) {
            [writePermSet addObject:val];
        }
    }
    return writePermSet;
}

- (NSDateComponents *)getIntervalFromString:(NSString *)intervalStr {
    QueryInterval qInterval = [[[RNHkit intervalDict] objectForKey:intervalStr] integerValue];
    NSDateComponents *interval = [[NSDateComponents alloc] init];
    switch (qInterval) {
        case hourly:
            interval.hour = 1;
            break;
        case daily:
            interval.day = 1;
            break;
        case weekly:
            interval.day = 7;
            break;
        case monthly:
            interval.month = 1;
            break;
        default:
            interval.hour = 1;
            break;
    }
    return interval;
}

@end

