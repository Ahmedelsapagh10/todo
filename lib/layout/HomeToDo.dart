import 'dart:ui';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/component/shared/cubit/cubit.dart';
import 'package:todoapp/component/shared/cubit/states.dart';

class HomeApp extends StatelessWidget {
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var namecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appCubit()..createDataBase(),
      child: BlocConsumer<appCubit, appStates>(
        listener: (context, state) {
          if (state is appInsertDataBase) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          //appCubit
          appCubit cubit = appCubit.get(context);
          return Scaffold(
              key: ScaffoldKey,
              appBar: AppBar(
                title: Text('${cubit.titles[cubit.currentindex]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(cubit.fdicon),
                onPressed: () async {
                  if (cubit.isButtonsheet) {
                    if (formkey.currentState.validate()) {
                      cubit.insertToDatabase(
                        title: namecontroller.text,
                        time: timecontroller.text,
                        date: datecontroller.text,
                      );
                    }
                  } else {
                    ScaffoldKey.currentState
                        .showBottomSheet(
                          (context) => Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: Colors.grey[100],
                                      child: TextFormField(
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Invalid Task..!';
                                          }
                                          return null;
                                        },
                                        controller: namecontroller,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: 'EnterTask',
                                          prefixIcon: Icon(Icons.track_changes),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: Colors.grey[100],
                                      child: TextFormField(
                                        //عشان اظهر شكل الساعه واختار منها
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then(
                                            (value) => timecontroller.text =
                                                value
                                                    .format(context)
                                                    .toString(),
                                            /*دي انا حطيت القيمه ف الcontroller  عشان اظهرها ف التيكت لبيل*/
                                          )
                                              .catchError((error) {
                                            print('');
                                          });
                                          //الساعه
                                        },
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Invalid time..!';
                                          }
                                          return null;
                                        },
                                        controller: timecontroller,
                                        keyboardType: TextInputType.datetime,
                                        decoration: InputDecoration(
                                          labelText: 'timeTask',
                                          prefixIcon:
                                              Icon(Icons.watch_later_outlined),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: Colors.grey[100],
                                      child: TextFormField(
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Invalid Date..!';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2030-10-03'),
                                          ).then((value) => datecontroller
                                                  .text =
                                              DateFormat.yMMMd().format(value));
                                        },
                                        controller: datecontroller,
                                        keyboardType: TextInputType.datetime,
                                        decoration: InputDecoration(
                                          labelText: 'dateTask',
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .closed
                        .then((value) => {
                              cubit.changeBottonSheet(
                                  ficon: Icons.edit, isbuttonsheet: false)
                            });
                    cubit.changeBottonSheet(
                        ficon: Icons.add, isbuttonsheet: true);
                  }
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentindex,
                  onTap: (index) {
                    cubit.changeIndex(index);
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle),
                      label: 'Done',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: 'Archived',
                    ),
                  ]),
              body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentindex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ));
        },
      ),
    );
  }
}
