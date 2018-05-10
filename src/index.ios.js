// @flow

import { NativeModules } from 'react-native';
import { Permissions } from './Constants/Permissions'
import { Units } from './Constants/Units'

const HealthKit = NativeModules.hkit;

/**
 * Entry point of module
 */
export default {
    Permissions: Permissions,
    Units: Units,

    async isAvailable(): Promise<boolean> {
        return HealthKit.isAvailable();
    },

    async requestPermission(readOption: JSON): Promise<void> {
        return HealthKit.requestPermission(readOption);
    },

    // Characteristic
    async getBiologicalSex(): Promise<void> {
        return HealthKit.getBiologicalSex();
    },
    async getDateOfBirth(): Promise<void> {
        return HealthKit.getDateOfBirth();
    },
    async getBloodType(): Promise<void> {
        return HealthKit.getBloodType();
    },
    async getFitzpatrickSkin(): Promise<void> {
        return HealthKit.getFitzpatrickSkin();
    },
    async getWheelchairUse(): Promise<void> {
        return HealthKit.getWheelchairUse();
    },


    async getBloodGlucoseSamples(readOption: JSON): Promise<void> {
        return HealthKit.getBloodGlucoseSamples(readOption);
    },
    async getHeartRateSamples(readOption: JSON): Promise<void> {
        return HealthKit.getHeartRateSamples(readOption);
    },
    async getBodyTemperatureSamples(readOption: JSON): Promise<void> {
        return HealthKit.getBodyTemperatureSamples(readOption);
    },
    async getBloodPressureSamples(readOption: JSON): Promise<void> {
        return HealthKit.getBloodPressureSamples(readOption);
    },
    async getRespiratoryRateSamples(readOption: JSON): Promise<void> {
        return HealthKit.getRespiratoryRateSamples(readOption);
    },
    async getLatestWeight(readOption: JSON): Promise<void> {
        return HealthKit.getLatestWeight(readOption);
    },
    async getWeightSamples(readOption: JSON): Promise<void> {
        return HealthKit.getWeightSamples(readOption);
    },
    async getLatestBodyMassIndex(readOption: JSON): Promise<void> {
        return HealthKit.getLatestBodyMassIndex(readOption);
    },
    async getLatestHeight(readOption: JSON): Promise<void> {
        return HealthKit.getLatestHeight(readOption);
    },
    async getHeightSamples(readOption: JSON): Promise<void> {
        return HealthKit.getHeightSamples(readOption);
    },
    async getLatestBodyFatPercentage(readOption: JSON): Promise<void> {
        return HealthKit.getLatestBodyFatPercentage(readOption);
    },
    async getLatestLeanBodyMass(readOption: JSON): Promise<void> {
        return HealthKit.getLatestLeanBodyMass(readOption);
    },
    async getStepCountOnDay(readOption: JSON): Promise<void> {
        return HealthKit.getStepCountOnDay(readOption);
    },
    async getDailyStepSamples(readOption: JSON): Promise<void> {
        return HealthKit.getDailyStepSamples(readOption);
    },
    async getDistanceWalkingRunningOnDay(readOption: JSON): Promise<void> {
        return HealthKit.getDistanceWalkingRunningOnDay(readOption);
    },
    async getDistanceCyclingOnDay(readOption: JSON): Promise<void> {
        return HealthKit.getDistanceCyclingOnDay(readOption);
    },
    async getFlightsClimbedOnDay(readOption: JSON): Promise<void> {
        return HealthKit.getFlightsClimbedOnDay(readOption);
    },



    async getDailyStepCountSamples(readOption: JSON): Promise<void> {
        return HealthKit.getDailyStepCountSamples(readOption);
    },

    async getDistanceCycling(readOption: JSON): Promise<void> {
        return HealthKit.getDistanceCycling(readOption);
    },

    async getDistanceWalkingRunning(readOption: JSON): Promise<void> {
        return HealthKit.getDistanceWalkingRunning(readOption);
    },

    async getFlightsClimbed(readOption: JSON): Promise<void> {
        return HealthKit.getFlightsClimbed(readOption);
    },
    async getSleepSamples(readOption: JSON): Promise<void> {
        return HealthKit.getSleepSamples(readOption);
    },
    // async getStepCount(readOption: JSON): Promise<void> {
    //     return HealthKit.getStepCount(readOption);
    // },

};