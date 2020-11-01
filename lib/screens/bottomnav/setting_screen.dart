import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  // สร้างตัวแปรไว้เก็บชื่อ และรูปโปรไฟล์
  String _fullname, _avatar;

  // สร้าง Obj3ct Shareperferences
  SharedPreferences sharedPreferences;

  // อ่านข้อมูลผู้ใช้จาก SharedPreferences
  getProfile() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _fullname = sharedPreferences.getString('storeFullname');
      _avatar = sharedPreferences.getString('storeAvatar');

    });
  }

  // ฟังก์ชันเช็คการเชื่อมต่อ network
  checkNetwork() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.wifi){
      Fluttertoast.showToast(
        msg: "คุณกำลังเชื่อมต่อผ่าน Wifi",
        toastLength: Toast.LENGTH_SHORT, // duration time ระยะเวลาการแสดง
        gravity: ToastGravity.BOTTOM, // posiotion
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }else if(result == ConnectivityResult.mobile){
      Fluttertoast.showToast(
        msg: "คุณกำลังเชื่อมต่อผ่าน 3G/4G",
        toastLength: Toast.LENGTH_SHORT, // duration time ระยะเวลาการแสดง
        gravity: ToastGravity.BOTTOM, // posiotion
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }else if(result == ConnectivityResult.none){
      Fluttertoast.showToast(
        msg: "คุณไม่ได้เชื่อมต่ออินเตอร์เน็ต",
        toastLength: Toast.LENGTH_SHORT, // duration time ระยะเวลาการแสดง
        gravity: ToastGravity.BOTTOM, // posiotion
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }

  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 180.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg/bg_account.jpg'),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    child: _avatar != null ? CircleAvatar(
                      radius: 46.0,
                      // backgroundImage:AssetImage('assets/images/bg/avatar.jpg'),
                      backgroundImage: NetworkImage('$_avatar'),
                    ): CircularProgressIndicator(),
                  ),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Center(
                    child: Text(
                  '$_fullname',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),
                ))
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('ข้อมูลผู้ใช้'),
            onTap: () {
              Navigator.pushNamed(context, '/userprofile');
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('เปลี่ยนรหัสผ่าน'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('เปลี่ยนภาษา'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('ติดต่อทีมงาน'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('ตั้งค่าใช้งาน'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('ออกจากระบบ'),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
