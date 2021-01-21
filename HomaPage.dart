import 'dart:convert';

import 'package:buscador_de_gif/ui/GifPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _serch;
  int _offset = 0;

  Future<Map> _GetGif() async {
    http.Response response;
    if (_serch == null) {
      response = await http.get(
          "link da api");
    } else {
      response = await http.get(
          "link da api");
      json.decode(response.body);
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  //função para criar um texto indicativo ao usuario
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                // quando terminar de digitar inicia a função
                setState(() {
                  // para atualizar o estado
                  // serch para  de ser nula e começa a ter uma string para busca
                  _serch = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
              // aumenta respeitando os espaços dos outros componentes
              child: FutureBuilder(
            future: _GetGif(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Container();
                  } else {
                    return _CreateGifTable(context, snapshot);
                  }
              }
            },
          ))
        ],
      ),
    );
  }

  int _GetCount(List data) {
    if(_serch == null || _serch.isEmpty){
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _CreateGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // quantos itens
            crossAxisSpacing: 10.0, //espaço entre um e outro
            mainAxisSpacing: 10.0),
        itemCount: _GetCount(snapshot.data["data"]),
        //como os itens serão organizados
        itemBuilder: (context, index) {
          if (_serch == null || index < snapshot.data["data"].length) {
            return GestureDetector(
              //função que deixa clicar em cima da imagem
              // função fade trará imagens mais suaves
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]);
              },
            );
          } else {
            return Container(
              // novo botão para chamar mais gifs
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70.0,
                    ),
                    Text(
                      "Carregar mais..",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    )
                  ],
                ),
                onTap: () {
                  // ao clicar adiciona mais 19
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        });
  }
}
