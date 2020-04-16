import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class qtBiblePage extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebView(
      initialUrl: 'https://sum.su.or.kr:8888/bible/today',
      javascriptMode: JavascriptMode.unrestricted,
    ); 
  }
}

// return Scaffold(
//       body: Container(
//         child: new Column(
//           children: <Widget>[
//             new WebView(
//               initialUrl: 'https://sum.su.or.kr:8888/bible/today',
//               javascriptMode: JavascriptMode.unrestricted,
//             ),  
//           ],
//         ),
//       ),
//     );