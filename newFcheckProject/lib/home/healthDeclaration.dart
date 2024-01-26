
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:newfcheckproject/home/homeScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
// import 'package:store_redirect/store_redirect.dart';

import '../offlineDatabase/sqfLiteDatabase.dart';

apiLink(){
   // return "https://apps.fastlogistics.com.ph/devomapi/";
   // return "https://apps.fastlogistics.com.ph/omapi/";
    return "https://c09c-149-30-129-14.ngrok-free.app/";
}

 appVersion() async{
  var ver = "1.3.8";
  return ver;
}

List <bool> healthChecker = [
  //Most Common
  false, false,
  //Serious
  false, false, false,
  //Less Common
  false, false, false, false, false,
  //TRAVEL AND EXPOSURE HISTORY
  false, false, false,
];
List <String> HealthText = [
  //Most Common
  "Fever(37.5°C or Higher)",
  "Tiredness",
  //Serious
  "Difficulty of Breathing",
  "Chest Pain or Pressure",
  "Lost of Speech or Movement",
//Less Common
  "Aches and Pain",
  "Sore Throat",
  "Diarrhea",
  "Loss of Taste or Smell",
  "A rash on skin",
  //TRAVEL AND EXPOSURE HISTORY
  "Exposure to cluster of individuals with flu-like illness in household or workplace",
  "Exposure to confirm case of COVID-19",
  "Exposure to suspect case for COVID-19",
  //Others
];
List <String> newImage = [
  'assets/Images/fever.png',
  'assets/Images/tiredness.png',
  'assets/Images/diff_breathing.png',
  'assets/Images/chest_pain.png',
  'assets/Images/loss_of_speech.png',
  'assets/Images/aches_and_pain.png',
  'assets/Images/sore_throat.png',
  'assets/Images/diarrhea.png',
  'assets/Images/loss_of_taste_and_smell.png',
  'assets/Images/rash_on_the_skin.png',
];
 List<Icon> iconsTransportationList = const [
  Icon(Icons.home),
  Icon(Icons.directions_walk),
  Icon(Icons.train),
  Icon(Icons.airport_shuttle),
  Icon(Icons.car_rental),
  Icon(Icons.accessible_outlined),
  Icon(Icons.directions_bike),
  Icon(Icons.motorcycle),
  Icon(Icons.airplanemode_active),
  Icon(Icons.warehouse),
  Icon(Icons.location_off),
  Icon(Icons.telegram),
 ];

 List <String> nameTransportationList = [
   "Home","Walking","Public Transport","Company Shuttle",
   "Carpool","Private Vehicle","Bicycle", "Motorcycle",
   "Ariplane","Working Site","GPS Error","Teleport"

 ];

sessionEmployeeId() async{
    return await DBProvider.db.getEmployeesData("Id");
}
var latestDate;
dateTimeNow()async{
  var ntp = await NTP.now();
  latestDate = ntp;
  return DateFormat("yyyy/dd/MM").format(ntp).toString();
}
newdatetime(){
  return latestDate;
}

var  selectedWidget = "default";
 isSelectedWidget(isSelectedWidget){
   if(isSelectedWidget == "default"){
     selectedWidget = "default";
   }
   else if(isSelectedWidget == "Guidelines"){
     selectedWidget = "Guidelines";
   }
   else if(isSelectedWidget == "records"){
     selectedWidget = "records";
   }
  return selectedWidget;
}

cSelectedWidget(){
  return selectedWidget;
}

bool healthIconColor = false;
healthIconColorControoler(){
  return healthIconColor;
}

healthIconColorBool (bool){
  healthIconColor = bool;
}

bool loading = false;

Widget healthCare(setState,context){
  return WillPopScope( onWillPop:()async{
    setState((){selectedWidget = "default";});
    return cSelectedWidget();

  },child: loading? const Center(child: CircularProgressIndicator()):
  Column(children: [
        //healthDeclarationWidget(setState,context),
    healthDeclarationWidget(setState,context),
            Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: TextButton(onPressed: (){
                heathCheckDialog(context,setState,"healthCheckSubmitDialog");
              }
              , child: const Text("SUBMIT",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 18,) ) ),
            ),
    const SizedBox(height: 50,)
  ],
              ),);
              }

