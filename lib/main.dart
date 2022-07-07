import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/webView.dart';

import './theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';


void main() {
  runApp(
    ChangeNotifierProvider<DynamicTheme>(
      create: (_) => DynamicTheme(),
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeProvider.getDarkMode() ? ThemeData.dark() : ThemeData.light(),
        home: HomePage()
    );
  }
}





class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String result = "a";
  bool resultScanned = false;
  TapGestureRecognizer? _flutterTapRecognizer;
  Future _scanQR() async {
    try {
      ScanResult qrResult = await BarcodeScanner.scan();

      setState(() {
        result = qrResult.rawContent;
      });
      Navigator.push(context, (MaterialPageRoute(builder: (context) => WebViewPage(url: result))));
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result = "CAMERA permission denied!";
        });
      } else {
        setState(() {
          result = "$ex Error occurred.";
        });
      }
    } on FormatException {
      setState(() {
        result = "Nothing scanned!";
      });
    } catch (ex) {
      setState(() {
        result = "$ex Error occured.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _flutterTapRecognizer = new TapGestureRecognizer()
      ..onTap = () => Navigator.push(context, (MaterialPageRoute(builder: (context) => WebViewPage(url: result))));
  }

  @override
  void dispose() {
    _flutterTapRecognizer?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicTheme>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: CircleAvatar(
                child: Image.asset(
                  'images/img.png',
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 60, 140, 231),
                    Color.fromARGB(255, 0, 234, 255),
                  ],
                ),
              ),
            ),
            Divider(
              height: 2.0,
            ),
            ListTile(
              title: Center(
                child: Text('Vipin Gupta'),
              ),
              onTap: () {
                // Navigator.pop(context);
              },
            ),
            Divider(
              height: 2.0,
            ),
            Builder(
              builder: (context) => ListTile(
                title: Text('Toggle Dark mode'),
                leading: Icon(Icons.brightness_4),
                onTap: () {
                  setState(() {
                    themeProvider.changeDarkMode(!themeProvider.isDarkMode);
                  });
                  Navigator.pop(context);
                },
                trailing: CupertinoSwitch(
                  value: themeProvider.getDarkMode(),
                  onChanged: (value) {
                    setState(() {
                      themeProvider.changeDarkMode(value);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Divider(
              height: 2.0,
            ),
            Builder(
              builder: (context) => ListTile(
                leading: Icon(Icons.open_in_browser),
                title: new InkWell(
                    child: Text('Visit my website!'),
                    onTap: () {
                      launch('https://nameisvipin.github.io/porfolioCV/');
                      Navigator.pop(context);
                    }),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Divider(
              height: 2.0,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("QR Scan"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(
              "Press scan to scan the QR code",
              style: new TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: "IBM Plex Sans",
              ),
              textAlign: TextAlign.center,
            ),

          ),
          resultScanned
              ? AlertDialog(
            title: const Text('Result'),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: result,
                    recognizer: _flutterTapRecognizer,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(),
                      ),
                          (Route route) => route == null);
                },
                textColor: Theme.of(context).primaryColor,
                child: const Text('Okay, got it!'),
              ),
            ],
          )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
