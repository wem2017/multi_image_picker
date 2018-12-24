# Basic Usage

> In the following example we will going to use a simple image picker.

main.dart

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'asset_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        return AssetView(index, images[index]);
      }),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on PlatformException catch (e) {
      error = e.message;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }
}
```

In the above example we've created a simple StatefulWidget with a button. When the button is pressed we 
invoke the image picker, specifying the maximum allowed number if images to be picked. The `pickImages`
method is asynchronious and returns array of `Asset` objects after the user makes their selection.

Once we have the `Asset` Objects, we can then display a preview of the picked images in a grid:

asset_view.dart

```dart
import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';

class AssetView extends StatefulWidget {
  final int _index;
  final Asset _asset;

  AssetView(this._index, this._asset);

  @override
  State<StatefulWidget> createState() => AssetState(this._index, this._asset);
}

class AssetState extends State<AssetView> {
  int _index = 0;
  Asset _asset;
  AssetState(this._index, this._asset);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    await this._asset.requestThumbnail(300, 300, quality: 50);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (null != this._asset.thumbData) {
      return Image.memory(
        this._asset.thumbData.buffer.asUint8List(),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return Text(
      '${this._index}',
      style: Theme.of(context).textTheme.headline,
    );
  }
}
```

Again we've created another StatefulWidget, which will be responsible for rendering
the image widget for each asset. To obtain the image data from `Asset` class, we invoke
the `requestThumbnail` method. Again this method is asychronuious so once it finishes we 
update the state of the widget with the thumb data. Since both `requestOriginal` and 
`requestThumbnail` methods return `ByteData`, you can use `Image.memory` widget to display
the images in the grid.