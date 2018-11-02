# multi_image_picker

[![build](https://img.shields.io/travis/Sh1d0w/multi_image_picker.svg)](https://pub.dartlang.org/packages/multi_image_picker)
[![pub package](https://img.shields.io/pub/v/multi_image_picker.svg)](https://pub.dartlang.org/packages/multi_image_picker)

> Flutter plugin that allows you to display multi image picker on iOS and Android.

## iOS

![Screenshot iOS 1](screenshots/ios-1.png) ![Screenshot iOS 2](screenshots/ios-2.png) ![Screenshot iOS 3](screenshots/ios-3.png)

For the iOS picker the plugin uses [BSImagePicker](https://github.com/mikaoj/BSImagePicker)

## Android

![Screenshot Anroid 1](screenshots/android-1.png) ![Screenshot Anroid 2](screenshots/android-2.png) ![Screenshot Anroid 3](screenshots/android-3.png)

For the Android picker the plugin uses [Matisse](https://github.com/zhihu/Matisse)

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

### Android

You need to request those permissions in AndroidManifest.xml in order the plugin to work:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

For example code usage, please see [here](https://github.com/Sh1d0w/multi_image_picker/blob/master/example/lib/main.dart)

## Enable Camera in the Gallery

If you wish you can enable the camera in the gallery, so the user can not only chosse photos, but take them as well with the camera.

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
    android:name="android.support.v4.content.FileProvider"
    android:authorities="YOUR_PACKAGE_NAME_HERE.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
      <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths_public"></meta-data>
  </provider>
```

That's it. When you invike the image picker you can then have to set `enableCamera` to true, as it is disabled by default:

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

## Related

- [image_picker](https://pub.dartlang.org/packages/image_picker) - Official Flutter image picker plugin

## License

MIT © [Radoslav Vitanov](https://github.com/Sh1d0w)
