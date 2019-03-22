## Android customization

You can customize different parts of the gallery picker. To do so, you can simply pass `androidOptions` param in the `pickImages` call.

```dart
List resultList = await MultiImagePicker.pickImages(
    maxImages: 3,
    androidOptions: MaterialOptions(
        actionBarTitle: "Aciton bar",
        allViewTitle: "All view title",
        actionBarColor: "#aaaaaa",
        actionBarTitleColor: "#bbbbbb",
        lightStatusBar: false,
        statusBarColor: '#abcdef'
    ),
  );
```

Available options are:
 - actionBarTitle - string
 - allViewTitle - string
 - actionBarColor - HEX string
 - actionBarTitleColor - HEX string
 - actionBarTitleColor - HEX string
 - lightStatusBar - boolean
 - statusBarColor - HEX string

## iOS customization

You can customize different parts of the gallery picker. To do so, you can simply pass `iosOptions` param in the `pickImages` call.

?> The iOS plugin uses System Localizations, meaning it will automatically detect the device language and provide appropriate translations. You don't have to handle that manually like on Android.

```dart
List resultList = await MultiImagePicker.pickImages(
    maxImages: 3,
    options: CupertinoOptions(
      selectionFillColor: "#ff11ab",
      selectionTextColor: "#ff00a5",
      selectionCharacter: "✓",
    ),
  );
```

Available options are:
 - backgroundColor - HEX string
 - selectionFillColor - HEX string
 - selectionShadowColor - HEX string
 - selectionStrokeColor - HEX string
 - selectionTextColor - HEX string
 - selectionCharacter - Unicode character
 - takePhotoIcon - Name of the icon, as defined in your Assets

> **Note**: To add an icon to you XCode Assets, follow these steps:
> >
> Step 1: Select the asset catalog
>In your project root in Xcode click Runner -> Assets.xcassets in the project navigator to bring up the Asset Catalog for the project.
>
>Step 2: Add Image Set
>
>To add an image to the project, create a new image set. Drag the png asset (jpeg won't work) from the Finder to the 1X or 2X slot. In a production app, you should include both the standard (1X) as well as retina (2X) asset. During development, you can add only one asset and XCode will automatically create the other one, although it may look blurry. The name of the Image Set must match what you pass as an option to the plugin.