TextEditingController  otherHealthDec = TextEditingController();

healthDeclarationWidget(setState,context){
  return Column(children: [

    const Text("Health Care"),

    const Text("PART 1. SIGNS AND SYMPTOMS",
      style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold),),

    for(int x=0; x<10;x++)
      Row(children: [
        Image.asset(newImage[x],height: 50, ),
        Expanded(child: Text(HealthText[x])),
        Checkbox(value: healthChecker[x], onChanged: (value){
          setState((){
            healthChecker[x] = value!;
          });
        }),
      ],
      ),
    Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 1,
        color: Colors.black,),
    ),

    const Text("PART 2. TRAVEL AND EXPOSURE HISTORY",
      style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold),),


    for(int x=10; x<13;x++)
      Row(children: [
        Expanded(child: Text(HealthText[x])),
        Checkbox(value: healthChecker[x], onChanged: (value){
          setState((){ healthChecker[x] = value!;});
        }),
      ],
      ),
     const Text("Others",
      style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold),),
    Card(
        color: Colors.grey.shade100,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: otherHealthDec,
            maxLines: 8, //or null
            decoration: const InputDecoration.collapsed(hintText: "Enter your text here"),
          ),
        )
    ),
  ],);
}

transportationWidget(setState,context){
  return Column(children: [
    const Text("\"Method of transportation\""),
  Container(
    width: MediaQuery.of(context).size.width,
  height: 400,
  padding: const EdgeInsets.all(10.0),
  child: GridView.builder(
  itemCount: iconsTransportationList.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,
  crossAxisSpacing: 4.0,
  mainAxisSpacing: 4.0
  ),
  itemBuilder: (BuildContext context, int index){
  return Column(children: [
      IconButton(onPressed: (){
  }, icon: iconsTransportationList[index]),
     Text(nameTransportationList[index],textAlign:TextAlign.center ,),
  ],);
  },
  )
  ),

  ],);
}
Future<bool?> heathCheckDialog(BuildContext context,setState,String selector) async {
  if(selector == "healthCheckDialog"){
    showDialog<bool>(barrierDismissible: false,
      context: context,
      builder: (context) =>  AlertDialog(
        title: const Text("please fill your health care or press submit if no internet connection and fill later",style: TextStyle(fontSize: 15),),
        actions: [
          ElevatedButton(onPressed: (){
            setState((){selectedWidget = "healthCare";});
            Navigator.pop(context, true);
            return cSelectedWidget();
          },
              child: const Text('Go')
          ),
        ],
      ),
    );
  }
  else if(selector == "healthCheckSubmitDialog"){
    showDialog<bool>(
      context: context,
      builder: (context) =>  AlertDialog(
        title: const Text("are you sure?",style: TextStyle(fontSize: 15),),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context, true);
          },
              child: const Text('No')
          ),
          ElevatedButton(onPressed: () async{
            setState(() {
              loading = true;
            });
            try {
              Navigator.pop(context, true);
              var latestDate = await NTP.now();
              var healthDeclaration = "";

              for (int x = 0; x < healthChecker.length; x++) {
                if (healthChecker[x] == true) {
                  healthDeclaration = "${HealthText[x]},$healthDeclaration";
                }
              }
                        if(otherHealthDec.text.trim() != ""){
                          healthDeclaration = "${otherHealthDec.text},$healthDeclaration";
                        }
              var response = await http.post(
                  Uri.parse("${apiLink()}api/FcHealthDeclarations"),
                  body: {
                    "employeeId": (await sessionEmployeeId()).toString(),
                    "sickString": healthDeclaration,
                  });
              if (response.statusCode == 200) {
                await DBProvider.db.dateCorrection(
                    DateFormat("yyyy/dd/MM").format(latestDate).toString());
              }

              return setState(() {
                healthIconColorBool(false);
                isSelectedWidget("default");
                cSelectedWidget();
                loading = false;
              });
            }catch(e){
              setState((){
                healthIconColorBool(false);
                isSelectedWidget("default");
                cSelectedWidget();
                loading = false;
              });
            }
          },
              child: const Text('Yes')
          ),
        ],
      ),
    );
  }

    return null;
}


