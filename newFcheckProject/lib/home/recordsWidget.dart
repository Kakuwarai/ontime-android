import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../offlineDatabase/sqfLiteDatabase.dart';
import 'healthDeclaration.dart';


class recordsWidget extends StatefulWidget {
  const recordsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<recordsWidget> createState() => SiteWidgets();
}

TextEditingController subordinateTextfieldController = TextEditingController();

class SiteWidgets extends State<recordsWidget> with TickerProviderStateMixin {


  var records =[];
  var employeeId = "";
  var userEmployeeId = "";
  var multiSelectEmployeeId = [];
  var multiSelectEmployeeIdBool = [];
  var subordinateList =[];
  var loadingRecords = false;
  var dialogSubordinateLoad = false;
  var filteredDateDisplay = "Filter";
  var page = 0;
  var pageEmployeesData = 0;
  var pageEmployeesDataStoper = false;
  var pageEmployeesDataLoader = false;
  var pageEmployeesDataLoaderStoper = false;
  late AnimationController controller;
  var filterDate = "";

  @override
  void initState() {
    super.initState();
    getRecords(null);
    getSubordinate();
    gettingUserEmployeeId();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(milliseconds: 1000);
  }

gettingUserEmployeeId()async{
  userEmployeeId = (await DBProvider.db.getEmployeesData("Id")).toString();
}
  getRecords(filteredDate)async{

    setState((){loadingRecords = true;});
    var response = await http.post(
        Uri.parse("${apiLink()}api/FcAttendances/getEmployeeRecords1"),
        body: {
          "employeeId":employeeId == ""?(await DBProvider.db.getEmployeesData("Id")).toString():
                        employeeId,
          "filteredDate":filteredDate??"",
          "page":pageEmployeesData.toString()
        });

    if (response.statusCode == 200) {
      records.clear();
      final List fetchedPost = json.decode(response.body);
      if(fetchedPost.isNotEmpty){

        records.addAll(fetchedPost);
        pageEmployeesData = pageEmployeesData + 1;
      }

      setState((){});
    }
    setState((){loadingRecords = false;});
  }

  getRecordsExtended(filteredDate)async{

if(pageEmployeesDataStoper == false && pageEmployeesDataLoaderStoper == false){
 setState(() {
   pageEmployeesDataLoader = true;
 });
  pageEmployeesDataStoper = true;

    var response = await http.post(
        Uri.parse("${apiLink()}api/FcAttendances/getEmployeeRecords1"),
        body: {
          "employeeId":employeeId == ""?(await DBProvider.db.getEmployeesData("Id")).toString():
          employeeId,
          "filteredDate":filteredDate??"",
          "page":pageEmployeesData.toString()
        });

    if (response.statusCode == 200) {

      final List fetchedPost = json.decode(response.body);
      if(fetchedPost.isNotEmpty){

        records.addAll(fetchedPost);

        pageEmployeesData = pageEmployeesData + 1;
      }else{
        pageEmployeesDataLoaderStoper = true;

      }
      pageEmployeesDataStoper = false;
      pageEmployeesDataLoader = false;

      setState((){});
    }
}
  }

  getSubordinate()async{

    var response = await http.post(
        Uri.parse("${apiLink()}api/FcAttendances/getEmployeeSubordinateRecords1"),
        body: {
          "employeeId":(await DBProvider.db.getEmployeesData("Id")).toString(),
          "page":page.toString(),
          "search": subordinateTextfieldController.text
        });

    if (response.statusCode == 200) {

      final List fetchedPost = json.decode(response.body);
      if(fetchedPost.isNotEmpty){
        setState(() {
          subordinateList.addAll(fetchedPost);
          multiSelectEmployeeIdBool.clear();

            for(int index = 0 ; index < subordinateList.length; index++){
              if(multiSelectEmployeeId.contains(subordinateList[index]["employeeId"]) ){
                multiSelectEmployeeIdBool.add(true);
              }else{
                multiSelectEmployeeIdBool.add(false);
              }

          }


        });

        page = page + 1;
      }
    }

  }

