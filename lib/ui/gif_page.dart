import 'package:flutter/material.dart';
import 'package:share/share.dart';
class  Gifpage extends StatelessWidget {
   final Map _gifdata;
   Gifpage(this._gifdata);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(_gifdata["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share),
              onPressed: (){
            Share.share( _gifdata["images"]["fixed_height"]["url"]);
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          _gifdata["images"]["fixed_height"]["url"]

        ),
      ),
    );
  }
}
