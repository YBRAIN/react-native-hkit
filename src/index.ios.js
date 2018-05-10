// @flow

import { NativeModules } from 'react-native';
import { Permissions } from './Constants/Permissions'
import { Units } from './Constants/Units'

const HealthKit = NativeModules.hkit;

/**
 * Entry point of module
 */
const AKClient = {
    Permissions: Permissions,
    Units: Units,

    async isAvailable(): Promise<boolean> {
        return HealthKit.isAvailable();
    },

    async requestPermission(readOption: JSON): Promise<void> {
        return HealthKit.requestPermission(readOption);
    },


    async getDateOfBirth(readOption: JSON): Promise<void> {
        return HealthKit.getDateOfBirth(readOption);
    },

    async getLatestHeight(readOption: JSON): Promise<void> {
        return HealthKit.getLatestHeight(readOption);
    },

    async getHeightSamples(readOption: JSON): Promise<void> {
        return HealthKit.getHeightSamples(readOption);
    },

    async getLatestWeight(readOption: JSON): Promise<void> {
        return HealthKit.getLatestWeight(readOption);
    },

    async getWeightSamples(readOption: JSON): Promise<void> {
        return HealthKit.getWeightSamples(readOption);
    },


    async getBiologicalSex(readOption: JSON): Promise<void > {
        return HealthKit.getBiologicalSex(readOption);
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

    async getHeartRateSamples(readOption: JSON): Promise<void> {
        return HealthKit.getHeartRateSamples(readOption);
    },

    async getLatestBmi(readOption: JSON): Promise<void> {
        return HealthKit.getLatestBmi(readOption);
    },

    async getLatestBodyFatPercentage(readOption: JSON): Promise<void> {
        return HealthKit.getLatestBodyFatPercentage(readOption);
    },

    async getLatestLeanBodyMass(readOption: JSON): Promise<void> {
        return HealthKit.getLatestLeanBodyMass(readOption);
    },

    async getRespiratoryRateSamples(readOption: JSON): Promise<void> {
        return HealthKit.getRespiratoryRateSamples(readOption);
    },

    async getSleepSamples(readOption: JSON): Promise<void> {
        return HealthKit.getSleepSamples(readOption);
    },

    async getStepCount(readOption: JSON): Promise<void> {
        return HealthKit.getStepCount(readOption);
    },

};

export default AKClient;