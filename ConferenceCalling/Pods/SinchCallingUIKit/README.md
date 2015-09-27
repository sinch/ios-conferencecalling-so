# SinchCallingUIKit

<!--[![CI Status](http://img.shields.io/travis/d/SinchCallingUIKit.svg?style=flat)](https://travis-ci.org/d/SinchCallingUIKit)-->
<!--[![Version](https://img.shields.io/cocoapods/v/SinchCallingUIKit.svg?style=flat)](http://cocoapods.org/pods/SinchCallingUIKit)-->
<!--[![License](https://img.shields.io/cocoapods/l/SinchCallingUIKit.svg?style=flat)](http://cocoapods.org/pods/SinchCallingUIKit)-->
<!--[![Platform](https://img.shields.io/cocoapods/p/SinchCallingUIKit.svg?style=flat)](http://cocoapods.org/pods/SinchCallingUIKit)-->

## Usage

This is a pod that lets you add Sinch calling functionality with a callscreens in minutes, super for fast prototyping. If you want to remote/local push to play a custom sound, place a file called ringback.wav in your *mainbundle* (yeah I know its apple)

## Requirements

## Installation
To install it, simply add the following line to your Podfile:

```ruby
pod 'SinchCallingUIKit',:git=>'https://github.com/spacedsweden/SinchCallingUIKit.git'
```

## AppDelegate
Initiate the callingmanager 
```objectivec
[[CallingManager sharedManager] startClientWithKey:@"key" secret:@"i/secret==" userName:userName sandbox:YES launchOptions:options];
```
 
 
 ## Make a call app to app
 ```objectivec
[[CallingManager sharedManager] callUser:@"usertocall"];
```
 ## Make a call app to phone
 ```objectivec
 [[CallingManager sharedManager] callNumber:@"+14154251021"];
```


## Author

d, christian.jensen@spaced.se

## License

SinchCallingUIKit is available under the MIT license. See the LICENSE file for more info.
