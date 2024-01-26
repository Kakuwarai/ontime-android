// import 'dart:convert';
//
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:newfcheckproject/home/healthDeclaration.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:newfcheckproject/offlineDatabase/sqfLiteDatabase.dart';
// import 'package:ntp/ntp.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../home/homeScreen.dart';
//
// var dateTimeDate = [];
// var timeIn ="--:--",
//     timeOut="--:--",
//     totalTime = "--:--";
// List<Placemark> placemarks = [];
// main(context) async{
//   LocationPermission permission;
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//
//     if (permission == LocationPermission.denied) {
//       perms(context);
//
//     }
//   }
//   try{
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//     placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//   }catch(e){
//     print("error");
//   }
// }
//
//
//   Future<bool?> perms(BuildContext context) async {
//     showDialog<bool>(
//       context: context,
//       builder: (context) =>  AlertDialog(
//         title: const Text("are you sure?",style: TextStyle(fontSize: 15),),
//         actions: [
//
//           ElevatedButton(onPressed: () async{
//             await Geolocator.openAppSettings();
//             await Geolocator.openLocationSettings();
//             Navigator.pop(context, true);
//           },
//               child: const Text('Open')
//           ),
//         ],
//       ),
//     );
//
//     return null;
//   }
//
// getDataWFH(setState)async{
//
//   //await DBProvider.db.getEmployeesData("id");
//   var d = await NTP.now();
//   var dateTime = DateFormat("yyyy/MM/dd").format(d).toString();
//   var response = await http.post(
//       Uri.parse("${apiLink()}api/FcAttendances/gettimeinout"),
//       body: {
//          "employeeId":(await DBProvider.db.getEmployeesData("Id")).toString(),
//         "getDate":dateTime
//       });
//
//   if (response.statusCode == 200) {
//     try{
//       dateTimeDate = await jsonDecode(response.body) as List;
//       timeIn = dateTimeDate[dateTimeDate.length-1]['timeIn'].toString();
//       if(dateTimeDate[dateTimeDate.length-1]['timeOut'].toString() != "null"){
//         timeOut = dateTimeDate[dateTimeDate.length-1]['timeOut'].toString();
//         totalTime = dateTimeDate[dateTimeDate.length-1]['totalTime'].toString();
//       }else{
//         isTimeinClicked = true;
//       }
//     }catch(e){
//       timeIn = "--:--";
//     }
//
//    /* location = "${placemarks[0].street},"
//         "${placemarks[0].subLocality},"
//         "${placemarks[0].locality},";*/
//
// setState((){});
//   }
// }
// bool isTimeinClicked = false,
// wait = false;
// var location = "";
// getTimeIn(setState,context)async{
//   setState((){wait = true;});
//   await main(context);
//   var datetimenow = await NTP.now();
//
//   var allData = await DBProvider.db.getAllData();
//   var response = await http.post(
//       Uri.parse("${apiLink()}api/FcAttendances/WFHTimeIn"),
//       body: {
//         "employeeId":(allData[0]['employeeId']).toString(),
//         "workPlace": "WFH",
//         "TimeIn": DateFormat("hh:mm a").format(datetimenow).toString(),
//         "TimeOut":"",
//         "LocationIn":"${placemarks[0].street},"
//             "${placemarks[0].subLocality},"
//             "${placemarks[0].locality},"
//             "${placemarks[0].administrativeArea},"
//             "${placemarks[0].country}",
//         "department": allData[0]['department'],
//         "sbu": allData[0]['sbu'],
//         "date":DateFormat("yyyy/MM/dd").format(datetimenow).toString(),
//       });
//   if (response.statusCode == 200) {
//     timeIn = response.body.toString();
//     isTimeinClicked = true;
//     location = "${placemarks[0].street},"
//         "${placemarks[0].subLocality},"
//         "${placemarks[0].locality},";
//     setState((){});
//   }
//   setState((){wait = false; btnstopper = false;});
// }
//
// getTimeOut(setState,context)async{
//   setState((){wait = true;});
//   await main(context);
//   var datetimenow = await NTP.now();
//   var allData = await DBProvider.db.getAllData();
//   var response = await http.post(
//       Uri.parse("${apiLink()}api/FcAttendances/WFHTimeOut"),
//       body: {
//         "employeeId":(allData[0]['employeeId']).toString(),
//         "timeIn": timeIn,
//         "timeOut": DateFormat("hh:mm a").format(datetimenow).toString(),
//         "locationOut":"${placemarks[0].street},"
//             "${placemarks[0].subLocality},"
//             "${placemarks[0].locality},"
//             "${placemarks[0].administrativeArea},"
//             "${placemarks[0].country}",
//         "getdate":DateFormat("yyyy/MM/dd").format(datetimenow).toString(),
//       });
//   if (response.statusCode == 200) {
//     isTimeinClicked = false;
//     location = "${placemarks[0].street},"
//         "${placemarks[0].subLocality},"
//         "${placemarks[0].locality},";
//     getDataWFH(setState);
//   }
//   setState((){wait = false;});
// }
// bool btnstopper = false;
// WFHWidget(setState,context){
//   Future<bool?> outYesNoDialog(BuildContext context,setState) async {
//       showDialog<bool>(
//         context: context,
//         builder: (context) =>  AlertDialog(
//           title: const Text("are you sure?",style: TextStyle(fontSize: 15),),
//           actions: [
//             ElevatedButton(onPressed: (){
//               Navigator.pop(context, true);
//             },
//                 child: const Text('No')
//             ),
//             ElevatedButton(onPressed: () async{
//               getTimeOut(setState,context);
//               Navigator.pop(context, true);
//             },
//                 child: const Text('Yes')
//             ),
//           ],
//         ),
//       );
//
//     return null;
//   }
//
//
//
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: [
//       Center(
//         child: Container(
//           width: 300,
//           height: 300,
//           decoration: BoxDecoration(
//             color:isTimeinClicked? Colors.red:Colors.blue,
//             borderRadius:const BorderRadius.all(Radius.circular(1000)),
//           ),
//           child: TextButton(
//             style: ButtonStyle(
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(1000),
//                         side: const BorderSide(color: Colors.red)
//                     )
//                 )
//             ),
//             child: Text(wait?"Please Wait...":isTimeinClicked? "Time Out":"Time In",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: wait? 30:50
//               ),),
//             onPressed:()async{
//               if(internet() == false){
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('No internet connection'),
//                   ),
//                 );
//               }else{
//                 if(isTimeinClicked == false){
//
//                   if(btnstopper == false){
//                     btnstopper =true;
//                     getTimeIn(setState,context);
//                   }
//
//                 }else{
//                   outYesNoDialog(context, setState);
//                 }
//               }
//
//             },
//           ),
//         ),
//       ),
//     Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//      const Icon(Icons.location_on,color: Colors.red,),
//       Text(timeIn == "--:--"? "" :
//       location),
//     ],),
//     Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//       Column(children: [
//         const Icon(Icons.timer_sharp,
//             color: Colors.blue),
//         Text(timeIn),
//       ],),
//       Column(children: [
//         const Icon(Icons.timer_off_outlined,
//             color: Colors.red),
//         Text(isTimeinClicked?"--:--":timeOut),
//       ],),
//       Column(children: [
//         const Icon(Icons.lock_clock,
//             color: Colors.green),
//         Text(isTimeinClicked? "--:--":totalTime),
//       ],),
//
//     ],)
//   ],);
// }