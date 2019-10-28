// @flow

import {NativeModules} from 'react-native';

const HealthKit = NativeModules.hkit;

export {Permissions} from './Constants/Permissions';
export {Units} from './Constants/Units';
export type EpochSec = number;

export type ReadOption = {
    startDate?: EpochSec,
    endDate?: EpochSec,
    date?: EpochSec,
    unit?: string,
    interval?: string,
}

export type HealthDataSample = {
    startDate: string,
    endDate: string,
    value: number,
}

export type BiologicalSex =
    'unknown'
    | 'female'
    | 'male'
    | 'other'

export type BloodType =
    'NotSet'
    | 'A+'
    | 'A-'
    | 'B+'
    | 'B-'
    | 'AB+'
    | 'AB-'
    | 'O+'
    | 'O-'

export type SkinType =
    'NotSet'
    | 'White'
    | 'Beige'
    | 'LightBrown'
    | 'MediumBrown'
    | 'DarkBrown'
    | 'Black'

export type WheelChairUse =
    'NotSet'
    | 'No'
    | 'Yes'

/**
 * Entry point of module
 */
export default {
    isAvailable(): Promise<boolean> {
        return new Promise(resolve => HealthKit.isAvailable((error: Object, available: boolean) => resolve(available)));
    },

    async requestPermission(readOption: ReadOption): Promise<void> {
        return HealthKit.requestPermission(readOption);
    },

    // Characteristic
    async getBiologicalSex(): Promise<BiologicalSex> {
        return HealthKit.getBiologicalSex();
    },
    async getDateOfBirth(): Promise<string> {
        return HealthKit.getDateOfBirth();
    },
    async getBloodType(): Promise<BloodType> {
        return HealthKit.getBloodType();
    },
    async getFitzpatrickSkin(): Promise<SkinType> {
        return HealthKit.getFitzpatrickSkin();
    },
    async getWheelchairUse(): Promise<WheelChairUse> {
        return HealthKit.getWheelchairUse();
    },
    async getLatestHeight(): Promise<HealthDataSample[]> {
        return HealthKit.getLatestHeight();
    },
    async getLatestWeight(): Promise<HealthDataSample[]> {
        return HealthKit.getLatestWeight();
    },
    async getLatestBodyMassIndex(): Promise<HealthDataSample[]> {
        return HealthKit.getLatestBodyMassIndex();
    },
    async getLatestLeanBodyMass(): Promise<HealthDataSample[]> {
        return HealthKit.getLatestLeanBodyMass();
    },
    async getLatestBodyFatPercentage(): Promise<HealthDataSample[]> {
        return HealthKit.getLatestBodyFatPercentage();
    },

    async getDistanceWalkingRunningOnDay(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getDistanceWalkingRunningOnDay(readOption);
    },
    async getDistanceCyclingOnDay(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getDistanceCyclingOnDay(readOption);
    },
    async getFlightsClimbedOnDay(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getFlightsClimbedOnDay(readOption);
    },
    async getStepCountOnDay(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getStepCountOnDay(readOption);
    },

    async getHeightSamples(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getHeightSamples(readOption);
    },
    async getWeightSamples(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getWeightSamples(readOption);
    },
    async getSleepSamples(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getSleepSamples(readOption);
    },
    async getDailyStepSamples(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getDailyStepSamples(readOption);
    },
    async getHeartRateSamples(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getHeartRateSamples(readOption);
    },

    async getBloodGlucoseSamples(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getBloodGlucoseSamples(readOption);
    },
    async getBloodPressureSamples(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getBloodPressureSamples(readOption);
    },
    async getBodyTemperatureSamples(readOption: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getBodyTemperatureSamples(readOption);
    },
    async getCumulativeStatisticsForType(type: string, readOptions: ReadOption): Promise<HealthDataSample[]> {
        return HealthKit.getCumulativeStatisticsForType(type, readOptions);
    },
    async getTotalDurationForType(type: string, readOptions: ReadOption): Promise<number> {
        return HealthKit.getTotalDurationForType(type, readOptions);
    },
};
