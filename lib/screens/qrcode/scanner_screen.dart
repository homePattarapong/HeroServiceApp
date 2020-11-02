import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatefulWidget {
  ScannerScreen({Key key}) : super(key: key);

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // สร้าง Object สำหรับเรียกตัวแสกน QR
  QRViewController _controller;
  GlobalKey _qrKey = GlobalKey();
  bool _flashOn = false;
  bool _frontCam = false;

  File _image;
  String _data = '';
  String _qrcodeFile = '';

  Future getImage() async {
    var image = await ImagePickerSaver.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      Fluttertoast.showToast(
          msg: _image.toString(),
          toastLength: Toast.LENGTH_SHORT, // duration time ระยะเวลาการแสดง
          gravity: ToastGravity.BOTTOM, // posiotion
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QRView(
            key: _qrKey,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderLength: 15.0,
                borderWidth: 5.0,
                borderRadius: 2.0),
            onQRViewCreated: (QRViewController controller) {
              this._controller = controller;
              //รับค่ามาใช้งาน
              controller.scannedDataStream.listen((val) {
                print(val);
                if (mounted) {
                  Fluttertoast.showToast(
                      msg: val,
                      toastLength:
                          Toast.LENGTH_SHORT, // duration time ระยะเวลาการแสดง
                      gravity: ToastGravity.BOTTOM, // posiotion
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  _controller.dispose();
                  // ปิดหน้า scan
                  _launchInBrowser(val);

                  Navigator.pop(context);
                }
              });
            }),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 60.0),
            child: Text(
              'วางคิวอาร์โค้ดให้อยู่ในกรอบเพื่อสแกน',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(bottom: 100.0),
              child: OutlineButton(
                onPressed: _getPhotoByGallery,
                child: Text(
                  'นำเข้าจากแกลอรี่',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                borderSide: BorderSide(color: Colors.white),
                shape: StadiumBorder(),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    color: Colors.white,
                    icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
                    onPressed: () {
                      setState(() {
                        _flashOn = !_flashOn;
                        _controller.toggleFlash();
                      });
                    }),
                IconButton(
                    color: Colors.white,
                    icon: Icon(
                        _frontCam ? Icons.camera_front : Icons.camera_rear),
                    onPressed: () {
                      setState(() {
                        _frontCam = !_frontCam;
                        _controller.flipCamera();
                      });
                    }),
                IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _getPhotoByGallery() {
    Observable.fromFuture(
            ImagePickerSaver.pickImage(source: ImageSource.gallery))
        .flatMap((file) {
      setState(() {
        _qrcodeFile = file.path;
      });
      return Observable.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path));
    }).listen((data) {
      setState(() {
        _data = data;
        Fluttertoast.showToast(
            msg: _data.toString(),
            toastLength: Toast.LENGTH_SHORT, // duration time ระยะเวลาการแสดง
            gravity: ToastGravity.BOTTOM, // posiotion
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      setState(() {
        _data = '';
      });
      print('${error.toString()}');
    });
  }

  // ฟังก์ชันสำหรับการ Launcher Web Screen
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      // throw 'Could not launch $url';
      Fluttertoast.showToast(
          msg: 'Could not launch $url',
          toastLength: Toast.LENGTH_SHORT, // duration time ระยะเวลาการแสดง
          gravity: ToastGravity.BOTTOM, // posiotion
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
