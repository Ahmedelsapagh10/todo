import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/component/shared/cubit/states.dart';
import 'package:todoapp/modules/archived.dart';
import 'package:todoapp/modules/done.dart';
import 'package:todoapp/modules/tasks.dart';

class appCubit extends Cubit<appStates> {
  appCubit() : super(initialState());
  static appCubit get(context) => BlocProvider.of(context);
  int currentindex = 0;
  List<Widget> screens = [
    TasksPage(),
    donepage(),
    ArchivedPage(),
  ];
  List<String> titles = ['Tasks', 'Done', 'Archived'];
  void changeIndex(int index) {
    currentindex = index;
    emit(changeBottomNavBarState());
  }

  List<Map> newTasks = [];

  List<Map> doneTasks = [];

  List<Map> archiveTasks = [];

  Database database;

  createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks(ID INTEGER PRIMARY KEY ,TITLE TEXT,DATE TEXT ,TIME TEXT,STATUS TEXT)')
          .then((value) {
        print('table created');
        print('database Created !');
      });
    }, onOpen: (database) {
      getDataFromDataBase(database);
      print('database opened !');
    }).then((value) {
      database = value;
      emit(appCtreateDataBase());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(TITLE,DATE,TIME,STATUS)VALUES("$title","$date","$time","new")')
          .then((value) {
        print('Done$value');
        emit(appInsertDataBase());
        getDataFromDataBase(database);
      }).catchError((error) {
        print('error happen${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      print('$newTasks');
      value.forEach((element) {
        if (element['STATUS'] == 'new')
          newTasks.add(element);
        else if (element['STATUS'] == 'done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      emit(appGetDataBase());
    });
  }

  bool isButtonsheet = false;
  IconData fdicon = Icons.edit;
  void changeBottonSheet(
      {@required IconData ficon, @required bool isbuttonsheet}) {
    fdicon = ficon;
    isButtonsheet = isbuttonsheet;
    emit(changeSheetAppBarState());
  }

  void updateDataBase({
    @required String STATUS,
    @required int ID,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET STATUS = ? WHERE ID = ?',
      ['$STATUS', ID],
    ).then((value) {
      getDataFromDataBase(database);
      emit(appUpdateDataBase());
    });
  }

  void DeleteDataBase({
    @required int ID,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks  WHERE ID = ?',
      [ID],
    ).then((value) {
      getDataFromDataBase(database);
      emit(appDeleteDataBase());
    });
  }
}
