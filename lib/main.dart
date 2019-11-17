import 'package:animated_qr_code_scanner/AnimatedQRViewController.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'tronco/tronco.dart';
import 'colorPalette.dart';
import 'package:animated_qr_code_scanner/animated_qr_code_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:convert';
final palette = new ColorPalette();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Los Troncos',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = AnimatedQRViewController();
  PanelController _pc = new PanelController();
  String estado = "Inicial";
  Tronco troncoActual = new Tronco("ncdodoe", 74.33498, 4.32222, "Roble", "Tablón");
  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      AnimatedQRView(
        squareColor: Colors.grey.withOpacity(0.25),
        squareBorderColor: Colors.grey,
        animationDuration: const Duration(seconds: 4),
        onScan: (String str) async {
          controller.resume();
          if(!str.contains("ENDPOINT")){
            estado = "error";
          }
          else{
            Response res = await get(str);
            if(res.statusCode != 200 && res.statusCode != 500){
              estado = "error";
            }
            else{
              estado = "validated";
              Map<String, String> parsedResponse = TextEditingValue.fromJSON(json.decode(res.body)).toJSON();
              troncoActual = new Tronco(parsedResponse["id"],double.parse(parsedResponse["lat"]), double.parse(parsedResponse["lon"]), parsedResponse["especie"], parsedResponse["estado"]);
            }
          }
          
        },
        controller: controller,
      ),
    ];
    if (estado == "validated") {
      children.add(Opacity(
        opacity: 0.5,
        child: const ModalBarrier(dismissible: false, color: Colors.green),
      ));
    } else if (estado == "error") {
      children.add(Opacity(
        opacity: 0.5,
        child: const ModalBarrier(dismissible: false, color: Colors.red),
      ));
    }
    var panel = troncoActual != null? SlidingUpPanel(
      maxHeight: 575.0,
      minHeight: 95.0,
      parallaxEnabled: false,
      controller: _pc,
      body: Stack(children: children),
      panel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 18.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                troncoActual.id,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),              
          Text("[lat,lon]")
        ],
      ),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
    ):null;
    try {
      if (estado == "Inicial") {
        _pc.hide();
      } else {
        _pc.show();
      }
    } catch (error) {}
    return Scaffold(
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          ListTile(
            title: Text('Ingresar Código'),
            onTap: () {
              //Agregar view para leer input
            },
          )
        ])),
        body: panel);
  }
}