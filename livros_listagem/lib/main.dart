import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://raw.githubusercontent.com/Gabrielksi/arquivo-json-e-imagens/master/db.json";

List data;

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
        future: dados(),
        builder: (context, snapShot) {
          switch (snapShot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando...",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              );
            default:
              if (snapShot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao iniciar conexão",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                );
              } else {
                return _minhaListView();
              }
          }
        },
      ),
    );
  }
}

Widget _card(item) {
  return Container(
      margin: EdgeInsets.all(8),
      child: ListTile(
          title: Card(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  /*Padding(
                    child: Image.network(src),
                    padding: EdgeInsets.only(bottom: 8),
                  ),*/
                  ListTile(
                    title: Text(item['biblioteca']['titulo']),
                    subtitle: Text(item['biblioteca']['autor']),
                  )
                ],
              ),
            ),
          )
      )
  );
}

Widget _minhaListView() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemBuilder: (context, index) {
      return _card(data[index]);
    },
    itemCount: data == null ? 0 : data.length,
  );
}

Future<Map> dados() async {
  http.Response response = await http.get(request);
  /*var jsonResponse = json.decode(response.body);
  setState((){
    data = jsonResponse['biblioteca'];
  });*/
  //data = json.decode(response.body);
  return json.decode(response.body);
}
