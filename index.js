//@flow

import { NativeModules } from 'react-native';
import { Permissions } from './src/Constants/Permissions'
import { Units } from './src/Constants/Units'

const { RNHkit } = NativeModules.RNHkit;


let HealthKit = Object.assign({}, RNHkit, {
    Constants: {
        Permissions: Permissions,
        Units: Units,
    }
});

const healthKitOptions = {
    permissions: {
        read: [
            PERMS.DateOfBirth,
            PERMS.Height,
            PERMS.Weight,

            PERMS.BodyMass,
            PERMS.BodyMassIndex,
            PERMS.BodyFatPercentage,
            PERMS.LeanBodyMass,
            PERMS.Steps,
            PERMS.StepCount,
            PERMS.DistanceCycling,
            PERMS.DistanceWalkingRunning,
            PERMS.BasalEnergyBurned,
            PERMS.ActiveEnergyBurned,
            PERMS.FlightsClimbed,
            PERMS.NikeFuel,
            PERMS.AppleExerciseTime,
            PERMS.DietaryEnergy,
            PERMS.HeartRate,
            PERMS.BodyTemperature,
            PERMS.BloodGlucose,
            PERMS.BloodPressureSystolic,
            PERMS.BloodPressureDiastolic,
            PERMS.RespiratoryRate,
            PERMS.SleepAnalysis,
            PERMS.MindfulSession,
        ],
        write: []
    }
};

/**
 * Entry point of module
 */
class AHKit {
    constructor () {
        HealthKit..initHealthKit(
            (options: Object),
            (err: string, results: Object) => {
                if (err) {
                    console.log("error initializing Healthkit: ", err);
                    return;
                }
            }
        );
    }

}
const AKWrapperClient = {
    getDateOfBirth(readOption: String): Promise<void> {
        return AppleHealthKit.getDateOfBirth(readOption)
    },

    getLatestHeight(readOption: String): Promise<void> {
        return AppleHealthKit.getLatestHeight(readOption)
    },

    getHeightSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getHeightSamples(readOption)
    },

    getLatestWeight(readOption: String): Promise<void> {
        return AppleHealthKit.getLatestWeight(readOption)
    },

    getWeightSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getWeightSamples(readOption)
    },


    getBiologicalSex(readOption: String): Promise<void > {
        return AppleHealthKit.getBiologicalSex(readOption);
    },

    getBloodGlucoseSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getBloodGlucoseSamples(readOption);
    },

    getBloodPressureSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getBloodPressureSamples(readOption);
    },

    getBodyTemperatureSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getBodyTemperatureSamples(readOption);
    },

    getDailyStepCountSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getDailyStepCountSamples(readOption);
    },

    getDistanceCycling(readOption: String): Promise<void> {
        return AppleHealthKit.getDistanceCycling(readOption);
    },

    getDistanceWalkingRunning(readOption: String): Promise<void> {
        return AppleHealthKit.getDistanceWalkingRunning(readOption);
    },

    getFlightsClimbed(readOption: String): Promise<void> {
        return AppleHealthKit.getFlightsClimbed(readOption);
    },

    getHeartRateSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getHeartRateSamples(readOption);
    },

    getLatestBmi(readOption: String): Promise<void> {
        return AppleHealthKit.getLatestBmi(readOption);
    },

    getLatestBodyFatPercentage(readOption: String): Promise<void> {
        return AppleHealthKit.getLatestBodyFatPercentage(readOption);
    },

    getLatestLeanBodyMass(readOption: String): Promise<void> {
        return AppleHealthKit.getLatestLeanBodyMass(readOption);
    },

    getRespiratoryRateSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getRespiratoryRateSamples(readOption);
    },

    getSleepSamples(readOption: String): Promise<void> {
        return AppleHealthKit.getSleepSamples(readOption);
    },

    getStepCount(readOption: String): Promise<void> {
        return AppleHealthKit.getStepCount(readOption);
    },

};

export default {
    AKClient: AKWrapperClient,

    async getAllActivityDatas(): Promise<void> {
        var results = [];
        Object.keys(AKWrapperClient).forEach((method, index) => {
            const result = AKWrapperClient[method];
            if(result) {
                results.append(result);
            }
        })
        // return results;
    },
};

// AppleHealthKit.initHealthKit(
//     (options: Object),
//     (err: string, results: Object) => {
//         if (err) {
//             console.log("error initializing Healthkit: ", err);
//
//         }
//
//     });

module.exports = HealthKit;