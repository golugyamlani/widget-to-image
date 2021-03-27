import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: screenShotAndShare,
          ),
        ],
        title: Text('Best Jujutsu Sorcerer'),
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://static.wikia.nocookie.net/jujutsu-kaisen/images/e/ef/Satoru_Gojo_%28Anime_2%29.png/revision/latest?cb=20201025013634',
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Gojo Satoru',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> screenShotAndShare() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      if (boundary.debugNeedsPaint) {
        Timer(Duration(seconds: 1), () => screenShotAndShare());
        return null;
      }
      ui.Image image = await boundary.toImage();
      final directory = (await getExternalStorageDirectory()).path;
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      // print('Screenshot Path:' + imgFile.path);
      final RenderBox box = context.findRenderObject();
      Share.shareFiles(
        ['$directory/screenshot.png'],
        // subject: 'Screenshot + Share',
        // text: 'Hey, check it out the sharefiles repo!',
        // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    } on PlatformException catch (e) {
      print("Exception while taking screenshot:" + e.toString());
    }
  }
}
