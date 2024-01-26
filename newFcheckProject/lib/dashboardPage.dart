import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newfcheckproject/startNavigator.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key,}):super(key: key);

  @override
  State<dashboard> createState() => _dashboard();
}




class _dashboard extends State<dashboard> with TickerProviderStateMixin {
  List coronaSymptoms =[
    "Conjunctivitis",
    "High Fever",
    "Cough",
    "Head Ache",
  ];
  List coronaPrevention =[
    "Wash Hands",
    "Sanitized",
    "Wear Mask",
    "Social Distancing",
    "Vaccinate"
  ];
  List stayHome =[
    "Stay Home",
    "",
    "",
    "",
    ""
  ];

  List <Icon> newIcon = [
    Icon(Icons.home_outlined,size: 170,color: Colors.blue,),
    Icon(Icons.account_box),
    Icon(Icons.accessible_outlined),
    Icon(Icons.access_time_sharp),
    Icon(Icons.access_time_sharp)];

  var pleaseWaitDot = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

body: Center(
  child:   ListView(
  children: <Widget>[
    PreferredSize(
      preferredSize: Size.fromHeight(200.0), // here the desired height
      child: AppBar(
        shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),
        flexibleSpace: Image.asset('assets/Images/appBar.png',
        height: 200,),
      ),
    ),
    SizedBox(height: 10,),
    const Text("Corona Virus Symptoms",style: TextStyle(color: Colors.green)),
   Container(
    height: 200,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(4, (int index) {
        return  Column(
          children: [
            Card(
              child: Image.asset('assets/Images/corona${index+1}.png',
                height: 150,),
            ),
            Text(coronaSymptoms[index]),
          ],
        );
      }),
    ),
  ),
Text("Corona Virus Prevention",style: TextStyle(color: Colors.green),),

        Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(5, (int index) {
              return  Column(
                children: [
                  Card(
                    child:  Image.asset('assets/Images/covidP${index+1}.png',
                      height: 150,),
                  ),
                  Text(coronaPrevention[index]),
                ],
              );

            }),
          ),
        ),


/*Text("If You Feel Sick",style:
  TextStyle(
    color: Colors.green
  ),),
    Container(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(stayHome.length, (int index) {
          return  Column(
            children: [
              Card(
                child: newIcon[index],
              ),
              Text(stayHome[index])
            ],
          );
        }),
      ),
    ),*/
SizedBox(height: 20,),
     TextButton(onPressed: (){
       setState((){
         pleaseWaitDot = "Please Wait...";
       });
       Timer(const Duration(seconds: 1), () {
         Navigator.of(context).pushReplacementNamed("/homeScreen");
       });

     }, child: Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
       Text(pleaseWaitDot!=""?pleaseWaitDot:"NEXT",style:const TextStyle(fontSize: 20),),
       Icon(pleaseWaitDot!=""?Icons.arrow_forward_outlined:Icons.arrow_circle_right_outlined,size: 50,)
     ],))
        ],
      ),
),
    );
  }
  
}
