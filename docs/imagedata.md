# Accessing Image Data

The `Asset` class have several handy methods that allow you to access either
the original image data or a thumb data.

## Image file path

`async get filePath`

This getter will return the original image file path.

```dart
String path = await asset.filePath;
```

## Image Data

`async requestOriginal(quality: int)`

This method will return the original image data, with a given optional quality. The default
quality is 100.

```dart
ByteData byteData = await asset.requestOriginal();

// or

ByteData byteData = await asset.requestOriginal(quality: 80);
```

## Thumbnail Data

`async requestThumbnail(width: int, height: int, quality: int)`

This method will return the thumbnail image data, with a given width, height and optional quality. 
The default quality is 100.

```dart
ByteData byteData = await asset.requestThumbnail(300, 300);

// or

ByteData byteData = await asset.requestThumbnail(300, 300, quality: 60);
```