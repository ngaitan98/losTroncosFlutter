import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import 'colorPalette.dart';

final palette = new ColorPalette();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Los Troncos Wood Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  Future _scanCode() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", false, ScanMode.QR)
         .listen((barcode) { 
         print("Barcode $barcode");
         requestBlockInfo(barcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: palette.getHeaderColor(),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text("Log ID (Usually found printed in the log):",
                style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold),),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'The id is Emty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: ButtonTheme(
                      minWidth: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {}
                        },
                        child: Text("Submit"),
                        color: palette.getPrimaryColor(),
                        textColor: Colors.white,
                      )))
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanCode,
        tooltip: 'Scan Qr',
        icon: Icon(Icons.camera_alt),
        label: Text('Scan QR'),
        backgroundColor: palette.getPrimaryColor(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future requestBlockInfo(String _url) async {
    if (!_url.contains("http://13.59.89.246:3000/")) {
      Toast.show("This log has an invalid URL.", context,
          gravity: Toast.BOTTOM,
          backgroundColor: palette.getErrorColor(),
          textColor: Colors.black,
          duration: Toast.LENGTH_LONG);
    } else {
      var response = await get(_url);
      if (response.statusCode != 200) {
        Toast.show(
            "This log has is not in the database.\nSomething's wrong", context,
            gravity: Toast.BOTTOM,
            backgroundColor: palette.getErrorColor(),
            textColor: Colors.black,
            duration: Toast.LENGTH_LONG);
      }else{
        Toast.show(
            "This log has is not in the database.\nSomething's wrong", context,
            gravity: Toast.BOTTOM,
            backgroundColor: palette.getErrorColor(),
            textColor: Colors.black,
            duration: Toast.LENGTH_LONG);
      }
    }
  }
}
