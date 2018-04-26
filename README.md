
# react-native-hkit

## Getting started

`$ npm install react-native-hkit --save`

### Mostly automatic installation

`$ react-native link react-native-hkit`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-hkit` and add `RNHkit.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNHkit.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNHkitPackage;` to the imports at the top of the file
  - Add `new RNHkitPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-hkit'
  	project(':react-native-hkit').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-hkit/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-hkit')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNHkit.sln` in `node_modules/react-native-hkit/windows/RNHkit.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Hkit.RNHkit;` to the usings at the top of the file
  - Add `new RNHkitPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNHkit from 'react-native-hkit';

// TODO: What to do with the module?
RNHkit;
```
  