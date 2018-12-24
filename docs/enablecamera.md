# Enable Camera

By default the image picker will display all images in your gallery. If you wish
you can also allow the user to take a picture as well, right from within the gallery.

To enable this functionality follow those steps:

## Enable camera on Android
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
    android:authorities="YOUR_PACKAGE_NAME_HERE.multiimagepicker.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
      <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths_public"></meta-data>
  </provider>
```

## Enable camera on iOS

No additional steps needed

<hr />

That's it. When you invoke the image picker you can then have to set `enableCamera` to true, as it is disabled by default:

```dart
  resultList = await MultiImagePicker.pickImages(
    maxImages: 300,
    enableCamera: true,
  );
```