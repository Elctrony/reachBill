import 'dart:io';
import '../main.dart';

import 'package:flutter/material.dart';

class AssetView extends StatefulWidget {
  final int _index;
  final String imageName;

  AssetView(this._index, this.imageName);

  @override
  State<StatefulWidget> createState() => AssetState(this._index, this.imageName);
}

class AssetState extends State<AssetView> {
  int _index = 0;
  String imageName;
  AssetState(this._index, this.imageName);

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (null != this.imageName) {
      return Image(image: NetworkImage(getUrl("/images/$imageName"),scale: 1),fit: BoxFit.cover,);
    }
    return Text(
      '${this._index}',
      style: Theme.of(context).textTheme.headline,
    );
  }
}
