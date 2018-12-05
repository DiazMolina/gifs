import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:sreach_gif/ui/gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _offset = 0;
  String _urlTrending =
      "https://api.giphy.com/v1/gifs/trending?api_key=kB32f4euagB0ySUgj4pB7wkyN1r1ipAM&limit=20&rating=G";
  Future<Map> _getGif() async {
    http.Response response;
    if (_search == null)
      response = await http.get(_urlTrending);
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=kB32f4euagB0ySUgj4pB7wkyN1r1ipAM&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGif().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "busque aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset =0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGif(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container(
                        );
                      else
                        return _createGitTable(context, snapshot);
                  }
                }),
          ),
        ],
      ),
    );
  }
 int _getCount(List data){
    if(_search == null){
      return data.length;
    }else{
      return data.length +1;
    }
 }

  Widget _createGitTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context,index){
          if(_search == null || index <snapshot.data["data"].length)
            return GestureDetector(
             child: FadeInImage.memoryNetwork(
                 placeholder: kTransparentImage,
                 height: 300.0,
                 fit: BoxFit.cover,
                 image: snapshot.data["data"][index]["images"]["fixed_height"]["url"]),

              onTap:(){
               Navigator.push(context, 
                 MaterialPageRoute(builder: (context)=>Gifpage(snapshot.data["data"][index]))
               );
              } ,
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
          );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add,color: Colors.white,size: 70.0),
                    Text("Cargar mas..",style: TextStyle(
                      color: Colors.white, fontSize: 20.0
                    )),
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offset +=19;
                  });
                },
              ),
            );
        });
  }
}
