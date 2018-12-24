## Android Support Version Mismatch

If you get errors like this:

!> Android dependency 'com.android.support:support-v4' has different version for the compile (X.X.X) and runtime (X.X.X) classpath.

This just means that your project uses several plugins that depend on different version of the support library. The suggested approach here is
to make all of them resolve to the same version, usually the highest one. To do so, in your `android/app/build.grade` go to `dependencies` and 
add this:

```gradle
configurations.all {
  resolutionStrategy.eachDependency { DependencyResolveDetails details ->
    if (details.requested.group == 'com.android.support') {
      details.useVersion "27.1.1"
    }
  }
}
```

?> Don't forget to replace 27.1.1 with the highest version that the error you are getting is suggesting.

If you are getting error like this:

!> MultiImagePickerPlugin.java: 283 : error: cannot find symbol ExifInterface.TAG_ISO_SPEED

This also means you have version mismatch and should use the above solution, pinning the version to at least `27.1.1`