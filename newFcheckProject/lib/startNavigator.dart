
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newfcheckproject/dashboardPage.dart';
import 'package:newfcheckproject/home/homeScreen.dart';

import 'home/healthDeclaration.dart';
import 'home/recordsWidget.dart';

class mainAdminNav extends StatefulWidget {
  const mainAdminNav({Key? key,}) :super(key: key);

  @override
  State<mainAdminNav> createState() => _mainAdminNav();
}

class _mainAdminNav extends State<mainAdminNav>{
  var fullname = "";
  var branchName = "";
  void initState(){

    super.initState();
  }


  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(accountName: Text(branchName), accountEmail: Text(fullname)),

          ListTile(
            tileColor: Colors.blue,
            textColor:Colors.white,
            leading:const Icon(Icons.people,color:Colors.white,),
            title:const Text("Dashboard"),
            onTap: () => selectedIem(context, 0),
          ),
          ListTile(
            tileColor: Colors.blue,
            textColor:Colors.white,
            leading:const Icon(Icons.people,color:Colors.white,),
            title:const Text("Home"),
            onTap: () => selectedIem(context, 1),
          ),
          ListTile(
            tileColor: Colors.blue,
            textColor:Colors.white,
            leading:const Icon(Icons.people,color:Colors.white,),
            title: const Text("Health Declaration"),
            onTap: () => selectedIem(context, 1),
          ),
          ListTile(
            tileColor: Colors.blue,
            textColor:Colors.white,
            leading:const Icon(Icons.people,color:Colors.white,),
            title: const Text("Records"),
            onTap: () => selectedIem(context, 1),
          ),


        ],
      ),
    );
  }
  void selectedIem(BuildContext context,int index){

    switch (index){
      case 0 :
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const dashboard()),);
        break;

      case 1:
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const homeScreen()),);
        break;

      case 2:
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const homeScreen()),);
        break;
    }
    setState(() {

    });
  }
}