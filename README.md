
<h1 align="center">
  <br>
  <a href="http://www.amitmerchant.com/electron-markdownify"><img src="screenshots/multi_image_picker.png" alt="Markdownify" width="200"></a>
  <br>
  Flutter Multi Image Picker
  <br>
</h1>

<h4 align="center"><a href="https://flutter.io" target="_blank">Flutter</a> plugin that allows you to display multi image picker on iOS and Android.</h4>

<p align="center">
  <a href="https://pub.dartlang.org/packages/multi_image_picker">
    <img src="https://img.shields.io/travis/Sh1d0w/multi_image_picker.svg"
         alt="Build">
  </a>
  <a href="https://pub.dartlang.org/packages/multi_image_picker"><img src="https://img.shields.io/pub/v/multi_image_picker.svg"></a>
  <a href="https://paypal.me/Sh1d0w">
    <img src="https://img.shields.io/badge/$-donate-ff69b4.svg?maxAge=2592000&amp;style=flat">
  </a>
</p>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#faq">FAQ</a> •
  <a href="#credits">Credits</a> •
  <a href="#related">Related</a> •
  <a href="#license">License</a>
</p>

![screenshot](screenshots/hero.png)

## Key Features

* Pick multiple images
  - Instantly pick thousands of images at once, without any delay or blocking the UI thread.
* Native performance
  - The plugin takes advantage of the two best image picking libraries for Android and iOS, bringing you the best native platform experience.
* Photos sorted by albums
* Take a picture option in the grid view
* Restrict the maximum count of images the user can pick
* Customizable UI and localizations
* Thumbnail support
* Specify the image quality of the original image or thumbnails
* Read image meta data

## How To Use
   
Add this to your package's pubspec.yaml file::

```yaml
dependencies:
  multi_image_picker: ^2.3.22
```

Install it via command line:

```bash
flutter packages get
```

Now in your Dart code, you can use:

```dart
import 'package:multi_image_picker/multi_image_picker.dart';
```

Next steps:
  - [Initial setup](https://github.com/Sh1d0w/multi_image_picker/tree/master/doc/initial-setup.md)
  - [Enable Camera](https://github.com/Sh1d0w/multi_image_picker/tree/master/doc/enable-camera.md)
  - [Access image meta data](https://github.com/Sh1d0w/multi_image_picker/tree/master/doc/metadata.md)
  - Theming on [Android](https://github.com/Sh1d0w/multi_image_picker/tree/master/doc/theming-android.md)
  - Theming on [iOS](https://github.com/Sh1d0w/multi_image_picker/tree/master/doc/theming-ios.md)

## Emailware

Flutter Multi Image Picker is an [emailware](https://en.wiktionary.org/wiki/emailware). Meaning, if you liked using this plugin or has helped you in anyway, I'd like you send me an email on <radoslav.vitanov@gmail.com> about anything you'd want to say about this software. I'd really appreciate it!

## FAQ

### How I can access the images the user has picked?

When you invoke the image picker and the user picks some images, as response you will get List of Asset objects. The Asset class have two handy methods which allows you to access the picked image data - `requestThumbnail(width, height)`, which returns a resized image and `requestOriginal()` which returns the original hight quality image. Those methods are asynchronous and return the image data as `ByteData`, so you must be careful when to allocate and release this data if you don't need it in different views. For example implementation see the example folder.

### Why the plugin don't return image paths directly?

That's not an easy task when we speak for cross platform compatibility. For example on Android the `ContentResolver` returns content URIs, which not always have a file path. On iOS it gets even more complicated since with iCloud not all of your photos are stored physically on the phone, and there is no way to return the file path immediately without first downloading the original image from iCloud to the phone.

You can see how one of the core Flutter plugins - the single [image_picker](https://pub.dartlang.org/packages/image_picker), approaches and solves this problem in order to return file paths: it just copies the selected image content to the `tmp` folder and returns the file path from there. Now that works ok when you pick a single image.

But since with the `multi_image_picker` you can pick literally thousands of images on one go, this is not possible.

Another issue on iOS is that starting from iOS 11 all images taken by the camera are stored in [HEIC](https://en.wikipedia.org/wiki/High_Efficiency_Image_File_Format) format. Unfortunately, Flutter still doesn't have codecs to display HEIC images out-of-the-box in with the image widget.

The aim of this plugin is to be fast and efficient, currently you can pick thousands of images in milliseconds, and still have access to the selected images data whenever you need them. The plugin takes care of both Android and iOS platform specific cases and issues, and will reliably return the scaled thumb when you invoke `requestThumbnail` or the original image data when you invoke `requestOriginal`. You are then free to use this data as you like - display it in image widget or submit the data to a remote API.

## Credits

This software uses the following open source packages:

- [BSImagePicker](https://github.com/mikaoj/BSImagePicker) - iOS
- [Matisse](https://github.com/zhihu/Matisse) - Android

## Related

[image_picker](https://pub.dartlang.org/packages/image_picker) - Official Flutter image picker plugin

## Support

<a href="https://www.buymeacoffee.com/Sh1d0w" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## License

MIT

---
> GitHub [@Sh1d0w](https://github.com/Sh1d0w) &nbsp;&middot;&nbsp;
> Twitter [@RadoslavVitanov](http://twitter.com/RadoslavVitanov)
