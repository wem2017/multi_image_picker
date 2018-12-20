# Android customization

The library used in this project only allows customization via xml styles, so the only way to provide custom styles for the gallery picker is to override the default strings via resource files (this can not be overidden in through Flutter package interface).

This guide aims to help you do that.

Here is the default theme that the plugin uses:

```xml
<style name="Matisse.Zhihu" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="colorPrimary">@color/zhihu_primary</item>
        <item name="colorPrimaryDark">@color/zhihu_primary_dark</item>
        <item name="toolbar">@style/Toolbar.Zhihu</item>
        <item name="album.dropdown.title.color">@color/zhihu_album_dropdown_title_text</item>
        <item name="album.dropdown.count.color">@color/zhihu_album_dropdown_count_text</item>
        <item name="album.element.color">@android:color/white</item>
        <item name="album.thumbnail.placeholder">@color/zhihu_album_dropdown_thumbnail_placeholder</item>
        <item name="album.emptyView">@drawable/ic_empty_zhihu</item>
        <item name="album.emptyView.textColor">@color/zhihu_album_empty_view</item>
        <item name="item.placeholder">@color/zhihu_item_placeholder</item>
        <item name="item.checkCircle.backgroundColor">@color/zhihu_item_checkCircle_backgroundColor</item>
        <item name="item.checkCircle.borderColor">@color/zhihu_item_checkCircle_borderColor</item>
        <item name="page.bg">@color/zhihu_page_bg</item>
        <item name="bottomToolbar.bg">@color/zhihu_bottom_toolbar_bg</item>
        <item name="bottomToolbar.preview.textColor">@color/zhihu_bottom_toolbar_preview</item>
        <item name="bottomToolbar.apply.textColor">@color/zhihu_bottom_toolbar_apply</item>
        <item name="preview.bottomToolbar.back.textColor">@color/zhihu_preview_bottom_toolbar_back_text</item>
        <item name="preview.bottomToolbar.apply.textColor">@color/zhihu_preview_bottom_toolbar_apply</item>
        <item name="listPopupWindowStyle">@style/Popup.Zhihu</item>
        <item name="capture.textColor">@color/zhihu_capture</item>
    </style>
```

If you want you can override certain parts of the theme, or all aspects of it.

To do so in your Flutter project navigate to `android/app/src/main/res/values` folder. Open `styles.xml` file. It's contents should default to:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
</resources>
```

Then you can override any of the defined colors in the default gallery theme. For example if you want to change the primary color to red add:

```xml
<color name="zhihu_primary">#EF021A</color>
```

before the `</resources>` closing tag. The end result should look like this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <style name="RedTheme" parent="Matisse.Zhihu">
        <item name="colorPrimary">#EF021A</item>
    </style>
    <color name="zhihu_primary">#EF021A</color>
</resources>
```

The same way you can override any strings that gallery uses. Just create a new file called `strings.xml` in the same folder as `styles.xml` and add this content.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources
    xmlns:tools="http://schemas.android.com/tools"
    tools:ignore="MissingTranslation">
    <string name="album_name_all">All Media</string>

    <string name="button_preview">Preview</string>
    <string name="button_apply_default">Apply</string>
    <string name="button_apply">Apply(%1$d)</string>
    <string name="button_back">Back</string>
    <string name="photo_grid_capture">Camera</string>
    <string name="empty_text">No media yet</string>
    <string name="button_ok">OK</string>

    <string name="error_over_count_default">You have reached max selectable</string>
    <plurals name="error_over_count">
        <item quantity="few">You can only select up to %1$d media file</item>
        <item quantity="many">You can only select up to %1$d media file</item>
        <item quantity="one">You can only select up to 1 media file</item>
        <item quantity="other">You can only select up to %1$d media files</item>
    </plurals>
    <string name="error_under_quality">Under quality</string>
    <string name="error_over_quality">Over quality</string>
    <string name="error_file_type">Unsupported file type</string>
    <string name="error_type_conflict">Can\'t select images and videos at the same time</string>
    <string name="error_no_video_activity">No App found supporting video preview</string>
    <string name="error_over_original_size">Can\'t select the images larger than %1$d MB</string>
    <string name="error_over_original_count">%1$d images over %2$d MB. Original will be unchecked</string>
    <string name="button_original">Original</string>
    <string name="button_sure_default">Sure</string>
    <string name="button_sure">Sure(%1$d)</string>
</resources>
```

You can the replace any texts you want.
