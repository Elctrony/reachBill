import 'dart:io';

import 'package:flutter/material.dart';

class AssetView extends StatefulWidget {
  final int _index;
  final File _asset;

  AssetView(this._index, this._asset);

  @override
  State<StatefulWidget> createState() => AssetState(this._index, this._asset);
}

class AssetState extends State<AssetView> {
  int _index = 0;
  File _asset;
  AssetState(this._index, this._asset);

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (null != this._asset) {
      return Image.file(
        this._asset,
        fit: BoxFit.cover,
      );
    }

    return Text(
      '${this._index}',
      style: Theme.of(context).textTheme.headline,
    );
  }
}