newUpdate(context,currentVer,newerVer){

  return showDialog(context: context,barrierDismissible: false, builder: (context){
    return WillPopScope(
      onWillPop: () async {

        return false;
      },
      child: AlertDialog(
        title: const Text("App is Outdated!"),
        content: SizedBox(
          height: 50,
          child: Column(
            children: [
              const Text("Please update your app version "),
              Row(
                children: [

                  Text(currentVer,style: TextStyle(color: Colors.red),),
                  const Text(" to "),
                  Text(newerVer,style: TextStyle(color: Colors.blue),)
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[

          ElevatedButton(onPressed: () async {

            Navigator.pop(context, true);

           // window.location.href = 'https://ontime-y07j.onrender.com';
          },
              child: const Text('Ok')
          ),

        ],
      ),
    );
  });
}

loadingD(context, load, loadType){

  if(load == true){

    return showDialog(context: context,barrierDismissible: false, builder: (context){
      return Dialog(
        child: Container(
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Center(child: CircularProgressIndicator()),
              Text(loadType, style: TextStyle(fontWeight: FontWeight.bold),)

            ],
          ),
        ),
      );
    });
  }else{
    Navigator.pop(context);
  }

}

functionestatusDialogicons(value) {
  if (value == false) {
    return Icon(Icons.warning_amber, color: Colors.red, size: 40);
  } else if (value == true) {
    return Icon(
      CupertinoIcons.check_mark_circled,
      color: Colors.green,
      size: 40,
    );
  } else if (value == "third") {
    return Icon(
      Icons.warning_amber,
      color: Colors.yellow.shade700,
      size: 40,
    );
  }
}


statusDialog(context, statusMessage, status) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: functionestatusDialogicons(status),
      title: Text(statusMessage),
      actions: [
        ElevatedButton(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Ok')),
      ],
    ),
  );
}

Future<bool?> timeInOutConfirmation(BuildContext context, Content, type) async {
  bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(type),
        content: Text(Content),
        actions: <Widget>[
          ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes')),
          ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No')),
        ],
      );
    },
  );
  return result;
}

