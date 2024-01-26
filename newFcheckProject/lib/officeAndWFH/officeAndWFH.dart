// import 'package:flutter/foundation.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:newfcheckproject/officeAndWFH/WFHWidget.dart';
// import 'package:newfcheckproject/officeAndWFH/siteWidget.dart';
// import 'officeWidget.dart';
//
// class officeAndWFH extends StatefulWidget {
//   const officeAndWFH({Key? key,}):super(key: key);
//
//   @override
//   State<officeAndWFH> createState() => _officeAndWFH();
// }
// var isSelected;
// thisWidget(String _isSelected){
//     isSelected = _isSelected;
// }
// class _officeAndWFH extends State<officeAndWFH> with TickerProviderStateMixin {
//
//   @override
//   void initState() {
//     //getDataWFH(setState);
//     selectedWorkingWidget();
//     super.initState();
//   }
//
//   selectedWorkingWidget(){
//       if(isSelected == "office"){
//         //return officeWidget(setState,context);
//       }else if (isSelected == "WFH"){
//         return WFHWidget(setState,context);
//       }else if(isSelected == "Site"){
//         return siteWidget();
//       }
//       setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope( onWillPop:()async{
//       Navigator.pushReplacementNamed(context, '/homeScreen');
//       return true;
//
//     },child: Scaffold(
//      appBar: AppBar(title: const Text("Office"),
//      backgroundColor: Colors.transparent,),
//     body:selectedWorkingWidget(),
//     ),
//
//
//
//
//     );
//   }
//
// }