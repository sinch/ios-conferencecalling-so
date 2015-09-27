# Building a one button app for conference calling
I have been thinking about building a one button app for some time that does something stupid just like YO! And when we released Conferencalling I thought of the awesome video conferencing sites that are just an URL and wanted to make that kind of app for Conference calling on Mobile


## Setup 
If you haven’t already, go to [sinch.com](https://www.sinch.com/signup) and sign up for free. Then, go to your dashboard and go to your apps. Create a new sandbox app. Take note of your app’s unique key and secret. 

Open up XCode and create a new project using the Single-View Application template. 
Set up CocoaPods to work with our app, in this tutorial we are going to use a small UIFramework I made. Open the directory for the project you just created in Terminal and type:

```
pod init
```

Then open the file named Podfile and add the following line:

```
pod 'SinchCallingUIKit',:git=>'https://github.com/spacedsweden/SinchCallingUIKit.git'
```

After saving the file, install all the tools you will need by simply typing:

```
pod install
```

After this, you’ll see an XCode workspace file with the extension “**.xcworkspace**”. We’ll need to work out of that file from now on instead of our project file. That way, all of our app’s components will work together.

sinch ui view controller


## Create a conference
