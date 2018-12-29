# Accessing Image Data

The `Asset` class have several handy methods that allow you to access either
the original image data or a thumb data.

## Image Data

`async requestOriginal(quality: int)`

This method will return the original image data, with a given optional quality. The default
quality is 100.

```dart
ByteData byteData = await asset.requestOriginal();

// or

ByteData byteData = await asset.requestOriginal(quality: 80);

// Once loaded it will be accessible via the imageData getter in 
// the Asset object for future use. You can also conditionally check
// if it was already loaded to initially loaded.
if (asset.imageData == null) {
  await asset.requestOriginal(quality: 80);
}

// ....
ByteData byteData = asset.imageData;
```

!> Since once fetched, the imageData is stored in the `Asset` object, it is a good practce
to release the image data once it is no longer needed via `asset.releaseOriginal()`, otherwise 
you can run out of memory pretty quickly.

## Thumbnail Data

`async requestThumbnail(width: int, height: int, quality: int)`

This method will return the thumbnail image data, with a given width, height and optional quality. 
The default quality is 100.

```dart
ByteData byteData = await asset.requestThumbnail(300, 300);

// or

ByteData byteData = await asset.requestThumbnail(300, 300, quality: 60);

// Once loaded it will be accessible via the thumbData getter in 
// the Asset object for future use. You can also conditionally check
// if it was already loaded to initially loaded.
if (asset.thumbData == null) {
  await asset.requestThumbnail(300, 300);
}

// ....
ByteData byteData = asset.thumbData;
```

!> Since once fetched, the thumbData is stored in the `Asset` object, it is a good practce
to release the image data once it is no longer needed via `asset.releaseThumb()`, otherwise 
you can run out of memory pretty quickly.
