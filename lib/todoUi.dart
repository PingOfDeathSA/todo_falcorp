import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';

class todoUI extends StatefulWidget {
  const todoUI({super.key});

  @override
  State<todoUI> createState() => _todoUIState();
}

late bool showtextfrom = true;
late bool highchecked = false;
late bool mediumchecked = false;
late bool lowchecked = false;
late bool more_infor = false;
late int docsindex = 0;

class _todoUIState extends State<todoUI> {
  TextEditingController UserTaskController = TextEditingController();

// Initialize Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addToFirebase(BuildContext context) async {
    String priority;
    if (highchecked != false && UserTaskController.text.isNotEmpty) {
      priority = 'high';
    } else if (mediumchecked != false && UserTaskController.text.isNotEmpty) {
      priority = 'medium';
    } else if (lowchecked != false && UserTaskController.text.isNotEmpty) {
      priority = 'low';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nothing selected or task is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Add task to Firestore
      await _firestore.collection('Todo').add({
        'task': UserTaskController.text,
        'priority': priority,
        'complete': false,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task added successfully with priority: $priority'),
          duration: Duration(seconds: 2),
        ),
      );

      UserTaskController.clear();
    } catch (e) {
      print('Error adding task to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add task. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                            color: Color(0xffFF8080),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (showtextfrom == false) {
                        setState(() {
                          showtextfrom = true;
                        });
                      } else {
                        setState(() {
                          showtextfrom = false;
                        });
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                  Text('add New Task'),
                ],
              ),
              showtextfrom == true
                  ? Container(
                      margin: EdgeInsets.all(10),
                      width: screenWidth > 1000
                          ? MediaQuery.of(context).size.width * 0.60
                          : MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: UserTaskController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xffD8EFD3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "write something",
                              prefixIcon: Icon(Icons.task),
                              prefixIconColor: Colors.teal,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Select Priority',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    if (lowchecked || mediumchecked == true) {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                              'A Priority has been slected'),
                                          content: Text(''),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      if (highchecked == false) {
                                        setState(() {
                                          highchecked = true;
                                        });
                                      } else {
                                        setState(() {
                                          highchecked = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('High'),
                                      highchecked
                                          ? Icon(
                                              Icons.check_box,
                                              color: Color(0xffFA7070),
                                            )
                                          : Icon(
                                              Icons.check_box,
                                              color: Color(0xff55AD9B),
                                            )
                                    ],
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  if (lowchecked || highchecked == true) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text(
                                            'A Priority has been slected'),
                                        content: Text(''),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    if (mediumchecked == false) {
                                      setState(() {
                                        mediumchecked = true;
                                      });
                                    } else {
                                      setState(() {
                                        mediumchecked = false;
                                      });
                                    }
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Medium',
                                    ),
                                    mediumchecked
                                        ? Icon(
                                            Icons.check_box,
                                            color: Color(0xffFA7070),
                                          )
                                        : Icon(
                                            Icons.check_box,
                                            color: Color(0xff55AD9B),
                                          )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  if (highchecked || mediumchecked == true) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text(
                                            'A Priority has been slected'),
                                        content: Text(''),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    print('alreadychecked');
                                  } else {
                                    if (lowchecked == false) {
                                      setState(() {
                                        lowchecked = true;
                                      });
                                    } else {
                                      setState(() {
                                        lowchecked = false;
                                      });
                                    }
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text('Low'),
                                    lowchecked
                                        ? Icon(
                                            Icons.check_box,
                                            color: Color(0xffFA7070),
                                          )
                                        : Icon(
                                            Icons.check_box,
                                            color: Color(0xff55AD9B),
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (UserTaskController.text.isNotEmpty) {
                                    addToFirebase(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Task cannot be empty'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFF8080),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(
                                    'Add task',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                height: 400,
                width: screenWidth > 1000
                    ? MediaQuery.of(context).size.width * 0.60
                    : MediaQuery.of(context).size.width * 0.8,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Todo')
                      .where('complete', isEqualTo: false)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.discreteCircle(
                          color: Colors.redAccent,
                          size: 25,
                          secondRingColor: Colors.teal,
                          thirdRingColor: Colors.orange,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      var sortedList = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: sortedList.length,
                        itemBuilder: (context, index) {
                          var document = sortedList[index];
                          var task = document['task'].toString();
                          var priority = document['priority'].toString();
                          var timestamp = document['timestamp'] as Timestamp;
                          var date = DateFormat('dd-MMMM-yyyy')
                              .format(timestamp.toDate());

                          return ListTile(
                            leading: Icon(
                              Icons.task_outlined,
                              size: 27,
                              color: priority == 'high'
                                  ? Color(0xffFFB1B1)
                                  : priority == 'medium'
                                      ? Color(0xffF6DCAC)
                                      : Color(0xffBBE9FF),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  "Priority  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                                Text(
                                  priority,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xff55AD9B)),
                                ),
                              ],
                            ),
                            subtitle: docsindex == index
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(task),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(date),
                                          InkWell(
                                            onTap: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('Todo')
                                                  .doc(document.id)
                                                  .update({'complete': true});
                                            },
                                            child: Text('Done', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Text(''),
                            trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  docsindex = index;
                                });
                              },
                              child: docsindex == index
                                  ? Icon(
                                      Icons.remove_red_eye,
                                      color: Color(0xff55AD9B),
                                      size: 35,
                                    )
                                  : Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xff55AD9B),
                                    ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text('No Task Available'),
                    );
                  },
                ),
              )
            ],
          ),
          screenWidth > 1000
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  color: Color(0xffD8EFD3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Completed Tasks",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 700,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Todo')
                              .where('complete', isEqualTo: true)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: LoadingAnimationWidget.discreteCircle(
                                  color: Colors.redAccent,
                                  size: 25,
                                  secondRingColor: Colors.teal,
                                  thirdRingColor: Colors.orange,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              var sortedList = snapshot.data!.docs;
                              return ListView.builder(
                                itemCount: sortedList.length,
                                itemBuilder: (context, index) {
                                  var document = sortedList[index];
                                  var task = document['task'].toString();
                                  var priority =
                                      document['priority'].toString();
                                  var timestamp =
                                      document['timestamp'] as Timestamp;
                                  var date = DateFormat('dd-MMMM-yyyy')
                                      .format(timestamp.toDate());

                                  return ListTile(
                                    leading: Icon(
                                      Icons.task_outlined,
                                      size: 27,
                                      color: priority == 'high'
                                          ? Color(0xffFFB1B1)
                                          : priority == 'medium'
                                              ? Color(0xffF6DCAC)
                                              : Color(0xffBBE9FF),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          "Priority  ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          priority,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Color(0xff55AD9B)),
                                        ),
                                      ],
                                    ),
                                    subtitle: docsindex == index
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(task),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(date),
                                                  InkWell(
                                                    onTap: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Todo')
                                                          .doc(document.id)
                                                          .update({
                                                        'complete': true
                                                      });
                                                    },
                                                    child: Text(''),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Text(''),
                                    trailing: InkWell(child: Text('')),
                                  );
                                },
                              );
                            }
                            return Center(
                              child: Text('No Task Available'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Text('')
        ],
      ),
    );
  }
}
