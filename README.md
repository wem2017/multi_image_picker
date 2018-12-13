# multi_image_picker

[![build](https://img.shields.io/travis/Sh1d0w/multi_image_picker.svg)](https://pub.dartlang.org/packages/multi_image_picker)
[![pub package](https://img.shields.io/pub/v/multi_image_picker.svg)](https://pub.dartlang.org/packages/multi_image_picker)
<a href="https://stackoverflow.com/questions/tagged/flutter?sort=votes">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>


![Screenshot iOS 1](screenshots/hero.png)

## Usage

First you need to [add](https://pub.dartlang.org/packages/multi_image_picker#-installing-tab-) the plugin to your project.

### iOS

You need to add those strings to your Info.plist file in order the plugin to work:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Example usage description</string>
<key>NSCameraUsageDescription</key>
<string>Example usage description</string>
```

>**Important** The plugin is written in Swift, so your project needs to have Swift support enabled. If you've created the project using `flutter create -i swift [projectName]` you are all set. If not, you can enable Swift support by opening the project with XCode, then choose `File -> New -> File -> Swift File`. XCode will ask you if you wish to create Bridging Header, click yes.

The plugin supports Swift Version 4.2. Make sure you have this version set in your `Build Settings -> SWIFT_VERSION`

### Android

You need to request those permissions in AndroidManifest.xml in order the plugin to work:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
```

For example code usage, please see [here](https://github.com/Sh1d0w/multi_image_picker/blob/master/example/lib/main.dart)

## Enable Camera in the Gallery

If you wish you can enable the camera in the gallery, so the user can not only chosse photos, but take them as well with the camera.

### Enable camera on Android
To do so you need to, create this file in `android/app/src/main/res/xml/file_paths_public.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <external-path
        name="multiimagepicker_files"
        path="Pictures"/>
</paths>
```

And then add file provider in your `android/app/src/main/AndroidManifest.xml`, before the `</application>` closing tag:

```xml
  <provider
    android:name="com.vitanov.multiimagepicker.MultiImagePickerFileProvider"
    android:authorities="YOUR_PACKAGE_NAME_HERE.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
      <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths_public"></meta-data>
  </provider>
```

### Enable camera on iOS

No additional steps needed

That's it. When you invoke the image picker you can then have to set `enableCamera` to true, as it is disabled by default:

```dart
  resultList = await MultiImagePicker.pickImages(
    maxImages: 300,
    enableCamera: true,
  );
```

## Theming and localization

You can customize different parts of the gallery picker. For reference see below the available options for the different platforms:

Customization on [Android](https://github.com/Sh1d0w/multi_image_picker/tree/master/doc/android.md)

Customization on [iOS](https://github.com/Sh1d0w/multi_image_picker/tree/master/doc/ios.md)

## API

[MultiImagePicker](https://pub.dartlang.org/documentation/multi_image_picker/latest/picker/MultiImagePicker-class.html)

[Asset](https://pub.dartlang.org/documentation/multi_image_picker/latest/asset/Asset-class.html)

## FAQ

### How I can access the images the user has picked?

When you invoke the image picker and the user picks some images, as response you will get List of Asset objects. The Asset class have two handy methods which allows you to access the picked image data - `requestThumbnail(width, height)`, which returns a resized image and `requestOriginal()` which returns the original hight quality image. Those methods are asynchronious and return the image data as `ByteData`, so you must be careful when to allocate and release this data if you don't need it in different views. For example implementation see the example folder.

### Why the plugin don't return image paths directly?

That's not an easy task when we speak for cross platform compability. For example on Android the `ContentResolver` returns content URI's, which not always have a file path. On iOS it get's even more complicated - since there is iCloud and not all of your photos are stored physically on the phone, there is no way to return the file path imediately without first downloading the original image from iCloud to the phone.

You can see how one of the core Flutter plugins - the single [image_picker](https://pub.dartlang.org/packages/image_picker), approaches and solves this problem in order to return file paths: it just copies the selected image content to the `tmp` folder and retuns the file path from there. Now that works ok when you pick a single image.

But since with the `multi_image_picker` you can pick literally thousands of images on one go, this is not possible task.

Another issue on iOS is that starting form iOS 11 all images taken by the camera as stoed in [HEIC](https://en.wikipedia.org/wiki/High_Efficiency_Image_File_Format) format. Unfortunately Flutter still don't have codecs to display HEIC images out of the box in image widget.

The aim of this plugin is to be fast and efficient, currently you can pick thousands of images in matter of miliseconds, and still have access to the selected images data whenever you need them. The plugin takes care of both Android and iOS platform specific cases and issues, and will reliebly return the scaled thumb when you invoke `requestThumbnail` or the original image data when you invoke `requestOriginal`. You are then free to use this data as you like - display it in image widget or submit the data to a remote API.

## Related

- [image_picker](https://pub.dartlang.org/packages/image_picker) - Official Flutter image picker plugin

## Powered by

- [BSImagePicker](https://github.com/mikaoj/BSImagePicker) - iOS
- [Matisse](https://github.com/zhihu/Matisse) - Android

## License

MIT © [Radoslav Vitanov](https://github.com/Sh1d0w)
