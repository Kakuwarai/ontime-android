import 'dart:async';
import 'dart:convert';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:newfcheckproject/offlineDatabase/database_helper.dart';
import 'package:ntp/ntp.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:newfcheckproject/offlineDatabase/sqfLiteDatabase.dart';
import 'package:newfcheckproject/deviceInfo.dart';

import 'home/healthDeclaration.dart';

class authenticationLogin extends StatefulWidget {
  const authenticationLogin({Key? key,}):super(key: key);

  @override
  State<authenticationLogin> createState() => _authenticationLogin();
}

class _authenticationLogin extends State<authenticationLogin> with TickerProviderStateMixin {
  String status = "0";

  TextEditingController  employeeIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  bool emptyEmployeeID = false;
  bool emptyEmail = false;
  bool pleasewait = false;
  String otpPin = " ";
  int screenState = 0;
  late StreamSubscription<bool> keyboardSubscription;
  bool isKeyboardOut = false;


  void initState() {
    appver();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState((){  isKeyboardOut = visible;});
    });
    super.initState();
    deviceinfo("id");
  }
var appvers = '';
  appver()async{
    appvers = await appVersion();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () {
        setState(() {
          screenState = 0;
        });
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Transform.translate(
                offset:  Offset(0,(bottom > 0?0:-150)),
                child:  Align(
                  heightFactor: 2000,
                  alignment: Alignment.center,
                  child: Image.asset('assets/Images/appBar.png',),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight / 8),
                  child: Column(
                    children: [
                      Column(children: [
                        Text(bottom > 0?"":"Version: ${appvers}",style: TextStyle(color: Colors.white),),
                      ],),
                      Text(bottom > 0?"":
                        "OnTime Mobile",
                        style: GoogleFonts.montserrat(
                          color:isKeyboardOut? Colors.blue :Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 10,
                        ),
                      ),
                      Text(bottom > 0?"":
                        "Hello and Welcome!",
                        style: GoogleFonts.montserrat(
                          color: isKeyboardOut? Colors.blue :Colors.white,
                          fontSize: screenWidth / 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  height: bottom > 0 ? screenHeight : screenHeight / 2,
                  width: screenWidth,
                  color: isKeyboardOut ?Colors.transparent:Colors.white,
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth / 12,
                      right: screenWidth / 12,
                      top: bottom > 0 ? screenHeight / 12 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        screenState == 0 ? stateRegister() : stateOTP(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              color:bottom > 0? Colors.transparent: Colors.blue,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextButton(onPressed: () async{
                            if(pleasewait == false){
                            setState(() {
                              pleasewait = true;
                            });

                            if(employeeIdController.text.isEmpty){
                              emptyEmployeeID = true;
                            }else{
                              emptyEmployeeID =false;
                            }
                            if(emailController.text.isEmpty){
                              emptyEmail = true;
                            }
                            else{
                              emptyEmail = false;
                            }

                            if(screenState ==0){
                              var response = await http.post(Uri.parse("${apiLink()}api/FcEmployees/email1"),
                            body: {
                              "emailAddress": emailController.text,
                              "fcEmployees":employeeIdController.text,
                              "deviceId":"${await deviceinfo("id")}${await deviceinfo("hardware")}${await deviceinfo("manufacturer")}${await deviceinfo("model")}",
                              "device":"${await deviceinfo("brand")}  ${await deviceinfo("model")}"
                            });
                            if (response.statusCode == 200) {
                              if(response.body == "isNull"){
                                showSnackBarText("Invalid Employee ID");
                              }
                              if(response.body == "Account is already logged in to other device"){
                                showSnackBarText("Account is already logged in to other device");
                              }
                              if(response.body == "Email sent"){
                                showSnackBarText("Email sent");
                              setState(() {
                              screenState = 1;
                              });}

                            }else{
                              statusDialog(context, "${response.statusCode}: ${response.body}", false);
                            }
                          }else{
                              var response = await http.post(Uri.parse("${apiLink()}api/FcEmployees/verification1"),
                                  body: {
                                "fcEmployees":employeeIdController.text,
                                "verificationCode": pinController.text,
                                "deviceInfo":"${await deviceinfo("id")??""}${await deviceinfo("hardware")??""}${await deviceinfo("manufacturer")??""}${await deviceinfo("model")??""}"
                                  });
                              if (response.statusCode == 200) {
                                var body =  jsonDecode(response.body) as List<dynamic>;
                                if(body[0].toString() == "verified"){
                                  showSnackBarText("Email sent");
                                var thisEmployee = employees(
                                    id: 0,
                                    employeeId: employeeIdController.text,
                                    employeeName:body[1].toString() ,
                                    dateAndTime: "temporaryData",
                                    sbu: body[2].toString(),
                                    department: body[3].toString());
                                DBProvider.db.newUser(thisEmployee);
                                Navigator.pushReplacementNamed(context, "/homeScreen");
}
                              }else{
                                statusDialog(context, "${response.statusCode}: ${response.body}", false);

                              }
                            }
                            setState(() {
                              pleasewait = false;
                            });
                            }

                          }, child: Text(pleasewait? "Please wait!...":"CONTINUE",style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 18,
                          ),)),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8,),
        TextFormField(
          controller: employeeIdController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true, //<-- SEE HERE
            fillColor: Colors.white,
            hintText: "Employee Id",
            errorText: emptyEmployeeID? "Please Enter Employee ID":
            null,
            prefixIcon:const Icon(Icons.perm_identity_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
          onChanged: (text){
            setState((){
              emptyEmployeeID = false;
            });

          },
        ),
        const SizedBox(height: 10,),

        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            prefixIcon:const Icon(Icons.email_outlined),
            filled: true, //<-- SEE HERE
            fillColor: Colors.white,
            hintText: "Email",
            errorText: emptyEmail? "Please Enter Email":
            null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
          onChanged: (text){
            setState((){
              emptyEmail = false;
            });

          },
        ),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "We just sent a code to ",
                style: GoogleFonts.montserrat(
                  color: isKeyboardOut? Colors.greenAccent:Colors.black87,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text:  emailController.text,
                style: GoogleFonts.montserrat(
                  color:isKeyboardOut? Colors.greenAccent:Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "\nEnter the code here and press continue!",
                style: GoogleFonts.montserrat(
                  color: isKeyboardOut? Colors.greenAccent:Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
        PinCodeTextField(
          appContext: context,
          length: 6,
          controller: pinController,
          onChanged: (value) {
            setState(() {
              otpPin = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: Colors.greenAccent,
            selectedColor: Colors.black26,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(height: 20,),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Didn't receive the code? ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () async{
                    var response = await http.post(Uri.parse("${apiLink()}api/FcEmployees/email1"),
                        body: {
                        "emailAddress": emailController.text,
                        "fcEmployees":employeeIdController.text,
                        "deviceId":"${await deviceinfo("id")}${await deviceinfo("hardware")}${await deviceinfo("manufacturer")}${await deviceinfo("model")}",
                        "device":"${await deviceinfo("brand")}  ${await deviceinfo("model")}"
                        });
                    print("${response.statusCode} - ${response.body}");
                    showSnackBarText("Email Resent");
                  },
                  child: Text(
                    "Resend",
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget circle(double size) {
    return Container(
      height: screenHeight / size,
      width: screenHeight / size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  }

/*
class _authenticationLogin extends State<authenticationLogin> with TickerProviderStateMixin {

  String status = "0";

  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  String otpPin = " ";
  String countryDial = "+63";
  String verID = " ";
  int screenState = 0;
  late StreamSubscription<bool> keyboardSubscription;
  bool isKeyboardOut = false;
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState((){  isKeyboardOut = visible;});
    });
    super.initState();
  }

  employeeCheckere() async{

    var response = await http.post(Uri.parse("${apiLink()}api/FcEmployees"),
        body: {
          "fcEmployees": usernameController.text,
          "deviceInfo": await deviceinfo(),
        });
    if (response.statusCode == 200) {
      dynamic employeeId = response.body;
      if(employeeId == "isNull"){
        showSnackBarText("no such employee Id");
      }
      else if (employeeId == "AlreadyLogIn"){
        showSnackBarText("The account is already logged in to the other device!");
      }
      else{
        verifyPhone(countryDial + phoneController.text);
      }
    }
  }

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 20),
      verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Auth Completed!");
        setState(() {
          pinController.text = credential.smsCode.toString();
          print(credential.smsCode.toString());
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP Sent!");
        verID = verificationId;
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Timeout! $verificationId ");
      },
    );
  }

  Future<void> verifyOTP() async {
    DateTime verifiedDate = await NTP.now();
    await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: otpPin,
      ),
    ).whenComplete(() {
      var thisEmployee = employees(
          id: 0,
          employeeId: int.parse(usernameController.text),
          dateAndTime: "temporaryData");
      DBProvider.db.newUser(thisEmployee);
     Navigator.pushReplacementNamed(context, "/homeScreen");
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () {
        setState(() {
          screenState = 0;
        });
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.redAccent,
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Transform.translate(
                offset: const Offset(50, -170),
                child: Align(
                  alignment: Alignment.center,
                  child: circle(8),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight / 8),
                  child: Column(
                    children: [
                      Text(
                        "Fact Check",
                        style: GoogleFonts.montserrat(
                          color:isKeyboardOut? Colors.blue :Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 8,
                        ),
                      ),
                      Text(
                        "Hello and Welcome!",
                        style: GoogleFonts.montserrat(
                          color: isKeyboardOut? Colors.blue :Colors.white,
                          fontSize: screenWidth / 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(10, 300),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: circle(5),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: circle(10),
                ),
              ),
              Transform.translate(
                offset: const Offset(50, -100),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: circle(10),
                ),
              ),


              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  height: bottom > 0 ? screenHeight : screenHeight / 2,
                  width: screenWidth,
                  color: isKeyboardOut ?Colors.transparent:Colors.white,
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth / 12,
                      right: screenWidth / 12,
                      top: bottom > 0 ? screenHeight / 12 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        screenState == 0 ? stateRegister() : stateOTP(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: TextButton(onPressed: (){

                            if(screenState == 0) {
                              if(usernameController.text.isEmpty) {
                                showSnackBarText("Username is still empty!");
                              } else if(phoneController.text.isEmpty) {
                                showSnackBarText("Phone number is still empty!");
                              } else {
                                employeeCheckere();
                              }
                            } else {
                              if(otpPin.length >= 6) {
                                verifyOTP();
                              } else {
                                showSnackBarText("Enter OTP correctly!");
                              }
                            }
                          }, child: Text("CONTINUE",style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 18,
                          ),)),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8,),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            filled: true, //<-- SEE HERE
            fillColor: Colors.white,
            hintText: "Employee Id",
            prefixIcon:const Icon(Icons.perm_identity_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 10,),

        IntlPhoneField(
          controller: phoneController,
          showCountryFlag: false,
          showDropdownIcon: false,
          initialValue: countryDial,
          onCountryChanged: (country) {
            setState(() {
              countryDial = "+${country.dialCode}";
            });
          },
          decoration: InputDecoration(
            filled: true, //<-- SEE HERE
            fillColor: Colors.white,
            hintText: "Phone number",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "We just sent a code to ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: countryDial + phoneController.text,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "\nEnter the code here and press continue!",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
        PinCodeTextField(
          appContext: context,
          length: 6,
          controller: pinController,
          onChanged: (value) {
            setState(() {
              otpPin = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: Colors.blue,
            selectedColor: Colors.blue,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(height: 20,),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Didn't receive the code? ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      screenState = 0;
                    });
                  },
                  child: Text(
                    "Resend",
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget circle(double size) {
    return Container(
      height: screenHeight / size,
      width: screenHeight / size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }

}*/
