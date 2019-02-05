# Upgrading

This page will list any changes that you have to make when there is a breaking or major version change.

## From version 2.4.11 to version 3.0.12

The project has migrated from using the old Android Support Library to [AndroidX](https://developer.android.com/jetpack/androidx/). If you haven't migrated you project to AndroidX yet, please use version 2.4.11 of the plugin.

If you migrated your project to AddroidX you can use version 3 and above of the plugin.

For more information how to migrate your project see [official migration guide](https://developer.android.com/jetpack/androidx/migrate).

!> Before migrating to AndroidX make sure all plugins you use in your project are supporting AndroidX. Recently the Flutter team started to migrate all of their plugins, but you should check the rest of the third party plugins you are using.

## From version 2.3.* to 2.4.11

If you are using the `Metadata` class you have to rename all priperties that you are checking to lowerCamelCase e.g.

- Previously `metadata.exif.Artist`
- Now `metadata.exif.artist`
