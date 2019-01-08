package com.vitanov.multiimagepicker;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.database.CursorIndexOutOfBoundsException;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.MediaScannerConnection;
import android.media.ThumbnailUtils;
import android.net.Uri;

import com.zhihu.matisse.Matisse;
import com.zhihu.matisse.MimeType;
import com.zhihu.matisse.internal.entity.CaptureStrategy;
import com.zhihu.matisse.engine.impl.GlideEngine;

import android.content.pm.ActivityInfo;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.WeakReference;
import java.nio.ByteBuffer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import android.Manifest;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.media.ExifInterface;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static android.media.ThumbnailUtils.OPTIONS_RECYCLE_INPUT;


/**
 * MultiImagePickerPlugin
 */
public class MultiImagePickerPlugin implements
        MethodCallHandler,
        PluginRegistry.ActivityResultListener,
        PluginRegistry.RequestPermissionsResultListener {
    public interface Refresh {
        void after() ;
    }

    private static final String CHANNEL_NAME = "multi_image_picker";
    private static final String REQUEST_THUMBNAIL = "requestThumbnail";
    private static final String REQUEST_ORIGINAL = "requestOriginal";
    private static final String REQUEST_METADATA = "requestMetadata";
    private static final String PICK_IMAGES = "pickImages";
    private static final String REFRESH_IMAGE = "refreshImage" ;
    private static final String MAX_IMAGES = "maxImages";
    private static final String ENABLE_CAMERA = "enableCamera";
    private static final int REQUEST_CODE_CHOOSE = 1001;
    private static final int REQUEST_CODE_GRANT_PERMISSIONS = 2001;
    private final MethodChannel channel;
    private Activity activity;
    private Context context;
    private BinaryMessenger messenger;
    private Result pendingResult;
    private MethodCall methodCall;
    private PluginRegistry.RequestPermissionsResultListener mPermissionsResultListener;

    private MultiImagePickerPlugin(Activity activity, Context context, MethodChannel channel, BinaryMessenger messenger) {
        this.activity = activity;
        this.context = context;
        this.channel = channel;
        this.messenger = messenger;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == REQUEST_CODE_GRANT_PERMISSIONS && permissions.length == 3) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED
                    && grantResults[1] == PackageManager.PERMISSION_GRANTED
                    && grantResults[2] == PackageManager.PERMISSION_GRANTED) {
                presentPicker();
            } else {
                if (
                        ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.READ_EXTERNAL_STORAGE) ||
                                ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE) ||
                                ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.CAMERA)) {
                    finishWithError("PERMISSION_DENIED", "Read, write or camera permission was not granted");
                } else{
                    finishWithError("PERMISSION_PERMANENTLY_DENIED", "Please enable access to the storage and the camera.");
                }
                return false;
            }

            return true;
        }
        return false;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
        MultiImagePickerPlugin instance = new MultiImagePickerPlugin(registrar.activity(), registrar.context(), channel, registrar.messenger());
        registrar.addActivityResultListener(instance);
        registrar.addRequestPermissionsResultListener(instance);
        channel.setMethodCallHandler(instance);

    }

    private static class GetThumbnailTask extends AsyncTask<String, Void, Void> {
        private WeakReference<Activity> activityReference;
        BinaryMessenger messenger;
        String identifier;
        int width;
        int height;
        int quality;

        GetThumbnailTask(Activity context, BinaryMessenger messenger, String identifier, int width, int height, int quality) {
            super();
            this.messenger = messenger;
            this.identifier = identifier;
            this.width = width;
            this.height = height;
            this.quality = quality;
            this.activityReference = new WeakReference<>(context);
        }

        @Override
        protected Void doInBackground(String... strings) {
            final Uri uri = Uri.parse(this.identifier);
            InputStream stream = null;
            byte[] byteArray = null;

            try {
                // get a reference to the activity if it is still there
                Activity activity = activityReference.get();
                if (activity == null || activity.isFinishing()) return null;

                Bitmap sourceBitmap = getCorrectlyOrientedImage(activity, uri);
                Bitmap bitmap = ThumbnailUtils.extractThumbnail(sourceBitmap, this.width, this.height, OPTIONS_RECYCLE_INPUT);

                if (bitmap == null) return null;

                ByteArrayOutputStream bitmapStream = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.JPEG, this.quality, bitmapStream);
                byteArray = bitmapStream.toByteArray();
                bitmap.recycle();
                bitmapStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }


            final ByteBuffer buffer;
            if (byteArray != null) {
                buffer = ByteBuffer.allocateDirect(byteArray.length);
                buffer.put(byteArray);
                this.messenger.send("multi_image_picker/image/" + this.identifier, buffer);
                buffer.clear();
            }
            return null;
        }
    }

    private static class GetImageTask extends AsyncTask<String, Void, Void> {
        private WeakReference<Activity> activityReference;

        BinaryMessenger messenger;
        String identifier;
        int quality;

        GetImageTask(Activity context, BinaryMessenger messenger, String identifier, int quality) {
            super();
            this.messenger = messenger;
            this.identifier = identifier;
            this.quality = quality;
            this.activityReference = new WeakReference<>(context);
        }

        @Override
        protected Void doInBackground(String... strings) {
            final Uri uri = Uri.parse(this.identifier);
            byte[] bytesArray = null;

            try {
                // get a reference to the activity if it is still there
                Activity activity = activityReference.get();
                if (activity == null || activity.isFinishing()) return null;

                Bitmap bitmap = getCorrectlyOrientedImage(activity, uri);

                if (bitmap == null) return null;

                ByteArrayOutputStream bitmapStream = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.JPEG, this.quality, bitmapStream);
                bytesArray = bitmapStream.toByteArray();
                bitmap.recycle();
                bitmapStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

            assert bytesArray != null;
            final ByteBuffer buffer = ByteBuffer.allocateDirect(bytesArray.length);
            buffer.put(bytesArray);
            this.messenger.send("multi_image_picker/image/" + this.identifier, buffer);
            buffer.clear();
            return null;
        }
    }

    @Override
    public void onMethodCall(final MethodCall call, final Result result) {

        if (!setPendingMethodCallAndResult(call, result)) {
            finishWithAlreadyActiveError(result);
            return;
        }

        if (PICK_IMAGES.equals(call.method)) {
            openImagePicker();
        } else if (REQUEST_ORIGINAL.equals(call.method)) {
            final String identifier = call.argument("identifier");
            final int quality = call.argument("quality");
            GetImageTask task = new GetImageTask(this.activity, this.messenger, identifier, quality);
            task.execute("");
            finishWithSuccess(true);

        } else if (REQUEST_THUMBNAIL.equals(call.method)) {
            final String identifier = call.argument("identifier");
            final int width = call.argument("width");
            final int height = call.argument("height");
            final int quality = call.argument("quality");
            GetThumbnailTask task = new GetThumbnailTask(this.activity, this.messenger, identifier, width, height, quality);
            task.execute("");
            finishWithSuccess(true);


        } else if (REQUEST_METADATA.equals(call.method)) {
            final String identifier = call.argument("identifier");

            final Uri uri = Uri.parse(identifier);
            InputStream in = null;
            try {
                in = context.getContentResolver().openInputStream(uri);
                assert in != null;
                ExifInterface exifInterface = new ExifInterface(in);
                finishWithSuccess(getPictureExif(exifInterface));

            } catch (IOException e) {
                finishWithError("Exif error", e.toString());
            } finally {
                if (in != null) {
                    try {
                        in.close();
                    } catch (IOException ignored) {}
                }
            }

        } else if (REFRESH_IMAGE.equals(call.method)) {
            String path = call.argument("path") ;
            refreshGallery(path);
        } else {
            pendingResult.notImplemented();
            clearMethodCallAndResult();
        }
    }

    private HashMap<String, Object> getPictureExif(ExifInterface exifInterface) {
        HashMap<String, Object> result = new HashMap<>();

        // API LEVEL 24
        String[] tags_str = {
                ExifInterface.TAG_GPS_LATITUDE_REF,
                ExifInterface.TAG_GPS_LONGITUDE_REF,
                ExifInterface.TAG_GPS_PROCESSING_METHOD,
                ExifInterface.TAG_IMAGE_WIDTH,
                ExifInterface.TAG_IMAGE_LENGTH,
                ExifInterface.TAG_MAKE,
                ExifInterface.TAG_MODEL
        };
        String[] tags_double = {
                ExifInterface.TAG_APERTURE_VALUE,
                ExifInterface.TAG_FLASH,
                ExifInterface.TAG_FOCAL_LENGTH,
                ExifInterface.TAG_GPS_ALTITUDE,
                ExifInterface.TAG_GPS_ALTITUDE_REF,
                ExifInterface.TAG_GPS_LONGITUDE,
                ExifInterface.TAG_GPS_LATITUDE,
                ExifInterface.TAG_IMAGE_LENGTH,
                ExifInterface.TAG_IMAGE_WIDTH,
                ExifInterface.TAG_ISO_SPEED,
                ExifInterface.TAG_ORIENTATION,
                ExifInterface.TAG_WHITE_BALANCE,
                ExifInterface.TAG_EXPOSURE_TIME
        };
        HashMap<String, Object> exif_str = getExif_str(exifInterface, tags_str);
        result.putAll(exif_str);
        HashMap<String, Object> exif_double = getExif_double(exifInterface, tags_double);
        result.putAll(exif_double);

        if (Build.VERSION.SDK_INT == Build.VERSION_CODES.M) {
            String[] tags_23 = {
                    ExifInterface.TAG_DATETIME_DIGITIZED,
                    ExifInterface.TAG_SUBSEC_TIME,
                    ExifInterface.TAG_SUBSEC_TIME_DIGITIZED,
                    ExifInterface.TAG_SUBSEC_TIME_ORIGINAL
            };
            HashMap<String, Object> exif23 = getExif_str(exifInterface, tags_23);
            result.putAll(exif23);
        }

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
            String[] tags_24_str = {
                    ExifInterface.TAG_ARTIST,
                    ExifInterface.TAG_CFA_PATTERN,
                    ExifInterface.TAG_COMPONENTS_CONFIGURATION,
                    ExifInterface.TAG_COPYRIGHT,
                    ExifInterface.TAG_DATETIME_ORIGINAL,
                    ExifInterface.TAG_DEVICE_SETTING_DESCRIPTION,
                    ExifInterface.TAG_EXIF_VERSION,
                    ExifInterface.TAG_FILE_SOURCE,
                    ExifInterface.TAG_FLASHPIX_VERSION,
                    ExifInterface.TAG_GPS_AREA_INFORMATION,
                    ExifInterface.TAG_GPS_DEST_BEARING_REF,
                    ExifInterface.TAG_GPS_DEST_DISTANCE_REF,
                    ExifInterface.TAG_GPS_DEST_LATITUDE_REF,
                    ExifInterface.TAG_GPS_DEST_LONGITUDE_REF,
                    ExifInterface.TAG_GPS_DOP,
                    ExifInterface.TAG_GPS_IMG_DIRECTION,
                    ExifInterface.TAG_GPS_IMG_DIRECTION_REF,
                    ExifInterface.TAG_GPS_MAP_DATUM,
                    ExifInterface.TAG_GPS_MEASURE_MODE,
                    ExifInterface.TAG_GPS_SATELLITES,
                    ExifInterface.TAG_GPS_SPEED_REF,
                    ExifInterface.TAG_GPS_STATUS,
                    ExifInterface.TAG_GPS_TRACK_REF,
                    ExifInterface.TAG_GPS_VERSION_ID,
                    ExifInterface.TAG_IMAGE_DESCRIPTION,
                    ExifInterface.TAG_IMAGE_UNIQUE_ID,
                    ExifInterface.TAG_INTEROPERABILITY_INDEX,
                    ExifInterface.TAG_MAKER_NOTE,
                    ExifInterface.TAG_OECF,
                    ExifInterface.TAG_RELATED_SOUND_FILE,
                    ExifInterface.TAG_SCENE_TYPE,
                    ExifInterface.TAG_SOFTWARE,
                    ExifInterface.TAG_SPATIAL_FREQUENCY_RESPONSE,
                    ExifInterface.TAG_SPECTRAL_SENSITIVITY,
                    ExifInterface.TAG_SUBSEC_TIME_DIGITIZED,
                    ExifInterface.TAG_SUBSEC_TIME_ORIGINAL,
                    ExifInterface.TAG_USER_COMMENT
            };

            String[] tags24_double = {
                    ExifInterface.TAG_APERTURE_VALUE,
                    ExifInterface.TAG_BITS_PER_SAMPLE,
                    ExifInterface.TAG_BRIGHTNESS_VALUE,
                    ExifInterface.TAG_COLOR_SPACE,
                    ExifInterface.TAG_COMPRESSED_BITS_PER_PIXEL,
                    ExifInterface.TAG_COMPRESSION,
                    ExifInterface.TAG_CONTRAST,
                    ExifInterface.TAG_CUSTOM_RENDERED,
                    ExifInterface.TAG_DIGITAL_ZOOM_RATIO,
                    ExifInterface.TAG_EXPOSURE_BIAS_VALUE,
                    ExifInterface.TAG_EXPOSURE_INDEX,
                    ExifInterface.TAG_EXPOSURE_MODE,
                    ExifInterface.TAG_EXPOSURE_PROGRAM,
                    ExifInterface.TAG_FLASH_ENERGY,
                    ExifInterface.TAG_FOCAL_LENGTH_IN_35MM_FILM,
                    ExifInterface.TAG_FOCAL_PLANE_RESOLUTION_UNIT,
                    ExifInterface.TAG_FOCAL_PLANE_X_RESOLUTION,
                    ExifInterface.TAG_FOCAL_PLANE_Y_RESOLUTION,
                    ExifInterface.TAG_F_NUMBER,
                    ExifInterface.TAG_GAIN_CONTROL,
                    ExifInterface.TAG_GPS_DEST_BEARING,
                    ExifInterface.TAG_GPS_DEST_DISTANCE,
                    ExifInterface.TAG_GPS_DEST_LATITUDE,
                    ExifInterface.TAG_GPS_DEST_LONGITUDE,
                    ExifInterface.TAG_GPS_DIFFERENTIAL,
                    ExifInterface.TAG_GPS_SPEED,
                    ExifInterface.TAG_GPS_TRACK,
                    ExifInterface.TAG_JPEG_INTERCHANGE_FORMAT,
                    ExifInterface.TAG_JPEG_INTERCHANGE_FORMAT_LENGTH,
                    ExifInterface.TAG_LIGHT_SOURCE,
                    ExifInterface.TAG_MAX_APERTURE_VALUE,
                    ExifInterface.TAG_METERING_MODE,
                    ExifInterface.TAG_PHOTOMETRIC_INTERPRETATION,
                    ExifInterface.TAG_PIXEL_X_DIMENSION,
                    ExifInterface.TAG_PIXEL_Y_DIMENSION,
                    ExifInterface.TAG_PLANAR_CONFIGURATION,
                    ExifInterface.TAG_PRIMARY_CHROMATICITIES,
                    ExifInterface.TAG_REFERENCE_BLACK_WHITE,
                    ExifInterface.TAG_RESOLUTION_UNIT,
                    ExifInterface.TAG_ROWS_PER_STRIP,
                    ExifInterface.TAG_SAMPLES_PER_PIXEL,
                    ExifInterface.TAG_SATURATION,
                    ExifInterface.TAG_SCENE_CAPTURE_TYPE,
                    ExifInterface.TAG_SENSING_METHOD,
                    ExifInterface.TAG_SHARPNESS,
                    ExifInterface.TAG_SHUTTER_SPEED_VALUE,
                    ExifInterface.TAG_STRIP_BYTE_COUNTS,
                    ExifInterface.TAG_STRIP_OFFSETS,
                    ExifInterface.TAG_SUBJECT_AREA,
                    ExifInterface.TAG_SUBJECT_DISTANCE,
                    ExifInterface.TAG_SUBJECT_DISTANCE_RANGE,
                    ExifInterface.TAG_SUBJECT_LOCATION,
                    ExifInterface.TAG_THUMBNAIL_IMAGE_LENGTH,
                    ExifInterface.TAG_THUMBNAIL_IMAGE_WIDTH,
                    ExifInterface.TAG_TRANSFER_FUNCTION,
                    ExifInterface.TAG_WHITE_POINT,
                    ExifInterface.TAG_X_RESOLUTION,
                    ExifInterface.TAG_Y_CB_CR_COEFFICIENTS,
                    ExifInterface.TAG_Y_CB_CR_POSITIONING,
                    ExifInterface.TAG_Y_CB_CR_SUB_SAMPLING,
                    ExifInterface.TAG_Y_RESOLUTION,
            };
            HashMap<String, Object> exif24_str = getExif_str(exifInterface, tags_24_str);
            result.putAll(exif24_str);
            HashMap<String, Object> exif24_double = getExif_double(exifInterface, tags24_double);
            result.putAll(exif24_double);
        }


        String TAG_DATETIME = exifInterface.getAttribute(ExifInterface.TAG_DATETIME);
        String TAG_GPS_TIMESTAMP = exifInterface.getAttribute(ExifInterface.TAG_GPS_TIMESTAMP);
        long dateTime = formatTime(TAG_DATETIME, "yy:mm:dd hh:mm:ss");
        long gpsDateTime = formatTime(TAG_GPS_TIMESTAMP, "hh:mm:ss");
        if (dateTime != 0) result.put(ExifInterface.TAG_DATETIME, dateTime);
        if (gpsDateTime != 0) result.put(ExifInterface.TAG_GPS_TIMESTAMP, TAG_GPS_TIMESTAMP);

        return result;
    }

    private HashMap<String, Object> getExif_str(ExifInterface exifInterface, String[] tags){
        HashMap<String, Object> result = new HashMap<>();
        for (String tag : tags) {
            String attribute = exifInterface.getAttribute(tag);
            if (!TextUtils.isEmpty(attribute)) {
                result.put(tag, attribute);
            }
        }
        return result;
    }

    private HashMap<String, Object> getExif_double(ExifInterface exifInterface, String[] tags){
        HashMap<String, Object> result = new HashMap<>();
        for (String tag : tags) {
            double attribute = exifInterface.getAttributeDouble(tag, 0.0);
            if (attribute != 0.0) {
                result.put(tag, attribute);
            }
        }
        return result;
    }

    private long formatTime(String date_str, String format_str) {

        if (date_str == null) return 0;
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format_str, Locale.US);
            Date parse = null;
            parse = simpleDateFormat.parse(date_str);
            return parse.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void openImagePicker() {

        if (ContextCompat.checkSelfPermission(this.activity,
                Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this.activity,
                Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this.activity,
                Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this.activity,
                    new String[]{
                            Manifest.permission.READ_EXTERNAL_STORAGE,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE,
                            Manifest.permission.CAMERA
                    },
                    REQUEST_CODE_GRANT_PERMISSIONS);

        } else {
            presentPicker();
        }

    }

    private void refreshGallery(String path) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                MediaScannerConnection.scanFile(context, new String[]{path}, null, new MediaScannerConnection.OnScanCompletedListener() {
                    public void onScanCompleted(String path, Uri uri) {
                        finishWithSuccess(true);
                    }
                });
            } else {
                context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_MOUNTED, Uri.parse("file://" + Environment.getExternalStorageDirectory())));
                finishWithSuccess(true);
            }
        } catch (Exception e) {
            finishWithError("unknown error", e.toString());
        }
    }

    private void presentPicker() {
        int maxImages = MultiImagePickerPlugin.this.methodCall.argument(MAX_IMAGES);
        boolean enableCamera = MultiImagePickerPlugin.this.methodCall.argument(ENABLE_CAMERA);
        String packageName = context.getApplicationInfo().packageName;
        Matisse.from(MultiImagePickerPlugin.this.activity)
                .choose(MimeType.ofImage())
                .countable(true)
                .capture(enableCamera)
                .captureStrategy(
                        new CaptureStrategy(true, packageName + ".multiimagepicker.fileprovider")
                )
                .maxSelectable(maxImages)
                .restrictOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED)
                .imageEngine(new GlideEngine())
                .forResult(REQUEST_CODE_CHOOSE);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_CHOOSE && resultCode == Activity.RESULT_OK) {
            List<Uri> photos = Matisse.obtainResult(data);
            List<HashMap<String, Object>> result = new ArrayList<>(photos.size());
            for (Uri uri : photos) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("identifier", uri.toString());
                InputStream is = null;
                int width = 0, height = 0;

                try {
                    is = context.getContentResolver().openInputStream(uri);
                    BitmapFactory.Options dbo = new BitmapFactory.Options();
                    dbo.inJustDecodeBounds = true;
                    dbo.inScaled = false;
                    dbo.inSampleSize = 1;
                    BitmapFactory.decodeStream(is, null, dbo);
                    if (is != null) {
                        is.close();
                    }

                    int orientation = getOrientation(context, uri);

                    if (orientation == 90 || orientation == 270) {
                        width = dbo.outHeight;
                        height = dbo.outWidth;
                    } else {
                        width = dbo.outWidth;
                        height = dbo.outHeight;
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }

                map.put("width", width);
                map.put("height", height);
                result.add(map);
            }
            finishWithSuccess(result);
            return true;
        } else if (requestCode == REQUEST_CODE_GRANT_PERMISSIONS && resultCode == Activity.RESULT_OK) {
            presentPicker();
            return true;
        } else {
            finishWithSuccess(Collections.emptyList());
            clearMethodCallAndResult();
        }
        return false;
    }

    private static int getOrientation(Context context, Uri photoUri) {
        Cursor cursor = null;
        try {
            cursor = context.getContentResolver().query(photoUri,
                    new String[] { MediaStore.Images.ImageColumns.ORIENTATION }, null, null, null);

            if (cursor.getCount() != 1) {
                return -1;
            }

            cursor.moveToFirst();
            return cursor.getInt(0);
        } catch (CursorIndexOutOfBoundsException ignored) {

        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return -1;
    }

    private static Bitmap getCorrectlyOrientedImage(Context context, Uri photoUri) throws IOException {
        InputStream is = context.getContentResolver().openInputStream(photoUri);
        BitmapFactory.Options dbo = new BitmapFactory.Options();
        dbo.inScaled = false;
        dbo.inSampleSize = 1;
        dbo.inJustDecodeBounds = true;
        BitmapFactory.decodeStream(is, null, dbo);
        if (is != null) {
            is.close();
        }

        int orientation = getOrientation(context, photoUri);

        Bitmap srcBitmap;
        is = context.getContentResolver().openInputStream(photoUri);
        srcBitmap = BitmapFactory.decodeStream(is);
        if (is != null) {
            is.close();
        }

        if (orientation > 0) {
            Matrix matrix = new Matrix();
            matrix.postRotate(orientation);

            srcBitmap = Bitmap.createBitmap(srcBitmap, 0, 0, srcBitmap.getWidth(),
                    srcBitmap.getHeight(), matrix, true);
        }

        return srcBitmap;
    }

    private void finishWithSuccess(List imagePathList) {
        if (pendingResult != null)
            pendingResult.success(imagePathList);
        clearMethodCallAndResult();
    }

    private void finishWithSuccess(HashMap<String, Object> hashMap) {
        if (pendingResult != null)
            pendingResult.success(hashMap);
        clearMethodCallAndResult();
    }

    private void finishWithSuccess(Boolean result) {
        if (pendingResult != null)
            pendingResult.success(result);
        clearMethodCallAndResult();
    }

    private void finishWithAlreadyActiveError(MethodChannel.Result result) {
        if (result != null)
            result.error("already_active", "Image picker is already active", null);
    }

    private void finishWithError(String errorCode, String errorMessage) {
        if (pendingResult != null)
            pendingResult.error(errorCode, errorMessage, null);
        clearMethodCallAndResult();
    }

    private void clearMethodCallAndResult() {
        methodCall = null;
        pendingResult = null;
    }

    private boolean setPendingMethodCallAndResult(
            MethodCall methodCall, MethodChannel.Result result) {
        if (pendingResult != null) {
            return false;
        }

        this.methodCall = methodCall;
        pendingResult = result;
        return true;
    }
}
