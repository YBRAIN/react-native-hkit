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

    isAvailable() {
        HealthKit.isAvailable((error: Object, available: boolean) => {
            return available;
        });
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
    async getLatestHeight(): Promise<void> {
        return HealthKit.getLatestHeight();
    },
    async getLatestWeight(): Promise<void> {
        return HealthKit.getLatestWeight();
    },
    async getLatestBodyMassIndex(): Promise<void> {
        return HealthKit.getLatestBodyMassIndex();
    },
    async getLatestLeanBodyMass(): Promise<void> {
        return HealthKit.getLatestLeanBodyMass();
    },
    async getLatestBodyFatPercentage(): Promise<void> {
        return HealthKit.getLatestBodyFatPercentage();
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
    async getStepCountOnDay(readOption: JSON): Promise<void> {
        return HealthKit.getStepCountOnDay(readOption);
    },


    async getHeightSamples(readOption: JSON): Promise<void> {
        return HealthKit.getHeightSamples(readOption);
    },
    async getWeightSamples(readOption: JSON): Promise<void> {
        return HealthKit.getWeightSamples(readOption);
    },
    async getSleepSamples(readOption: JSON): Promise<void> {
        return HealthKit.getSleepSamples(readOption);
    },
    async getDailyStepSamples(readOption: JSON): Promise<void> {
        return HealthKit.getDailyStepSamples(readOption);
    },
    async getHeartRateSamples(readOption: JSON): Promise<void> {
        return HealthKit.getHeartRateSamples(readOption);
    },


    async getBloodGlucoseSamples(readOption: JSON): Promise<void> {
        return HealthKit.getBloodGlucoseSamples(readOption);
    },
    async getBloodPressureSamples(readOption: JSON): Promise<void> {
        return HealthKit.getBloodPressureSamples(readOption);
    },
    async getBodyTemperatureSamples(readOption: JSON): Promise<void> {
        return HealthKit.getBodyTemperatureSamples(readOption);
    },

};
