/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
// import HKit  from 'react-native-hkit';

import {
  Platform,
  StyleSheet,
  Text,
  View
} from 'react-native';

let options = {
    permissions: {
        read: ["Height", "Weight", "StepCount", "DateOfBirth", "BodyMassIndex"],
        write: ["Weight", "StepCount", "BodyMassIndex"]
    }
};


const instructions = Platform.select({

  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

// AppleHealthKit.initHealthKit(options: Object, (err: string, results: Object) => {
//     if (err) {
//         console.log("error initializing Healthkit: ", err);
//         return;
//     }
//
//     // Height Example
//     AppleHealthKit.getDateOfBirth(null, (err: Object, results: Object) => {
//         if (this._handleHealthkitError(err, 'getDateOfBirth')) {
//             return;
//         }
//         console.log(results)
//     });
//
// });

type Props = {};
export default class App extends Component<Props> {
    // HKit
    constructor(props) {
        super(props);
        this.state = { isAvailable: false, ready: false };
    }

    async componentDidMount() {
        try {

            // HKit.initHealthKit(options: Object, (err: string, results: Object) => {
            //     if (err) {
            //         console.log("error initializing Healthkit: ", err);
            //         return;
            //     }
            //
            // });
            this.setState({ isAvailable, ready: true });
            console.log('isAvailable RNHkit ');
        } catch (ex) {
            console.log('Error = ', ex);
        }
    }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit App.js
        </Text>
        <Text style={styles.instructions}>
          {instructions}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