  getSubordinateExtended()async{

    var response = await http.post(
        Uri.parse("${apiLink()}api/FcAttendances/getEmployeeSubordinateRecords1"),
        body: {
          "employeeId":(await DBProvider.db.getEmployeesData("Id")).toString(),
          "page":page.toString(),
          "search": subordinateTextfieldController.text
        });

    if (response.statusCode == 200) {

      final List fetchedPost = json.decode(response.body);
      if(fetchedPost.isNotEmpty){
        setState(() {
          subordinateList.addAll(fetchedPost);
        });

        page = page + 1;
      }
    }

  }

  dialogDateTimePicker() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));

    filteredDateDisplay =DateFormat("MM/dd/yyyy")
        .format(picked!)
        .toString();

    pageEmployeesDataLoaderStoper = false;
    getRecords(picked.toString());
    filterDate = picked.toString();
    setState(() {

    });

  }

  dialogChooseSubordinate(){

    return showModalBottomSheet(
        backgroundColor: Colors.white, transitionAnimationController: controller,
        isScrollControlled: true,
        context: context, builder: (context){
      return StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.78,
                      child: TextField(
                        controller: subordinateTextfieldController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search Subordinate"
                      ),),
                    ),
                    ElevatedButton(onPressed: ()async{
                      setState((){dialogSubordinateLoad = true;});
                      page = 0;
                      subordinateList.clear();
                      await getSubordinate();
                      setState((){dialogSubordinateLoad = false;});
                    }, child: Text("Search"))
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [

                      ElevatedButton(onPressed: (){
                        //employeeId = subordinateList;
                        filteredDateDisplay = "Filter";
                        employeeId = "${userEmployeeId},*";
                        pageEmployeesDataLoaderStoper = false;
                        pageEmployeesData = 0;
                        records.clear();
                        getRecords(null);
                        Navigator.pop(context);

                      }, child: Text("View All")),

                      SizedBox(width: 10,),

                      ElevatedButton(onPressed: (){
                        filteredDateDisplay = "Filter";
                        employeeId = multiSelectEmployeeId.toString().replaceAll('[', '').replaceAll(']', '');
                        records.clear();
                        pageEmployeesData = 0;
                        pageEmployeesDataLoaderStoper = false;
                        getRecords(null);
                        Navigator.pop(context);
                      }, child: Text("View selected")),

                    ],
                  ),
                ),

                Expanded(child:
                NotificationListener<ScrollNotification>(

                  onNotification:  (scrollNotification) {
                    final metrics = scrollNotification.metrics;
                    // if (metrics.atEdge) {
                    //   bool isTop = metrics.pixels == 0;
                    //   if (!isTop) {
                    //     setState((){
                    //       setState((){dialogSubordinateLoad = true;});
                    //       getSubordinateExtended();
                    //       setState((){dialogSubordinateLoad = false;});
                    //     });
                    //
                    //     Future.delayed(Duration(seconds: 1), ()async{
                    //
                    //     });
                    //   }
                    // }

                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async{
                      setState((){dialogSubordinateLoad = true;});
                      await getSubordinate();
                      setState((){dialogSubordinateLoad = false;});
                    },
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: subordinateList.length, itemBuilder: (context, index){

                      return Padding(padding: const EdgeInsets.all(8.0),
                        child:
                        Dismissible(
                          key: Key(index.toString()),
                          confirmDismiss: (direction) async{
                          },

                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Material(
                              color: index % 2 == 0 ? Colors.transparent :Colors.blue.withOpacity(0.05),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.grey.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                onTap: (){
                                  setState((){
                                    employeeId = subordinateList[index]['employeeId'].toString();
                                    filteredDateDisplay = "Filter";
                                    pageEmployeesDataLoaderStoper = false;
                                    pageEmployeesData=0;
                                    getRecords(null);
                                    Navigator.pop(context);
                                  });
                                },
                                onLongPress: ()async{

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                      columnWidths:const {
                                        1: FlexColumnWidth(0.2),
                                      },
                                      children: [
                                        TableRow(children: [



                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(subordinateList[index]['fullname']),
                                              Checkbox(value: multiSelectEmployeeIdBool[index], onChanged: (value){
                                                multiSelectEmployeeIdBool[index] = value! == false?false:true;
                                                if(value == true){
                                                  multiSelectEmployeeId.add(subordinateList[index]['employeeId']);
                                                }else{
                                                  multiSelectEmployeeId.remove(subordinateList[index]['employeeId']);
                                                }

                                                setState((){});
                                              })
                                            ],
                                          ),


                                        ],
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                ),
                if(dialogSubordinateLoad == true)
                  const Padding(padding: EdgeInsets.only(top: 10, bottom: 40)
                    ,child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            for(int index=0; index<records.length;index++)
            Container(
              height: 10000,
              padding: const EdgeInsets.all(8),
              color: Colors.blue,
              child: Text("Type: ${records[index]["workPlace"]}\n\n"

                  "Time In: ${records[index]["timeIn"]}\n\n"

                  "Time Out:${records[index]["timeOut"]}\n\n"

                  "Total Time: ${records[index]["totalTime"]}\n\n"

                  "Location: ${records[index]["location"]}\n\n"

                  "Date: ${records[index]["date"]}"),
            ),
          ],8 a
        ),
      )*/

        if(subordinateList.length > 0)
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: (){
                dialogChooseSubordinate();
              }, child:
              Text(employeeId == ''? "Subordinate List": employeeId.contains(",")?"Multiselect List":
              records.length == 0? 'Subordinate List':records[0]["fullname"])
              ),
              SizedBox(width: 8.0,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                  ),
                  onPressed: () {
                    employeeId = '';
                    pageEmployeesDataLoaderStoper = false;
                    filteredDateDisplay = "Filter";
                    pageEmployeesData = 0;
                    getRecords(null);
                  },
                  child: Icon(Icons.clear_rounded))
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: (){
              pageEmployeesDataLoaderStoper = false;
              filteredDateDisplay = "Filter";
              pageEmployeesData = 0;
              filterDate = "";
              getRecords(null);

              setState(() {

              });
            }, child: Icon(Icons.refresh)),

            SizedBox(width: 10,),

            ElevatedButton(onPressed: (){
              pageEmployeesData = 0;
              dialogDateTimePicker();
            }, child: Row(
              children: [
                Icon(Icons.filter_list),
                Text(filteredDateDisplay),
              ],
            )),

            SizedBox(width: 10,),
          ],
        ),
        if(records.length == 0)...[
          loadingRecords? Padding(
            padding:  const EdgeInsets.only(top: 200),
            child: CircularProgressIndicator(),
          ):Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child:const Center(child: Text("No Records", style: TextStyle(fontSize: 50,color: Colors.black54))),

          )
        ]
        else...[



          loadingRecords? Padding(
            padding: const EdgeInsets.only(top: 200),
            child: CircularProgressIndicator(),
          ):SizedBox(
            height:pageEmployeesDataLoader == true?
            MediaQuery.of(context).size.height * 0.6:
            MediaQuery.of(context).size.height * 0.72,
            child: NotificationListener<ScrollNotification>(
              onNotification:  (scrollNotification) {
                final metrics = scrollNotification.metrics;
                if (metrics.atEdge) {
                  bool isTop = metrics.pixels == 0;
                  if (!isTop) {
                    setState((){

                      getRecordsExtended(filterDate);
                    });


                  }
                }
                return true;
              },
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount:records.length,
                  itemBuilder: (context, index){
                    return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all()
                          ),
                          child: Column(
                            children: [
if(employeeId.contains(","))...[
  Text(records[index]["fullname"],style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold, fontSize: 20),),
  SizedBox(height: 10,)
],

                              Container(
                                decoration:const BoxDecoration(
                                  border:Border(
                                    bottom: BorderSide(width: 1, color: Colors.black),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${records[index]["workPlace"]} / ${records[index]["workPlaceOut"]}",style:const TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold),),
                                    Text(DateFormat("MM/dd/yyyy").format(DateTime.parse(records[index]["date"])).toString()
                                        ,style:const TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold)),

                                  ],),
                              ),
                              SizedBox(height: 20,),
                              //Text(records[index]["workPlace"],style: TextStyle(color: Colors.white),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Image.network(
                                  //     'https://apps.fastlogistics.com.ph/fastdrive//ontimemobile/'
                                  //         '${records[index]["employeeId"]}/'
                                  //         '${DateFormat("yyyy dd MM").format(DateTime.parse(records[index]["date"])).toString()}/'
                                  //         '${records[index]["timeIn"].toString().replaceAll(":", "").replaceAll(" ", "")}${records[index]["employeeId"]}.jpg'),
                                  Column(children: [
                                    const Icon(Icons.timer_sharp,color: Colors.blue,),
                                    Text("${records[index]["timeIn"]??"No Logs"}",style:const TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: records[index]["timeIn"]==null?Colors.grey:Colors.blue,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(width: 1,color: Colors.black)
                                        ),
                                        child: TextButton(onPressed: records[index]["timeIn"] == null?null:(){

                                          pictureEvidence(context, records[index]["employeeId"],
                                              records[index]["timeIn"].toString().replaceAll(":", "").replaceAll(" ", ""),
                                              DateFormat("yyyy dd MM").format(DateTime.parse(records[index]["date"])).toString(),
                                              records[index]["date"],"in");

                                        }, child: Text("view",style: TextStyle(color: Colors.white),)),
                                      ),
                                    ),
                                  ],),

                                  Column(children: [
                                    const Icon(Icons.timer_off_outlined,color: Colors.red,),
                                    Text("${records[index]["timeOut"]??"No Logs"}",style:const TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: records[index]["timeOut"]==null?Colors.grey:Colors.blue,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 1,color: Colors.black)
                                        ),
                                        child: TextButton(
                                            onPressed: records[index]["timeOut"] == null?null:(){

                                              pictureEvidence(context, records[index]["employeeId"],
                                              records[index]["timeOut"].toString().replaceAll(":", "").replaceAll(" ", ""),
                                              DateFormat("yyyy dd MM").format(DateTime.parse(records[index]["date"])).toString(),
                                              records[index]["date"],"out");

                                        }, child: Text("view",style: TextStyle(color: Colors.white,),)),
                                      ),
                                    ),
                                  ],),

                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: const Icon(Icons.lock_clock,color: Colors.green,),
                                    ),
                                    Text("${records[index]["totalTime"]??"No Logs"}",style:const TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                    TextButton(onPressed:null, child: Text("")),
                                  ],),
                                ],),

                              SizedBox(height: 20,),

                              Row(children: [
                                const Icon(Icons.location_on,color: Colors.blue,),
                                Expanded(child:
                                Text("${records[index]["locationIn"]??"No Logs"}",style:
                                TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.bold))),
                              ],),
                              SizedBox(height: 20,),

                              Row(children: [
                                const Icon(Icons.location_on,color: Colors.red,),
                                Expanded(child:
                                Text("${records[index]["locationOut"]??"No Logs"}",style:
                                TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.bold))),
                              ],),
                              SizedBox(height: 10,),
                              //Text(records[index]["department"],style: TextStyle(color: Colors.white)),
                              //Text(records[index]["sbu"],style: TextStyle(color: Colors.white)),
                              //Text(records[index]["date"],style: TextStyle(color: Colors.white)),
                            ],),
                        )

                    );}),
            ),
          ),


        ],
       if(pageEmployeesDataLoader == true)
          const Padding(padding: EdgeInsets.only(top: 10, bottom: 40)
            ,child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  pictureEvidence(context, employeeId, time, date, cdate, status) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Time ${status} image"),
        actions: [
          //https://apps.fastlogistics.com.ph/fastdrive//ontimemobile/220911842/2023 21 06/
          Center(
            child: Image.network('https://apps.fastlogistics.com.ph/fastdrive//ontimemobile/'
                '${employeeId}/'
                '${date}/'
                '${time}${employeeId}.jpg',height: 300,loadingBuilder: (context, child, loadingProgress) {

              if (loadingProgress == null) {
                return child;
              }

            return Center(child: CircularProgressIndicator());
            },errorBuilder: (context, error, stackTrace) {
        /*    DateTime dates = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.parse(cdate)));

              final today = DateTime(2023, 06, 22);
              final todays = DateTime(2023, 06, 23);
              final fiftyDaysAgo = today.difference(todays).inMinutes;
*/

 return Center(child: Text("No Data Found"));


            },),
          ),
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

}


