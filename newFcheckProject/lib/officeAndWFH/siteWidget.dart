// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:ntp/ntp.dart';
// import '../deviceInfo.dart';
// import '../home/healthDeclaration.dart';
// import '../home/homeScreen.dart';
// import '../offlineDatabase/sqfLiteDatabase.dart';
//
// class siteWidget extends StatefulWidget {
//   const siteWidget({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<siteWidget> createState() => siteWidgets();
// }
//
// class siteWidgets extends State<siteWidget> with TickerProviderStateMixin {
//   var whatSite = 'OBT';
//   bool whatSiteLock = false;
//
//   late double latH = 0;
//   late double longH = 0;
//
//   bool hasInternet = true;
//   testes()async{
//     print(await DBProvider.db.getAllData());
//   }
//   @override
//   void initState() {
//     super.initState();
//     print("enter");
//     main(context);
//     firstDataSite(setState);
//     print("out");
//     testes();
//     InternetConnectionChecker().onStatusChange.listen((status) {
//       final hhasInternet = status == InternetConnectionStatus.connected;
//       if (mounted) {
//         setState(() => hasInternet = hhasInternet);
//         if (hasInternet == true) {
//           // sessionEmployeeId1(setState);
//           // getDataWFH(setState);
//           firstDataSite(setState);
//         }
//       }
//     });
//
//     // final LocationSettings locationSettings = LocationSettings(
//     //   accuracy: LocationAccuracy.high,
//     //   distanceFilter: 1,
//     // );
//     // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//     //         (Position? position) async{
//     //       latH = position!.latitude;
//     //       longH = position.longitude;
//     //
//     //       final GoogleMapController controller = await _controller.future;
//     //       await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//     //           target: LatLng(position.latitude,position.longitude),
//     //           zoom: 19
//     //       )));
//     //       placemarks =
//     //       await placemarkFromCoordinates(position.latitude, position.longitude)
//     //           .catchError((error) {
//     //         ScaffoldMessenger.of(context).showSnackBar(
//     //           SnackBar(
//     //             content: Text(error),
//     //           ),
//     //         );
//     //       });
//     //
//     //       setState(() {
//     //
//     //       });
//     //
//     //     });
//   }
//
// //uploadFile
//   var goToTimeinorOut = "";
//   File? _image;
//   final imagePicker = ImagePicker();
//   var image, inputimage = false;
//   Future getImage(setState, context) async {
//     image = await imagePicker.pickImage(
//         source: ImageSource.camera, imageQuality: 10);
//     setState(() {
//       _image = File(image.path);
//       inputimage = true;
//     });
//
//     if (goToTimeinorOut == "timein") {
//       areYouSureDialog(context, setState, "TimeIn");
//     } else if (goToTimeinorOut == "timeout") {
//       areYouSureDialog(context, setState, "TimeOut");
//     }
//     return true;
//   }
//
//   var dateTimeDate = [];
//
//   var timeIn = "", timeOut = "", totalTime = "";
//   List<String> breaks = ["", "", "", "", "", ""];
//   List<String> breakTypes = [
//     'firstBreakOut',
//     'firstBreakIn',
//     'secondBreakOut',
//     'secondBreakIn',
//     'thirdBreakOut',
//     'thirdBreakIn',
//   ];
//   bool breaksStop = false;
//   var ver = '';
//   var timeinLocation = '';
//   var timeoutLocation = '';
//
//   firstDataSite(setState) async {
//     //await DBProvider.db.getEmployeesData("id");
//
//     breaksStop = false;
//     timeIn = "";
//     timeOut = "";
//     totalTime = "";
//     var d = await NTP.now();
//     var dateTime = DateFormat("yyyy/MM/dd").format(d).toString();
//     ver = await appVersion();
//     setState(() {
//       waiting = true;
//     });
//     var response = await http.post(
//         Uri.parse("${apiLink()}api/FcAttendances/gettimeinoutSite"),
//         body: {
//           "employeeId": (await DBProvider.db.getEmployeesData("Id")).toString(),
//           "getDate": dateTime
//         }).catchError((Object error, StackTrace stackTrace) {
//
//       statusDialog(context, "$error: Can't connect to server",false);
//     });
// print(response.statusCode);
//     if (response.statusCode == 200) {
//       try {
//         setState(() {
//           whatSiteLock = false;
//           waiting = false;
//         });
//         dateTimeDate = await jsonDecode(response.body) as List;
//
//         if (dateTimeDate[0]['workPlace'] != '') {
//           whatSite = dateTimeDate[0]['workPlace'];
//           whatSiteLock = true;
//         } else {
//           whatSiteLock = false;
//         }
//
//         timeIn = dateTimeDate[0]['timeIn'].toString();
//         timeinLocation = dateTimeDate[0]['locationIn'] ?? "";
//         timeoutLocation = dateTimeDate[0]['locationOut'] ?? "";
//         if (dateTimeDate[0]['timeOut'].toString() != "null") {
//           timeOut = dateTimeDate[0]['timeOut'].toString();
//           totalTime = dateTimeDate[0]['totalTime'].toString();
//         }
//         for (int index = 0; index <= 5; index++) {
//           breaks[index] = "";
//         }
//         for (int index = 0; index <= 5; index++) {
//           if (dateTimeDate[0][breakTypes[index]].toString() != "null") {
//             breaks[index] = dateTimeDate[0][breakTypes[index]].toString();
//           }
//         }
//
//         if (breaks[0] != "" && breaks[1] == "") {
//           breaksStop = true;
//         } else if (breaks[2] != "" && breaks[3] == "") {
//           breaksStop = true;
//         } else if (breaks[4] != "" && breaks[5] == "") {
//           breaksStop = true;
//         }
//         setState(() {});
//       } catch (e) {
//         print("this is the Error: $e");
//       }
//       /*location = "${placemarks[0].street},"
//         "${placemarks[0].subLocality},"
//         "${placemarks[0].locality},";*/
//     } else {
//       statusDialog(context, response.body,false);
//       setState(() {
//         waiting = false;
//       });
//     }
//   }
//
//   getDataSite(setState) async {
//     setState(() {
//       pleaseWaitText = "Checking attendance...";
//     });
//     //await DBProvider.db.getEmployeesData("id");
//     loadingD(context, true, "Checking attendance...");
//     breaksStop = false;
//     timeIn = "";
//     timeOut = "";
//     totalTime = "";
//     var d = await NTP.now();
//     var dateTime = DateFormat("yyyy/MM/dd").format(d).toString();
//     ver = await appVersion();
//     setState(() {
//       whatSiteLock = false;
//       waiting = true;
//     });
//     var response = await http.post(
//         Uri.parse("${apiLink()}api/FcAttendances/gettimeinoutSite"),
//         body: {
//           "employeeId": (await DBProvider.db.getEmployeesData("Id")).toString(),
//           "getDate": dateTime
//         }).catchError((Object error, StackTrace stackTrace) {
//
//       statusDialog(context, "$error: Can't connect to server",false);
//     });
// test = "${response.statusCode}: ${response.body}";
//     if (response.statusCode == 200) {
//       loadingD(context, false, "Checking attendance...");
//       try {
//         setState(() {
//           waiting = false;
//         });
//         dateTimeDate = await jsonDecode(response.body) as List;
//
//         if (dateTimeDate[0]['workPlace'] != '') {
//           whatSite = dateTimeDate[0]['workPlace'];
//           whatSiteLock = true;
//         } else {
//           whatSiteLock = false;
//         }
//
//         timeIn = dateTimeDate[0]['timeIn'].toString()??"";
//         timeinLocation = dateTimeDate[0]['locationIn'] ?? "";
//         timeoutLocation = dateTimeDate[0]['locationOut'] ?? "";
//         if (dateTimeDate[0]['timeOut'].toString() != "null") {
//           timeOut = dateTimeDate[0]['timeOut'].toString();
//           totalTime = dateTimeDate[0]['totalTime'].toString();
//         }
//         for (int index = 0; index <= 5; index++) {
//           breaks[index] = "";
//         }
//         for (int index = 0; index <= 5; index++) {
//           if (dateTimeDate[0][breakTypes[index]].toString() != "null") {
//             breaks[index] = dateTimeDate[0][breakTypes[index]].toString();
//           }
//         }
//
//         if (breaks[0] != "" && breaks[1] == "") {
//           breaksStop = true;
//         } else if (breaks[2] != "" && breaks[3] == "") {
//           breaksStop = true;
//         } else if (breaks[4] != "" && breaks[5] == "") {
//           breaksStop = true;
//         }
//         setState(() {});
//       } catch (e) {
//         print("this is the Error: $e");
//       }
//       /*location = "${placemarks[0].street},"
//         "${placemarks[0].subLocality},"
//         "${placemarks[0].locality},";*/
//     } else {
//       loadingD(context, false, "Checking attendance...");
//       statusDialog(context, response.body,false);
//       setState(() {
//         waiting = false;
//       });
//     }
//   }
//
//   List location = [];
//   Position position = Position(
//       longitude: 0,
//       latitude: 0,
//       timestamp: DateTime.now(),
//       accuracy: 0,
//       altitude: 0,
//       heading: 0,
//       speed: 0,
//       speedAccuracy: 0);
//   List<Placemark> placemarks = [];
//
//   var pleaseWaitText = 'Checking attendance...';
//   var brand;
//   main(context) async {
//     LocationPermission permission;
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       await Geolocator.requestPermission();
//
//       return false;
//     } else if (permission != LocationPermission.denied) {
//       try {
//         setState(() {
//           pleaseWaitText = "Getting location...";
//         });
//
//         position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         ).catchError((error) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(error),
//             ),
//           );
//         });
//
//
//
//         // brand = await deviceinfo("brand");
//         //
//         // if (brand.toString().contains("HUAWEI")) {
//         //   var response = await http.get(
//         //     Uri.parse(
//         //         "https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json"),
//         //   );
//         //   var temp = jsonDecode(response.body)["display_name"];
//         //   location = temp.toString().trim().split(',');
//         //   //location = "${trimSplit[0]} ${trimSplit[1]} ${trimSplit[2]} ${trimSplit[3]} ${trimSplit[4]}" ;
//         // } else {
//           placemarks = await placemarkFromCoordinates(
//                   position.latitude, position.longitude)
//               .catchError((error) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(error),
//               ),
//             );
//           });
//
//
//         return true;
//       } catch (e) {
//         print("this: $e");
//
//         return false;
//       }
//       return true;
//     }
//
//     return false;
//   }
// var test = '';
//   Future<bool?> areYouSureDialog(
//       BuildContext context, setState, var content) async {
//     showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           "Do you want to ${content == "timeIn" ? "time in" : "time out"}?",
//           style: TextStyle(fontSize: 15),
//         ),
//         actions: [
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red, // Background color
//               ),
//               child: const Text('No')),
//           ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(context, true);
//                 if (content == "timeIn") {
//                   if (internet() == false) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('No internet connection'),
//                       ),
//                     );
//                   } else {
//                     setState(() {
//                       pleaseWaitText = "Please wait...";
//                       waiting = true;
//                     });
//
//                     if (inputimage == false) {
//                       //goToTimeinorOut = "timein";
//                       await getImage(setState, context);
//                     }
//
//                     if (inputimage == true && await main(context) == true) {
//                       var allData = await DBProvider.db.getAllData();
//
//                       await main(context);
//                       setState(() {
//                         pleaseWaitText = "Processing attendance...";
//                       });
//                       var datetimenow = await NTP.now();
//
//                       var request = http.MultipartRequest(
//                           'POST',
//                           Uri.parse(
//                               "${apiLink()}api/FcAttendances/uploadFile"));
//                       request.fields['employeeId'] =
//                           (allData[0]['employeeId']).toString();
//                       request.fields['workPlace'] = whatSite;
//                       request.fields['TimeIn'] =
//                           DateFormat("hh:mm a").format(datetimenow).toString();
//
//                       // if (brand.toString().contains("HUAWEI")) {
//                       //   request.fields['LocationIn'] =
//                       //       "${location[0].toString()} ${location[1].toString()} ${location[2].toString()} ${location[3].toString()} ${location[4].toString()}";
//                       // } else {
//                         request.fields['LocationIn'] =
//                             "${placemarks[0].street == "" ? "" : placemarks[0].street} "
//                             "${placemarks[0].subLocality == "" ? "" : placemarks[0].subLocality} "
//                             "${placemarks[0].locality == "" ? "" : placemarks[0].locality} "
//                             "${placemarks[0].administrativeArea == "" ? "" : placemarks[0].administrativeArea} "
//                             "${placemarks[0].country == "" ? "" : placemarks[0].country}";
//
//
//                       request.fields['department'] = allData[0]['department'];
//                       request.fields['sbu'] = allData[0]['sbu'];
//                       request.fields['date'] = DateFormat("yyyy/MM/dd")
//                           .format(datetimenow)
//                           .toString();
//                       request.fields['folder'] =
//                           (allData[0]['employeeId']).toString();
//                       request.fields['fileName'] = DateFormat("yyyy dd MM")
//                           .format(datetimenow)
//                           .toString();
//                       request.fields['LatLongIn'] =
//                           "${position.latitude.toString()}-${position.longitude.toString()}";
//                       request.files.add(http.MultipartFile.fromBytes(
//                           "uploadAttachments",
//                           File(_image!.path).readAsBytesSync(),
//                           filename: _image!.path));
//
//                       var res = await request.send();
//
//                       test = await res.stream.bytesToString();
//
//                       getDataSite(setState);
//                       inputimage = false;
//                       goToTimeinorOut = "";
//                     } else {
//                       setState(() {
//                         waiting = false;
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please insert image'),
//                         ),
//                       );
//                     }
//                     setState(() {
//                       waiting = false;
//                     });
//                   }
//                 } else if (content == "timeOut") {
//                   if (internet() == false) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('No internet connection'),
//                       ),
//                     );
//                   } else {
//                     setState(() {
//                       pleaseWaitText = "Please wait...";
//                       waiting = true;
//                     });
//                     if (inputimage == false) {
//                       //goToTimeinorOut = "timeout";
//                       await getImage(setState, context);
//                     }
//
//                     if (inputimage == true && await main(context) == true) {
//                       setState(() {
//                         pleaseWaitText = "Processing attendance...";
//                       });
//                       var allData = await DBProvider.db.getAllData();
//                       var datetimenow = await NTP.now();
//                       var request = http.MultipartRequest(
//                           'POST',
//                           Uri.parse(
//                               "${apiLink()}api/FcAttendances/uploadFileTimeOut"));
//                       request.fields['folder'] =
//                           (allData[0]['employeeId']).toString();
//                       request.fields['workPlace'] = whatSite;
//                       request.fields['fileName'] = DateFormat("yyyy dd MM")
//                           .format(datetimenow)
//                           .toString();
//                       request.fields['timeOut'] =
//                           DateFormat("hh:mm a").format(datetimenow).toString();
//                       request.fields['employeeId'] =
//                           (allData[0]['employeeId']).toString();
//                       request.fields['getdate'] = DateFormat("yyyy/MM/dd")
//                           .format(datetimenow)
//                           .toString();
//
//
//                         request.fields['LocationOut'] =
//                             "${placemarks[0].street == "" ? "" : placemarks[0].street} "
//                             "${placemarks[0].subLocality == "" ? "" : placemarks[0].subLocality} "
//                             "${placemarks[0].locality == "" ? "" : placemarks[0].locality} "
//                             "${placemarks[0].administrativeArea == "" ? "" : placemarks[0].administrativeArea} "
//                             "${placemarks[0].country == "" ? "" : placemarks[0].country}";
//
//                       request.fields['latLongOut'] =
//                           "${position.latitude.toString()}-${position.longitude.toString()}";
//                       request.files.add(http.MultipartFile.fromBytes(
//                           "uploadAttachments",
//                           File(_image!.path).readAsBytesSync(),
//                           filename: _image!.path));
//
//                       var res = await request.send();
//
//                       getDataSite(setState);
//                       inputimage = false;
//                       goToTimeinorOut = "";
//                     } else {
//                       setState(() {
//                         waiting = false;
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please insert image'),
//                         ),
//                       );
//                     }
//                     setState(() {
//                       waiting = false;
//                     });
//                   }
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green, // Background color
//               ),
//               child: const Text('Yes')),
//         ],
//       ),
//     );
//
//     return null;
//   }
//
//   Future<bool?> perms(BuildContext context) async {
//     showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text(
//           "Please turn on permission location access?",
//           style: TextStyle(fontSize: 15),
//         ),
//         actions: [
//           ElevatedButton(
//               onPressed: () async {
//                 //await Geolocator.requestPermission();
//                 //await Geolocator.openAppSettings();
//                 //await Geolocator.openLocationSettings();
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Open')),
//         ],
//       ),
//     );
//
//     return null;
//   }
//
//
//   double _height = 300.0;
//   Color _color = Colors.blue;
//   BorderRadiusGeometry _borderRadius = BorderRadius.circular(8.0);
//
//   void _changeProperties() {
//     setState(() {
//       // Randomly change the properties of the AnimatedContainer
//       _height = 0;
//       _color = Colors.transparent;
//       _borderRadius = BorderRadius.circular(16.0);
//     });
//   }
//
//
//   bool waiting = false;
//   GlobalKey _one = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       child: RefreshIndicator(
//         onRefresh: () async {
//           setState(() {
//             timeinLocation = '';
//             timeoutLocation = '';
//           });
//           position = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//           ).catchError((error) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(error),
//               ),
//             );
//           });
//           // latH = position.latitude;
//           // longH = position.longitude;
//           // final GoogleMapController controller = await _controller.future;
//           // await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           //     target: LatLng(position.latitude,position.longitude,),
//           //     zoom: 19
//           // ),
//           //
//           // ));
//
//           // brand = await deviceinfo("brand");
//           //
//           // if (brand.toString().contains("HUAWEI")) {
//           //   var response = await http.get(
//           //     Uri.parse(
//           //         "https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json"),
//           //   );
//           //   var temp = jsonDecode(response.body)["display_name"];
//           //   location = temp.toString().trim().split(',');
//           //   //location = "${trimSplit[0]} ${trimSplit[1]} ${trimSplit[2]} ${trimSplit[3]} ${trimSplit[4]}" ;
//           // }else{
//             placemarks = await placemarkFromCoordinates(
//                 position.latitude, position.longitude)
//                 .catchError((error) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(error),
//                 ),
//               );
//             });
//
//
//           await getDataSite(setState);
//         },
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//
//               //TODO OFFICE WFH OBT
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               //   children: [
//               //     SizedBox(
//               //       width: MediaQuery.of(context).size.width * 0.3,
//               //       child: ElevatedButton(
//               //           style: ElevatedButton.styleFrom(
//               //               backgroundColor: Colors.white,
//               //               side: BorderSide(
//               //                 width: whatSite == "OFFICE" ? 2 : 1,
//               //                 color: whatSite == "OFFICE"
//               //                     ? Colors.blue
//               //                     : Colors.transparent,
//               //               )),
//               //           onPressed: whatSiteLock
//               //               ? whatSite == "OFFICE"
//               //                   ? () {}
//               //                   : null
//               //               : () {
//               //                   setState(() {
//               //                     whatSite = "OFFICE";
//               //                   });
//               //                 },
//               //           child: Column(
//               //             children: [
//               //               Image.asset('assets/Images/office.png',
//               //                   height: 50,
//               //                   color: whatSite == "OFFICE"
//               //                       ? null
//               //                       : Colors.black.withOpacity(0.2)),
//               //               Text(
//               //                 "OFFICE",
//               //                 style: TextStyle(
//               //                     color: whatSite == "OFFICE"
//               //                         ? Colors.blue
//               //                         : Colors.black.withOpacity(0.2)),
//               //               )
//               //             ],
//               //           )),
//               //     ),
//               //     SizedBox(
//               //       width: MediaQuery.of(context).size.width * 0.3,
//               //       child: ElevatedButton(
//               //           style: ElevatedButton.styleFrom(
//               //               backgroundColor: Colors.white,
//               //               side: BorderSide(
//               //                 width: whatSite == "WFH" ? 2 : 1,
//               //                 color: whatSite == "WFH"
//               //                     ? Colors.blue
//               //                     : Colors.transparent,
//               //               )),
//               //           onPressed: whatSiteLock
//               //               ? whatSite == "WFH"
//               //                   ? () {}
//               //                   : null
//               //               : () {
//               //                   setState(() {
//               //                     whatSite = "WFH";
//               //                   });
//               //                 },
//               //           child: Column(
//               //             children: [
//               //               Image.asset(
//               //                 'assets/Images/WFH.png',
//               //                 height: 50,
//               //                 color: whatSite == "WFH"
//               //                     ? null
//               //                     : Colors.black.withOpacity(0.2),
//               //               ),
//               //               Text(
//               //                 "WFH",
//               //                 style: TextStyle(
//               //                     color: whatSite == "WFH"
//               //                         ? Colors.blue
//               //                         : Colors.black.withOpacity(0.2)),
//               //               )
//               //             ],
//               //           )),
//               //     ),
//               //     SizedBox(
//               //       width: MediaQuery.of(context).size.width * 0.3,
//               //       child: ElevatedButton(
//               //           style: ElevatedButton.styleFrom(
//               //               backgroundColor: Colors.white,
//               //               side: BorderSide(
//               //                 width: whatSite == "OBT" ? 2 : 1,
//               //                 color: whatSite == "OBT"
//               //                     ? Colors.blue
//               //                     : Colors.transparent,
//               //               )),
//               //           onPressed: whatSiteLock
//               //               ? whatSite == "OBT"
//               //                   ? () {}
//               //                   : null
//               //               : () {
//               //                   setState(() {
//               //                     whatSite = "OBT";
//               //                   });
//               //                 },
//               //           child: Column(
//               //             children: [
//               //               Image.asset(
//               //                 'assets/Images/Site.png',
//               //                 height: 50,
//               //                 color: whatSite == "OBT"
//               //                     ? null
//               //                     : Colors.black.withOpacity(0.2),
//               //               ),
//               //               Text(
//               //                 "OBT",
//               //                 style: TextStyle(
//               //                     color: whatSite == "OBT"
//               //                         ? Colors.blue
//               //                         : Colors.black.withOpacity(0.2)),
//               //               )
//               //             ],
//               //           )),
//               //     ),
//               //   ],
//               // ),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10, top: 10),
//                     child: Row(
//                       children: [
//                         Text("Date: ",
//                             style: TextStyle(
//                                 fontSize: 15, fontWeight: FontWeight.bold)),
//                         Text(
//                           "${DateFormat("EEEE MMMM d, yyyy").format(DateTime.now()).toString()}",
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.only(left: 10, top: 10),
//               //   child: SizedBox(
//               //     width: MediaQuery.of(context).size.width,
//               //     child: Row(
//               //       children: [
//               //         Text("Current: ",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)) ,
//               //         Text(placemarks.toString() == "[]"?"If no map showing swipe down to refresh":"${placemarks[0].street} "
//               //             "${placemarks[0].subLocality} "
//               //             "${placemarks[0].locality} "
//               //             "${placemarks[0].administrativeArea} "
//               //             "${placemarks[0].country}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color:placemarks.toString() == "[]"?Colors.red: Colors.blue)),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//               // Container(
//               //   height: 100,
//               //   width: MediaQuery.of(context).size.width,
//               //   child: GoogleMap(
//               //     mapType: MapType.hybrid,
//               //     initialCameraPosition:CameraPosition(
//               //         target:  LatLng(latH, longH),
//               //         zoom: 19
//               //     )  ,
//               //     markers: {
//               //       Marker(
//               //           markerId: MarkerId("source"),
//               //           position: LatLng(latH, longH)
//               //       )
//               //     },
//               //     onMapCreated: (GoogleMapController controller) {
//               //       _controller.complete(controller);
//               //     },
//               //   ),
//               // ),
//
// /*Center(
//         child: _image == null? Text("no image"): Image.file(_image!),
// ),*/
//             //TODO Image
//               /*SizedBox(
//                 height: inputimage ? 500 : 400,
//                 width: inputimage ? 500 : 400,
//                 child: IconButton(
//                     onPressed: () {
//                       getImage(setState, context);
//                     },
//                     icon: inputimage
//                         ? Image.file(_image!)
//                         : Image.network(
//                             'https://apps.fastlogistics.com.ph/fastdrive/ontimeinstaller/captureimage.jpg')),
//               ),*/
//             //TODO OFFICE WFH OBT
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     Padding(
//               //       padding: const EdgeInsets.all(8.0),
//               //       child: Text(
//               //         whatSite == "OFFICE"
//               //             ? "OFFICE"
//               //             : whatSite == "WFH"
//               //                 ? "WORK FROM HOME"
//               //                 : "OFFICIAL BUSINESS TRAVEL",
//               //         style: TextStyle(
//               //             color: Colors.blue,
//               //             fontWeight: FontWeight.bold,
//               //             fontSize: 20),
//               //       ),
//               //     )
//               //   ],
//               // ),
//
//               if (timeinLocation != '')
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Location in:",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             color: Colors.red,
//                           ),
//                           Expanded(
//                               child: Text(
//                             timeIn == "--:--" ? "" : timeinLocation,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue),
//                           )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               if (timeoutLocation != '')
//                 SizedBox(
//                   height: 20,
//                 ),
//               if (timeoutLocation != '')
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Location out:",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             color: Colors.red,
//                           ),
//                           Expanded(
//                               child: Text(
//                                   timeIn == "--:--" ? "" : timeoutLocation,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue)))
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               SizedBox(
//                 height: 20,
//               ),
//
//
//           Container(
//             width: MediaQuery.of(context).size.width * 0.95,
//             height: 300,
//             decoration: BoxDecoration(
//                 borderRadius: _borderRadius,
//               border: Border.all(width: 1,color: Colors.black)
//             ),
//             child: Stack(
//               children: [
//
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         height: 100,
//                         child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 side: BorderSide(
//                                   width:2 ,
//                                   color: Colors.blue
//                                      ,
//                                 )),
//                             onPressed: () {
//                               setState(() {
//                                 whatSite = "OFFICE";
//                               });
//                             },
//                             child: Column(
//                               children: [
//                                 Image.asset('assets/Images/office.png',
//                                     height: 50,
//                                   ),
//                                 Text(
//                                   "OFFICE",
//                                   style: TextStyle(
//                                       color: Colors.blue
//                                           ),
//                                 )
//                               ],
//                             )),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         height: 100,
//                         child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 side: BorderSide(
//                                   width: 2,
//                                   color: Colors.blue
//                                       ,
//                                 )),
//                             onPressed:  () {
//                               setState(() {
//                                 whatSite = "WFH";
//                               });
//                             },
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   'assets/Images/WFH.png',
//                                   height: 50,
//                                 ),
//                                 Text(
//                                   "WFH",
//                                   style: TextStyle(
//                                       color: Colors.blue
//                                          ),
//                                 )
//                               ],
//                             )),
//                       ),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         height: 100,
//                         child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 side: BorderSide(
//                                   width: 2,
//                                   color: Colors.blue,
//                                 )),
//                             onPressed:
//                                 () {
//                               setState(() {
//                                 whatSite = "OBT";
//                               });
//                             },
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   'assets/Images/Site.png',
//                                   height: 50,
//                                 ),
//                                 Text(
//                                   "OBT",
//                                   style: TextStyle(
//                                       color: Colors.blue
//                                           ),
//                                 )
//                               ],
//                             )),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 GestureDetector(
//                   onTap: () => _changeProperties(),
//                   child: AnimatedContainer(
//                     duration: Duration(milliseconds: 900),
//                     width:  MediaQuery.of(context).size.width * 0.95,
//                     height: _height,
//                     decoration: BoxDecoration(
//                       color: _color,
//                       borderRadius: _borderRadius,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.timer_outlined,color: Colors.white,size: _height==300.0?90:0,),
//                         Text("Time In",style: TextStyle(color: Colors.white,fontSize: 50,fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                 ),
//
//
//               ],
//             ),
//           ),
//
//
//               SizedBox(
//                 height: 20,
//               ),
//
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.95,
//                 height: 300,
//                 decoration: BoxDecoration(
//                     borderRadius: _borderRadius,
//                     border: Border.all(width: 1,color: Colors.black)
//                 ),
//                 child: Stack(
//                   children: [
//
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.3,
//                             height: 100,
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     side: BorderSide(
//                                       width:2 ,
//                                       color: Colors.blue
//                                       ,
//                                     )),
//                                 onPressed: () {
//                                   setState(() {
//                                     whatSite = "OFFICE";
//                                   });
//                                 },
//                                 child: Column(
//                                   children: [
//                                     Image.asset('assets/Images/office.png',
//                                       height: 50,
//                                     ),
//                                     Text(
//                                       "OFFICE",
//                                       style: TextStyle(
//                                           color: Colors.blue
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.3,
//                             height: 100,
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     side: BorderSide(
//                                       width: 2,
//                                       color: Colors.blue
//                                       ,
//                                     )),
//                                 onPressed:  () {
//                                   setState(() {
//                                     whatSite = "WFH";
//                                   });
//                                 },
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                       'assets/Images/WFH.png',
//                                       height: 50,
//                                     ),
//                                     Text(
//                                       "WFH",
//                                       style: TextStyle(
//                                           color: Colors.blue
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.3,
//                             height: 100,
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     side: BorderSide(
//                                       width: 2,
//                                       color: Colors.blue,
//                                     )),
//                                 onPressed:
//                                     () {
//                                   setState(() {
//                                     whatSite = "OBT";
//                                   });
//                                 },
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                       'assets/Images/Site.png',
//                                       height: 50,
//                                     ),
//                                     Text(
//                                       "OBT",
//                                       style: TextStyle(
//                                           color: Colors.blue
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     GestureDetector(
//                       onTap: () => _changeProperties(),
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 900),
//                         width:  MediaQuery.of(context).size.width * 0.95,
//                         height: _height,
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: _borderRadius,
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.timer_off_outlined,color: Colors.white,size: _height==300.0?90:0,),
//                             Text("Time Out",style: TextStyle(color: Colors.white,fontSize: 50,fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       ),
//                     ),
//
//
//                   ],
//                 ),
//               ),
//
//
//               SizedBox(
//                 height: 20,
//               ),
//
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.45,
//                     height: 90,
//                     child: ElevatedButton.icon(
//                         style: ButtonStyle(
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.horizontal(
//                                       left: Radius.circular(10)),
//                                   side: BorderSide(color: Colors.black)),
//                             ),
//                             backgroundColor: MaterialStateProperty.all(waiting
//                                 ? Colors.grey.shade200
//                                 : Colors.transparent),
//                             elevation: MaterialStateProperty.all(0)),
//                         onPressed: timeIn != "" || waiting
//                             ? null
//                             : () async {
//                                 areYouSureDialog(context, setState, "timeIn");
//                               },
//                         icon: const Icon(
//                           Icons.timer_sharp,
//                           color: Colors.blue,
//                         ),
//                         label: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               waiting ? "${pleaseWaitText}" : "Time In",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: waiting ? 15 : 20),
//                             ),
//                             if (waiting == false &&
//                                 timeIn != "null" &&
//                                 timeIn != "")
//                               Text(timeIn,
//                                   style: const TextStyle(
//                                       color: Colors.blue,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 25))
//                           ],
//                         )),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.45,
//                     height: 90,
//                     child: ElevatedButton.icon(
//                         style: ButtonStyle(
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.horizontal(
//                                       right: Radius.circular(10)),
//                                   side: BorderSide(color: Colors.black)),
//                             ),
//                             backgroundColor: MaterialStateProperty.all(waiting
//                                 ? Colors.grey.shade200
//                                 : Colors.transparent),
//                             elevation: MaterialStateProperty.all(0)),
//                         onPressed: (timeOut != "null" && timeOut != "") ||
//                                 waiting
//                             ? null
//                             : () async {
//                                 areYouSureDialog(context, setState, "timeOut");
//                               },
//                         icon: const Icon(
//                           Icons.timer_off_outlined,
//                           color: Colors.red,
//                         ),
//                         label: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               waiting ? "${pleaseWaitText}" : "Time Out",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: waiting ? 15 : 20),
//                             ),
//                             if (waiting == false &&
//                                 timeOut != "null" &&
//                                 timeOut != "")
//                               Text(timeOut,
//                                   style: const TextStyle(
//                                       color: Colors.blue,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 25))
//                           ],
//                         )),
//                   ),
//                 ],
//               ),
//
// //     Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       children: [
// //         ElevatedButton.icon(
// //             style:ElevatedButton.styleFrom(
// //                 backgroundColor: breaksStop ? Colors.red:Colors.transparent,
// //                 elevation: 0,
// //                 side:const BorderSide(color: Colors.black)
// //             )
// //
// //             ,onPressed: ()async{
// //           var datetimenow = await NTP.now();
// //           var allData = await DBProvider.db.getAllData();
// //           var response = await http.post(
// //               Uri.parse("${apiLink()}api/FcAttendances/siteBreak"),
// //               body: {
// //                 "employeeId":(allData[0]['employeeId']).toString(),
// //                 "time":DateFormat("hh:mm a").format(datetimenow).toString(),
// //
// //               });
// //           if(response.statusCode == 200){
// //             getDataSite(setState);
// // print("success!");
// //           }
// //
// //         }, icon: Icon(Icons.free_breakfast_outlined,color: breaksStop? Colors.white:Colors.blue,),
// //             label: Text(breaksStop ? "Stop!":"Break",
// //               style: TextStyle(color: breaksStop ? Colors.white:Colors.black,
// //                   fontWeight: FontWeight.bold),)),
// //       ],
// //     ),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               //   children: [
//               //     if(breaks[0] != "" && breaks[1] != "")...[
//               //
//               //       Text("1st Break: ${
//               //           (DateFormat("hh:mma").parse(breaks[1].replaceAll(' ', '').toUpperCase())
//               //               .difference(
//               //               DateFormat("hh:mma").parse(breaks[0].replaceAll(' ', '').toUpperCase())
//               //           )).inMinutes
//               //
//               //       } Min"),
//               //
//               //       if(breaks[2] != "" && breaks[3] != "")...[
//               //
//               //         Text("2nd Break: ${
//               //             (DateFormat("hh:mma").parse(breaks[3].replaceAll(' ', '').toUpperCase())
//               //                 .difference(
//               //                 DateFormat("hh:mma").parse(breaks[2].replaceAll(' ', '').toUpperCase())
//               //             )).inMinutes
//               //
//               //         } Min"),
//               //
//               //         if(breaks[4] != "" && breaks[5] != "")...[
//               //
//               //           Text("3rd Break: ${
//               //               (DateFormat("hh:mma").parse(breaks[5].replaceAll(' ', '').toUpperCase())
//               //                   .difference(
//               //                   DateFormat("hh:mma").parse(breaks[4].replaceAll(' ', '').toUpperCase())
//               //               )).inMinutes
//               //
//               //           } Min")
//               //
//               //         ],
//               //       ],
//               //
//               //     ],
//               //
//               //   ],
//               // ),
//
//               Column(
//                 children: [
//                   const Icon(
//                     Icons.lock_clock,
//                     color: Colors.green,
//                   ),
//                   Text(totalTime != "" && totalTime != "null"
//                       ? totalTime
//                       : "--:--"),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Column(
//                 children: [
//                   Text(ver),
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
