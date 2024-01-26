import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newfcheckproject/home/healthDeclaration.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
// import 'package:location/location.dart';
import 'package:ntp/ntp.dart';

import '../offlineDatabase/sqfLiteDatabase.dart';

class newSiteWidget extends StatefulWidget {
  const newSiteWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<newSiteWidget> createState() => siteWidgets();
}

class siteWidgets extends State<newSiteWidget> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    functionGettingUserAttendance();
  }

  //TODO: var for time in/out
  var employeeId = "";
  var employeeName = "";
  var workPlace = "";
  var timeIn = "";
  var locationIn = "";
  var workPlaceOut = "";
  var timeOut = "";
  var locationOut = "";
  var totalTime = "";
  var currentTime = "";
  var lastTimeInOut = "";
  var lastTimeIn = "";
  var lastTimeOut = "";

  var position;
  // List<Placemark> placemarks = [];

  bool ProcessingTimeIn = false;
  var whatIsProcessingTimeIn = "";
  bool ProcessingTimeOut = false;
  var whatIsProcessingTimeOut = "";

  var whatSite = "";
  double heightTimein = 300.0;
  Color colorTimein = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8.0);

  void _changeProperties() {
    setState(() {
      heightTimein = 0;
      colorTimein = Colors.transparent;
      _borderRadius = BorderRadius.circular(16.0);
    });
  }

  double heightTimeOut = 300.0;
  Color colorTimeOut = Colors.red;
  BorderRadiusGeometry _borderRadiusOut = BorderRadius.circular(8.0);

  void _changePropertiesOut() {
    setState(() {
      heightTimeOut = 0;
      colorTimeOut = Colors.transparent;
      _borderRadiusOut = BorderRadius.circular(16.0);
    });
  }


  File? _image;
  final imagePicker = ImagePicker();
  final timeZoneGMT = DateTime.now().toLocal().timeZoneOffset.inHours;
  var timeZoneOut = "";
  Future getImage(logType) async {

      if(logType == "in"){
        ProcessingTimeIn = true;
        whatIsProcessingTimeIn = "Processing image...";
      }else if(logType == "out"){

        ProcessingTimeOut = true;
        whatIsProcessingTimeOut = "Processing image...";
        var response = await http.post(
            Uri.parse("${apiLink()}api/FcAttendances/getTimeZoneT"),
            body: {
            "timeZ":timeZoneGMT.toString(),
            }).catchError((Object error, StackTrace stackTrace) {
          statusDialog(context, "$error: Can't connect to server", false);
        });

        if (response.statusCode == 200) {
          timeZoneOut = response.body.toString();

        }else{
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to process"),
              ),
            );
            ProcessingTimeIn = false;
          });
          timeZoneOut = "";
        }
      }


      setState(() { });

    var image = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 10);

    if (image != null) {
      _image = File(image.path);
      if (await functionGettingLocation() == true) {
        if(logType == "in"){

          functionTimein();
        }else if(logType == "out"){
          if(timeZoneOut == ""){
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Failed to process"),
                ),
              );
              ProcessingTimeIn = false;
            });
            timeZoneOut = "";
          }else{
            functionTimeOut();
          }

        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Getting location failed"),
          ),
        );
        setState(() {
          ProcessingTimeIn = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Getting image canceled"),
        ),
      );
      setState(() {
        if(logType == "in"){
          ProcessingTimeIn = false;
          whatIsProcessingTimeIn = "Processing image...";
        }else if(logType == "out"){
          ProcessingTimeOut = false;
          whatIsProcessingTimeOut = "Processing image...";
        }

      });
    }
  }

  functionGettingLocation() async {

    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return false;
    }
    setState(() {
      whatIsProcessingTimeIn = "Processing location...";
      whatIsProcessingTimeOut = "Processing location...";
    });

     var isError = false;

   try{
     position = await Geolocator.getCurrentPosition(

       desiredAccuracy: LocationAccuracy.high,
     ).catchError((error) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(error.toString()),
         ),
       );
       isError = true;

       return isError;
     });
   }catch(e){
     print("this is: ${e}");
     isError = true;

     return isError;
   }

    // placemarks =
    //     await placemarkFromCoordinates(position.latitude, position.longitude)
    //         .catchError((error) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(error.toString()),
    //     ),
    //   );
    //   print(error.toString());
    //   isError = true;
    //   return isError;
    // });

    if (isError == false) {
      return true;
    } else {
      return false;
    }
  }
  var ver = "";
  functionGettingUserAttendance() async {
    ver = await appVersion();
    employeeId = await DBProvider.db.getEmployeesData("Id");
    employeeName = await DBProvider.db.getEmployeesData("employeeName");
    setState(() {
      timeIn= "";
      timeOut = "";
      whatIsProcessingTimeIn = "Checking attendance...";
      ProcessingTimeIn = true;
      whatIsProcessingTimeOut = "Checking attendance...";
      ProcessingTimeOut = true;
    });


    var d = await NTP.now();
    var dateTime = DateFormat("yyyy/MM/dd").format(d).toString();


    var response = await http.post(
        Uri.parse("${apiLink()}api/FcAttendances/gettimeinoutSiteNew1"),
        body: {
          "employeeId": (await DBProvider.db.getEmployeesData("Id")).toString(),
          "getDate": dateTime
        }).catchError((Object error, StackTrace stackTrace) {
      statusDialog(context, "$error: Can't connect to server", false);
    });

    if (response.statusCode == 200) {
      setState(() {

        lastTimeInOut = "${DateFormat("MMMM d, yyyy").format(DateTime.parse(jsonDecode(response.body)['oldTimeInfo']['date']))}";
        lastTimeIn = jsonDecode(response.body)['oldTimeInfo']['timeIn']??"";
        lastTimeOut = jsonDecode(response.body)['oldTimeInfo']['timeOut']??"";


         timeIn = jsonDecode(response.body)['dateTimeInfo'][0]['timeIn'];
        if(jsonDecode(response.body)['dateTimeInfo'][0]['locationIn'] != null){
          workPlace = jsonDecode(response.body)['dateTimeInfo'][0]['workPlace'];
         locationIn = jsonDecode(response.body)['dateTimeInfo'][0]['locationIn'];
       }

        if(jsonDecode(response.body)['dateTimeInfo'][0]['timeOut'] != null){
          workPlaceOut = jsonDecode(response.body)['dateTimeInfo'][0]['workPlaceOut'];
          timeOut = jsonDecode(response.body)['dateTimeInfo'][0]['timeOut'];
          locationOut = jsonDecode(response.body)['dateTimeInfo'][0]['locationOut'];
          totalTime = jsonDecode(response.body)['dateTimeInfo'][0]['totalTime'];
        }
  // timeIn = jsonDecode(response.body)[0]['timeIn'];
  //       if(jsonDecode(response.body)[0]['locationIn'] != null){
  //         workPlace = jsonDecode(response.body)[0]['workPlace'];
  //        locationIn = jsonDecode(response.body)[0]['locationIn'];
  //      }
  //
  //       if(jsonDecode(response.body)[0]['timeOut'] != null){
  //         workPlaceOut = jsonDecode(response.body)[0]['workPlaceOut'];
  //         timeOut = jsonDecode(response.body)[0]['timeOut'];
  //         locationOut = jsonDecode(response.body)[0]['locationOut'];
  //         totalTime = jsonDecode(response.body)[0]['totalTime'];
  //       }

      });
      ProcessingTimeIn = false;
      ProcessingTimeOut = false;
    }
    else{
      lastTimeInOut = "${DateFormat("MMMM d, yyyy").format(DateTime.parse(jsonDecode(response.body)['oldTimeInfo']['date']))}";
      lastTimeIn = jsonDecode(response.body)['oldTimeInfo']['timeIn']??"";
      lastTimeOut = jsonDecode(response.body)['oldTimeInfo']['timeOut']??"";
    }
    setState(() {
      ProcessingTimeIn = false;
      ProcessingTimeOut = false;
    });
  }

  functionTimein() async {
    setState(() {
      whatIsProcessingTimeIn = "Processing attendance...";
    });

    var allData = await DBProvider.db.getAllData();

    var datetimenow = await NTP.now();

    var request = http.MultipartRequest(
        'POST', Uri.parse("${apiLink()}api/FcAttendances/uploadFile2"));
    request.fields['employeeId'] = (allData[0]['employeeId']).toString();
    request.fields['workPlace'] = whatSite;
    request.fields['TimeIn'] =
        DateFormat("hh:mm a").format(datetimenow).toString();

    request.fields['LocationIn'] ="temp";

    request.fields['timeZoneGMT'] = timeZoneGMT.toString();
    request.fields['department'] = allData[0]['department'];
    request.fields['sbu'] = allData[0]['sbu'];
    request.fields['date'] =
        DateFormat("yyyy/MM/dd").format(datetimenow).toString();
    request.fields['folder'] = (allData[0]['employeeId']).toString();
    request.fields['fileName'] =
        DateFormat("yyyy dd MM").format(datetimenow).toString();
    request.fields['LatLongIn'] =
        "${position.latitude.toString()}-${position.longitude.toString()}";
    request.files.add(http.MultipartFile.fromBytes(
        "uploadAttachments", File(_image!.path).readAsBytesSync(),
        filename: _image!.path));

    var res = await request.send();

    // String test = await res.stream.bytesToString();

    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Success"),
        ),
      );
      functionGettingUserAttendance();
    }else{
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to process"),
          ),
        );
        ProcessingTimeIn = false;
      });
    }
  }

  functionTimeOut()async{
    setState(() {
      whatIsProcessingTimeOut = "Processing attendance...";
    });

    var allData = await DBProvider.db.getAllData();
    var datetimenow = await NTP.now();
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${apiLink()}api/FcAttendances/uploadFileTimeOut2"));
    request.fields['folder'] =
        (allData[0]['employeeId']).toString();
    request.fields['workPlaceOut'] = whatSite;
    request.fields['fileName'] = DateFormat("yyyy dd MM")
        .format(datetimenow)
        .toString();
    request.fields['timeOut'] =
        timeZoneOut.toString();
    request.fields['employeeId'] =
        (allData[0]['employeeId']).toString();
    request.fields['getdate'] = DateFormat("yyyy/MM/dd")
        .format(datetimenow)
        .toString();
    request.fields['timeZoneGMT'] = timeZoneOut.toString();

    request.fields['LocationOut'] =
    "temp";

    request.fields['latLongOut'] =
    "${position.latitude.toString()}-${position.longitude.toString()}";
    request.files.add(http.MultipartFile.fromBytes(
        "uploadAttachments",
        File(_image!.path).readAsBytesSync(),
        filename: _image!.path));

    var res = await request.send();
// print(res.statusCode);
print(await res.stream.bytesToString());
    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Success"),
        ),
      );
      functionGettingUserAttendance();
    }else{
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to process"),
          ),
        );
        ProcessingTimeOut = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        functionGettingUserAttendance();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding:const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Text("Name: ",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(employeeName == '' || employeeName == null?"Please relogin your account":employeeName,
                      style: TextStyle(
                          fontSize: 15,
                          color:employeeName == '' || employeeName == null?Colors.red: Colors.blue))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Row(
                children: [
                  Text("Date: ",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(
                    "${DateFormat("EEEE MMMM d, yyyy").format(DateTime.now()).toString()}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10, top: 0, bottom: 10),
              child: Row(
                children: [
                  Text("Last Time: ",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),

                  Text(lastTimeIn,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                  Text("/ ",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(lastTimeOut,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red)),
                  Text(
                    " ${lastTimeInOut}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue),
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width * 0.95,
               height:  timeIn == ""?250:null,
              // constraints: BoxConstraints(
              //     minHeight: 100,),
              decoration: BoxDecoration(
                  borderRadius: _borderRadius,
                  border: Border.all(width: 1, color: Colors.black)),
              child:
              ProcessingTimeIn == true?
                  Center(child: Text(whatIsProcessingTimeIn,style: TextStyle(
                      fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blue),)):

              timeIn != ""
                  ?timeIn == "No Data" ?
                  Center(child: Text("No Data",style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),)
                  :Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Row(
                            children: [
                              Text(
                                "Time in:  ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(timeIn,
                                  style: TextStyle(
                                      fontSize: 20))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image.network(
                              'https://apps.fastlogistics.com.ph/fastdrive//ontimemobile/'
                              '${employeeId}/'
                              '${DateFormat("yyyy dd MM").format(DateTime.now()).toString()}/'
                              '${timeIn.toString().replaceAll(":", "").replaceAll(" ", "")}${employeeId}.jpg',
                              loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return Center(child: CircularProgressIndicator());
                          }, errorBuilder: (context, error, stackTrace) {
                            return Text("Network Error");
                          }, height:  MediaQuery.of(context).size.height * 0.15),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.blue,),
                                Expanded(child: Text(locationIn))
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              Icon(Icons.work_history_rounded,color: Colors.blue, ),
                              Text(" ${workPlace == "OFFICE"?
                              "OFFICE":workPlace == "WFH"?
                              "Work From Home":"Official Business Travel"}",style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )),
                            ],
                          )

                        ]),
                      ),
                    )
                  : Stack(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 100,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          width: 2,
                                          color: Colors.blue,
                                        )),
                                    onPressed: () async {
                                      whatSite = "OFFICE";

                                      bool? result = await timeInOutConfirmation(
                                          context,
                                          "Do you want to Time in?",
                                          "OFFICE");

                                      if (result == true) {

                                        getImage("in");
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/Images/office.png',
                                          height: 50,
                                        ),
                                        Text(
                                          "OFFICE",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 100,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          width: 2,
                                          color: Colors.blue,
                                        )),
                                    onPressed: () async {
                                      whatSite = "WFH";
                                      bool? result = await timeInOutConfirmation(
                                          context,
                                          "Do you want to Time in?",
                                          "Work From Home");

                                      if (result == true) {

                                        getImage("in");
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/Images/WFH.png',
                                          height: 50,
                                        ),
                                        Text(
                                          "WFH",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 100,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          width: 2,
                                          color: Colors.blue,
                                        )),
                                    onPressed: () async {
                                      whatSite = "OBT";
                                      bool? result = await timeInOutConfirmation(
                                          context,
                                          "Do you want to Time in?",
                                          "Official Business Travel");

                                      if (result == true) {

                                        getImage("in");
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/Images/Site.png',
                                          height: 50,
                                        ),
                                        Text(
                                          "OBT",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _changeProperties(),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 900),
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: heightTimein,
                            decoration: BoxDecoration(
                              color: colorTimein,
                              borderRadius: _borderRadius,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  color: Colors.white,
                                  size: heightTimein == 300.0 ? 90 : 0,
                                ),
                                Text("Time In",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            SizedBox(
              height: 10,
            ),

            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height:  timeOut == ""?250:null,
              decoration: BoxDecoration(
                  borderRadius: _borderRadiusOut,
                  border: Border.all(width: 1, color: Colors.black)),
              child:
              ProcessingTimeOut == true?
              Center(child: Text(whatIsProcessingTimeOut,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blue),)):

              timeOut != ""
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          "Time out:  ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Text(timeOut,
                            style: TextStyle(
                                fontSize: 20))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.network(
                        'https://apps.fastlogistics.com.ph/fastdrive//ontimemobile/'
                            '${employeeId}/'
                            '${DateFormat("yyyy dd MM").format(DateTime.now()).toString()}/'
                            '${timeOut.toString().replaceAll(":", "").replaceAll(" ", "")}${employeeId}.jpg',
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Center(child: CircularProgressIndicator());
                        }, errorBuilder: (context, error, stackTrace) {
                      return Text("Network Error");
                    }, height:  MediaQuery.of(context).size.height * 0.15),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        children: [
                          Icon(Icons.location_on,color: Colors.red,),
                          Expanded(child: Text(locationOut))
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        Icon(Icons.work_history_rounded,color: Colors.red, ),
                        Text(" ${workPlaceOut == "OFFICE"?
                        "OFFICE":workPlaceOut == "WFH"?
                        "Work From Home":"Official Business Travel"}",style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )),
                      ],
                    )

                  ]),
                ),
              )
                  : Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 100,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.blue,
                                  )),
                              onPressed: () async {
                                whatSite = "OFFICE";

                                bool? result = await timeInOutConfirmation(
                                    context,
                                   timeIn == '' ?  (lastTimeOut == '' && lastTimeIn != '')? "Do you want to time out with previous time in?":
                                   "You don't have a time in, do you want to proceed?":
                                   "Do you want to Time out?",
                                    "OFFICE");

                                if (result == true) {
                                  var datetimenow = await NTP.now();
                                  currentTime = DateFormat("hh:mm a").format(datetimenow).toString();
                                  getImage("out");
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/Images/office.png',
                                    height: 50,
                                  ),
                                  Text(
                                    "OFFICE",
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 100,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.blue,
                                  )),
                              onPressed: () async {
                                whatSite = "WFH";
                                bool? result = await timeInOutConfirmation(
                                    context,
                                    timeIn == '' ?  (lastTimeOut == '' && lastTimeIn != '')? "Do you want to time out with previous time in?":
                                    "You don't have a time in, do you want to proceed?":
                                    "Do you want to Time out?",
                                    "Work From Home");

                                if (result == true) {
                                  var datetimenow = await NTP.now();
                                  currentTime = DateFormat("hh:mm a").format(datetimenow).toString();
                                  getImage("out");
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/Images/WFH.png',
                                    height: 50,
                                  ),
                                  Text(
                                    "WFH",
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 100,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.blue,
                                  )),
                              onPressed: () async {
                                whatSite = "OBT";
                                bool? result = await timeInOutConfirmation(
                                    context,
                                    timeIn == '' ?  (lastTimeOut == '' && lastTimeIn != '')? "Do you want to time out with previous time in?":
                                    "You don't have a time in, do you want to proceed?":
                                    "Do you want to Time out?",
                                    "Official Business Travel");

                                if (result == true) {
                                  var datetimenow = await NTP.now();
                                  currentTime = DateFormat("hh:mm a").format(datetimenow).toString();
                                  getImage("out");
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/Images/Site.png',
                                    height: 50,
                                  ),
                                  Text(
                                    "OBT",
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _changePropertiesOut(),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 900),
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: heightTimeOut,
                      decoration: BoxDecoration(
                        color: colorTimeOut,
                        borderRadius: _borderRadiusOut,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: Colors.white,
                            size: heightTimeOut == 300.0 ? 90 : 0,
                          ),
                          Text("Time Out",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 80,
                /*decoration: BoxDecoration(
                    borderRadius: _borderRadiusOut,
                    border: Border.all(width: 1, color: Colors.black)),*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Total hours: ",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),),
                        Text(totalTime,style: TextStyle(
                            fontSize: 20,
                            ),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Version: ",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                      Text("Android $ver")
                    ],)
                  ],
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
