import 'package:encrypt/encrypt.dart'as encrypt;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newfcheckproject/offlineDatabase/sqfLiteDatabase.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:newfcheckproject/home/healthDeclaration.dart';

var eId;
var sbu;
var department;
var fullName;

var colorTimeIn = Colors.transparent,
    colorTimeOut = Colors.transparent,
    colorTimeBreakOut = Colors.transparent,
    colorTimeBreakIn = Colors.transparent;

sessionEmployeeId1(setState)async{
  var datas =[];
  var eid = await sessionEmployeeId();
  datas = await DBProvider.db.getAllData();
  setState((){
    fullName = datas[0]["employeeName"];
    sbu = datas[0]["sbu"];
    department = datas[0]["department"].toString();
    eId = eid;
  });
}
/*void encrypt(int option,int key)
{

}*/


encryptdata(){
  var data = "$eId,"
      "$fullName,"
      "Time: $inout,"
      "$department,"
      "$sbu";
 /* final key = encrypt.Key.fromUtf8('aBcDeFgHiJkLmNoPqRsTuVwxYz035725');
  final iv = encrypt.IV.fromLength(0);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encrypted = encrypter.encrypt(data, iv: iv);


*/
  var keySTR = "qwertyuiopasdfgh"; //16 byte
  var ivSTR = "qwertyuiopasdfgh"; //16 byte

  final key = encrypt.Key.fromUtf8(keySTR);
  final iv = encrypt.IV.fromUtf8(ivSTR);
  final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc,padding: 'PKCS7'));
  final encrypted = encrypter.encrypt(data, iv: iv);
  //final decrypted = encrypter.decrypt(encrypted, iv: iv);
  //print('decrypted:'+decrypted);
  //print('encrypted.base64:'+encrypted.base64);

 return encrypted.base64;

}
var selectedSlider = 0;
var val = false;
OfficeSLider(int slider){
  selectedSlider = slider;

 /* if(selectedSlider == 0){
    inout = true;
  }else{
    inout = false;
  }*/
}

// double size = 300;
// double sizeh = 200;
// double size1 = 0;
// double sizeh1 = 0;
//bool inout = true;
  var inout = "in";