versionDialog(context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(

      title: Row(
        children: [
          Text("Version Log "),
          Icon(
              Icons.history_edu_sharp
          ),
        ],
      ),
      actions: [
    Container(
height: 400,
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 10,
        child: SingleChildScrollView(
          child: Column(
            children: [

              ListTile(
                title: Text("Latest version 1.3.7 (Aug 28 2023)"),
                subtitle: Text("\u2022 New added versions log list\n"
                    "\u2022 New added ONTIME notification\n"
                    "\u2022 Fix slow location loading\n"
                    "\u2022 New location process for faster processing\n"
                    "\u2022 New timezone process"
                ),
              ),
              ListTile(
                title: Text("Version 1.3.6 (Aug 10 2023)"),
                subtitle: Text("\u2022 IOS loading fixed\n"

                    "\u2022 Records subordinate view bug fix(selection of subordinate bug)"
                ),
              ),
              ListTile(
                title: Text("Version 1.3.5 (July 26 2023)"),
                subtitle: Text("\u2022 Minimal UI loading fixed\n"

                    "\u2022 Time in fixed"
                ),
              ),
              ListTile(
                title: Text("Version 1.3.4 (July 19 2023)"),
                subtitle: Text("\u2022 Minimal UI size change\n"
                    "\u2022 Users with subordinates can now multiple select\n"
                    "\u2022 New API implementation (After the update, versions 1.3.3 and below will not work anymore)\n"
                    "\u2022 Records viewing bigger size image fixed\n"
                    "\u2022 Future updates will now lock the app to force users to update to a newer version"
                ),
              ),
              ListTile(
                title: Text("Version 1.3.3 (July 13 2023)"),
                subtitle: Text("\u2022 Smaller UI\n"
                    "\u2022 New Time out system (Night shifts, Note: However the time in and out will not be shown)\n"
                    "\u2022 Records Filter (You can now select which date you want to see\n"
                    "\u2022 Subordinate Tracker (If the user has subordinates, you can now preview their records)"

  ),
              ),
              ListTile(
                title: Text("Version 1.3.1 (July 07 2023)"),
                subtitle: Text("\u2022 Minimal UI loading fixed\n"
                    "\u2022 New UI Update\n"
                    "\u2022 Attendace will now show images\n"
                    "\u2022 Separate time in/out work place\n"
                    "\u2022 DITO SIM connection Fixed\n"
                    "\u2022 IOS time in/out success validation"

                ),
              ),
              ListTile(
                title: Text("Version 1.2.3 (Jun 29 2023)"),
                subtitle: Text("\u2022 Image view in records\n"
                    "\u2022 employeeId starts with 0 will not record in dtr fixed(𝐧𝐨𝐭𝐞 𝐢𝐟 𝐲𝐨𝐮𝐫 𝐈𝐝 𝐬𝐭𝐚𝐫𝐭𝐬 𝐰𝐢𝐭𝐡 𝟎, 𝐩𝐥𝐞𝐚𝐬𝐞 𝐫𝐞𝐥𝐨𝐠𝐢𝐧 𝐨𝐫 𝐫𝐞𝐢𝐧𝐬𝐭𝐚𝐥𝐥 𝐚𝐩𝐩)"

                ),
              ),
              ListTile(
                title: Text("Version 1.2.2"),
                subtitle: Text(""
                ),
              ),
              ListTile(
                title: Text("Version 1.2.1 (Jun 19 2023)"),
                subtitle: Text("\u2022 Login email validations \n"
                    "\u2022 Time in/out validation for checking attendance, getting location, processing time in/out\n"
                    "\u2022 New UI update\n"
                    "\u2022 Work places type: Office, WFH and OBT type"

                ),
              ),
              ListTile(
                title: Text("Version 1.2.0"),
                subtitle: Text(""
                ),
              ),
              ListTile(
                title: Text("Version 1.1.0 (Jun 07 2023)"),
                subtitle: Text("\u2022 Minimal UI loading fixed\n"
                    "\u2022 Application update checker(checking for new updates)\n"
                    "\u2022 UI update\n"
                    "\u2022 Image size compressor update(lighter file transfer)\n"
                    "\u2022 Location in and out preview\n"
                    "\u2022 Date preview\n"
                    "\u2022 Much faster time in/out response\n"
                    "\u2022 More validations for please wait\n"
                    "\u2022 Refresh when slide down\n"
                    "\u2022 Screenshot available\n"
                    "\u2022 Android & windows user can't access IOS Web anymore\n"
                    "\u2022 Safari browser supported (multiple supported browser)\n"
                    "\u2022 Image auto lower resolution\n"
                    "\u2022 Faster time in/out\n"
                    "\u2022 Gallery access to capture only feature\n"
                ),
              ),
              ListTile(
                title: Text("Version 1.0.0 - Version 1.0.5"),
                subtitle: Text(""
                ),
              ),
            ],
          ),
        ),
      ),
    )

        ,
        ElevatedButton(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Ok')),
      ],
    ),
  );
}

// final _checker = AppVersionChecker();
// void  _checkVersion(context) async {
//   _checker.checkUpdate().then((value) {
//     if(value.canUpdate == true) {
//       showDialog(context: context, builder: (context) =>
//           AlertDialog(
//             title: const Text("Update", style: TextStyle(fontSize: 12),),
//             content:  Text(
//                 "There is an updated version, please update from ${ value.currentVersion} to ${value.newVersion}"),
//             actions: [
//               TextButton(onPressed: () =>
//               {
//                 // _launchUrl(value?.appURL ?? "")
//                 StoreRedirect.redirect(androidAppId: 'com.parkFast.parking_app')
//               }, child: const Text("Update")),
//               TextButton(onPressed: () => SystemNavigator.pop(),
//                   child: const Text("Cancel"))
//             ],
//           ));
//     }else{
//       //checkIfLogged();
//     }
//   });
// }