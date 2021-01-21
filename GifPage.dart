import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

// é uma pagina que não vai ser alterada após carregar
class GifPage extends StatelessWidget {
  final Map _gifdata;

  GifPage(this._gifdata); // construtor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifdata["title"]), // pega o nome do gif atual
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share),
              onPressed: () {
                Share.share(_gifdata["images"]["fixed_height"]["url"]);
              }),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        // imagem do gif atual
        child: Image.network(_gifdata["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