officeWidget(setState,context,TabController btnOffice){

  return Center(
    child: Column(
      children: [
        const SizedBox(height: 50,),
        const Text("Scan QR Code",
          style:  TextStyle(
              color:Colors.blueAccent ,
              fontSize: 20,
              fontWeight: FontWeight.bold),),
        // QrImage(
        //   data: encryptdata(),
        //   version: QrVersions.auto,
        //   size: 300.0,),

const SizedBox( height:20,),
Container(
  height: 250,
  child:   Column(

    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

    children: [

      Row(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [

          GestureDetector(
            onTap: (){
              inout = "in";
              setState((){
                colorTimeIn = Colors.blueAccent.withOpacity(0.3);
                colorTimeOut = Colors.transparent;
                colorTimeBreakOut = Colors.transparent;
                colorTimeBreakIn = Colors.transparent;
                print(inout);
              });
            },
            child: Container(
                width: 80,
                height: 80,
              decoration: BoxDecoration(
                border:const Border.fromBorderSide(BorderSide(color: Colors.black)),
                color: colorTimeIn
              ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Icon(Icons.timer_sharp,color: Colors.green),
                     Text("Time in")
                  ],
                )),
          ),

          GestureDetector(
            onTap: (){
              inout = "out";
              setState((){
              colorTimeIn = Colors.transparent;
              colorTimeOut = Colors.blueAccent.withOpacity(0.3);
              colorTimeBreakOut = Colors.transparent;
              colorTimeBreakIn = Colors.transparent;
              print(inout);
              });

            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: const Border.fromBorderSide(BorderSide(color: Colors.black)),
                  color: colorTimeOut
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:const [
                  Icon(Icons.timer_off_outlined,color: Colors.red,),
                  Text("Time Out")
                ],
              ),
            ),
          )

        ],

      ),

      Row(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [

          GestureDetector(
            onTap: (){
              inout = "Break Out";
              setState((){
                colorTimeIn = Colors.transparent;
                colorTimeOut = Colors.transparent;
                colorTimeBreakOut = Colors.blueAccent.withOpacity(0.3);
                colorTimeBreakIn = Colors.transparent;
                print(inout);
              });
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: const Border.fromBorderSide(BorderSide(color: Colors.black)),
                  color: colorTimeBreakOut,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:const [
                  Icon(Icons.free_breakfast_outlined,color: Colors.green),
                  Text("Break Out")
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              inout = "Break In";
              setState((){
                colorTimeIn = Colors.transparent;
                colorTimeOut = Colors.transparent;
                colorTimeBreakOut = Colors.transparent;
                colorTimeBreakIn = Colors.blueAccent.withOpacity(0.3);
                print(inout);
              });
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: const Border.fromBorderSide(BorderSide(color: Colors.black)),
                  color: colorTimeBreakIn
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:const [
                  Icon(Icons.free_breakfast,color: Colors.red),
                  Text("Break In")
                ],
              ),
            ),
          )
        ],
      )
    ],

  ),
)

    // Container(
    //   width: MediaQuery.of(context).size.width,
    //   height: 200,
    //   child:   TabBarView(physics: BouncingScrollPhysics(),controller: btnOffice,
    //       children: [
    //         GestureDetector(
    //           onTap: (){
    //             setState((){
    //              btnOffice.index = 1;
    //             });
    //
    //           },
    //           child:  Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //             Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text("Break Time", style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,
    //                   color: Colors.red)),
    //                   SizedBox(
    //                     width: 140,
    //                     height: 100,
    //                     child: FittedBox(
    //                       fit: BoxFit.fill,
    //                       child:  Switch(
    //                           activeColor: Colors.red,
    //                           inactiveThumbColor: Colors.green,
    //                           inactiveTrackColor: Colors.green,
    //                           value: val,
    //                           onChanged: (value){
    //                             setState((){
    //                               val = value;
    //                             });
    //
    //                           }),
    //                     ),
    //                   ),
    //
    //                   // Text("Time Out",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
    //                   //     color: Colors.red.withOpacity(0.2)) ),
    //                 ],
    //               ),
    //             )
    //             ],
    //           ),
    //         ),
    //
    //         GestureDetector(
    //           onTap: (){
    //             setState((){
    //               btnOffice.index = 0;
    //             });
    //
    //           },
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: const[
    //               Icon(Icons.timer_off_outlined,
    //                 size: 50,color: Colors.red,),
    //               Text("Time Out",
    //                 style: TextStyle(
    //                     color: Colors.red,fontSize: 30
    //                 ),),
    //             ],
    //           ),
    //         ),
    //
    //   ]),
    // )
    //



        /*Container(
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red.shade400
          ),
          child: TextButton(
            child: Text("Time ${inout? "in":"out"}",
                style:const TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold)),
            onPressed: (){

              setState((){inout = !inout;});
            },
          ),
        ),*/

/*    AnimatedSize(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 1000),
      child:  Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(1000))
          ),
        width: size,
          height: sizeh,
          child: TextButton(
            child: Text(size==0?"":"Time In",
                style:const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )),
          onPressed: (){
            setState(() {
              inout = false;
                size = 0;
                sizeh = 0;
                size1 = 300;
                sizeh1 =200;


            });
          },)
      ),
    ),
        AnimatedSize(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 1000),
          child:  Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(1000))
            ),
              width: size1,
              height: sizeh1,
              child: TextButton(
                child: Text(size1==0?"":"Time Out",
                  style:const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),),
                onPressed: (){
                  setState(() {
                    inout = true;
                    size1 = 0;
                    sizeh1 =0;
                    size = 300;
                    sizeh =200;

                  });
                },)
          ),
        ),*/

      ],
    ),
  );
}