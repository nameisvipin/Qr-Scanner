import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;


  const WebViewPage({super.key, required this.url});


  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Scan Result'),
        centerTitle: true,),
      body: Stack(
        children: [
          WebView(

            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
            onPageFinished: (finish){
              setState((){
                isLoading=false;
              });
            },
          ),
          isLoading?Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Please wait..',style: TextStyle(color: Colors.black,fontSize: 20),),
              SizedBox(height: 20,),
              CircularProgressIndicator(),
            ],
          ),):Stack()
        ],
      ) ,
    );
  }
}