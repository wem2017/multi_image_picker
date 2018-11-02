package com.vitanov.multiimagepicker;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
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
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import android.Manifest;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

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
public class MultiImagePickerPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {
    public interface Refresh {
        void after() ;
    }

    private static final String CHANNEL_NAME = "multi_image_picker";
    private static final String REQUEST_THUMBNAIL = "requestThumbnail";
    private static final String REQUEST_ORIGINAL = "requestOriginal";
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

    private MultiImagePickerPlugin(Activity activity, Context context, MethodChannel channel, BinaryMessenger messenger) {
        this.activity = activity;
        this.context = context;
        this.channel = channel;
        this.messenger = messenger;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
        MultiImagePickerPlugin instance = new MultiImagePickerPlugin(registrar.activity(), registrar.context(), channel, registrar.messenger());
        registrar.addActivityResultListener(instance);
        channel.setMethodCallHandler(instance);
    }

    private class GetThumbnailTask extends AsyncTask<String, Void, Void> {
        BinaryMessenger messenger;
        String identifier;
        int width;
        int height;

        public GetThumbnailTask(BinaryMessenger messenger, String identifier, int width, int height) {
            super();
            this.messenger = messenger;
            this.identifier = identifier;
            this.width = width;
            this.height = height;
        }

        @Override
        protected Void doInBackground(String... strings) {
            final Uri uri = Uri.parse(this.identifier);
            InputStream stream = null;
            byte[] byteArray = null;

            try {
                stream = context.getContentResolver().openInputStream(uri);
                BitmapFactory.Options bitmapOptions = new BitmapFactory.Options();
                bitmapOptions.inSampleSize = 10;
                Bitmap bitmap = ThumbnailUtils.extractThumbnail(BitmapFactory.decodeStream(stream), this.width, this.height, OPTIONS_RECYCLE_INPUT);
                ByteArrayOutputStream bitmapStream = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.JPEG, 20, bitmapStream);
                byteArray = bitmapStream.toByteArray();
                bitmap.recycle();

            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } finally {
                try {
                    stream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            final ByteBuffer buffer = ByteBuffer.allocateDirect(byteArray.length);
            buffer.put(byteArray);
            this.messenger.send("multi_image_picker/image/" + this.identifier, buffer);
            return null;
        }
    }

    private class GetImageTask extends AsyncTask<String, Void, Void> {
        BinaryMessenger messenger;
        String identifier;

        public GetImageTask(BinaryMessenger messenger, String identifier) {
            super();
            this.messenger = messenger;
            this.identifier = identifier;
        }

        @Override
        protected Void doInBackground(String... strings) {
            final Uri uri = Uri.parse(this.identifier);
            byte[] bytesArray = null;
            InputStream stream = null;

            try {
                stream = context.getContentResolver().openInputStream(uri);
                stream.read(bytesArray);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    stream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            final ByteBuffer buffer = ByteBuffer.allocateDirect(bytesArray.length);
            buffer.put(bytesArray);
            this.messenger.send("multi_image_picker/image/" + this.identifier, buffer);
            return null;
        }
    }

    @Override
    public void onMethodCall(final MethodCall call, final Result result) {

        if (!setPendingMethodCallAndResult(call, result)) {
            finishWithAlreadyActiveError();
            return;
        }

        if (PICK_IMAGES.equals(call.method)) {
            openImagePicker();
        } else if (REQUEST_ORIGINAL.equals(call.method)) {
            final String identifier = call.argument("identifier");
            GetImageTask task = new GetImageTask(this.messenger, identifier);
            task.execute("");
            finishWithSuccess(true);

        } else if (REQUEST_THUMBNAIL.equals(call.method)) {
            final String identifier = call.argument("identifier");
            final Integer width = call.argument("width");
            final Integer height = call.argument("height");
            GetThumbnailTask task = new GetThumbnailTask(this.messenger, identifier, width, height);
            task.execute("");
            finishWithSuccess(true);


        } else if (REFRESH_IMAGE.equals(call.method)) {
            String path = call.argument("path") ;
            refreshGallery(path);
        } else {
            pendingResult.notImplemented();
        }
    }

    private void openImagePicker() {

        if (ContextCompat.checkSelfPermission(this.activity,
                Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this.activity,
                Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(this.activity,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE},
                    REQUEST_CODE_GRANT_PERMISSIONS);
            clearMethodCallAndResult();
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
        Matisse.from(MultiImagePickerPlugin.this.activity)
                .choose(MimeType.ofImage())
                .countable(true)
                .capture(enableCamera)
                .captureStrategy(
                    new CaptureStrategy(true, "com.vitanov.multiimagepicker.fileprovider")
                )
                .maxSelectable(maxImages)
                .restrictOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED)
                .imageEngine(new GlideEngine())
                .forResult(REQUEST_CODE_CHOOSE);
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == REQUEST_CODE_GRANT_PERMISSIONS && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            openImagePicker();
        }

        return true;
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
                Integer width = 0;
                Integer height = 0;
                try {
                    is = context.getContentResolver().openInputStream(uri);
                    BitmapFactory.Options dbo = new BitmapFactory.Options();
                    dbo.inJustDecodeBounds = true;
                    BitmapFactory.decodeStream(is, null, dbo);
                    is.close();
                    width = dbo.outWidth;
                    height = dbo.outHeight;
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
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

    private void finishWithSuccess(List imagePathList) {
        if (pendingResult != null)
            pendingResult.success(imagePathList);
        clearMethodCallAndResult();
    }

    private void finishWithSuccess(Boolean result) {
        if (pendingResult != null)
            pendingResult.success(result);
        clearMethodCallAndResult();
    }

    private void finishWithAlreadyActiveError() {
        finishWithError("already_active", "Image picker is already active");
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
