import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archive/archive.dart';
import 'package:todo_app/modules/donetask/donetask.dart';
import 'package:todo_app/modules/newtask/newtask.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppState> {

  AppCubit() :super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  IconData floatIcon = Icons.edit;
  bool isShowBottomSheet = false;

  List<Widget> screens = [
    TaskScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];
  List<Text> screensName = [
    Text('New Task', style: TextStyle(color: Colors.white),),
    Text('Done Task', style: TextStyle(color: Colors.white),),
    Text('Archive Task',style: TextStyle(color: Colors.white),),

  ];


  void getIndex(int index) {
    currentIndex = index;
    emit(AppChangeBatNavBarState());
  }

  void getChangeIcon(IconData iconName, bool isShow) {
    floatIcon = iconName;
    isShowBottomSheet = isShow;
    emit(AppChangeState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];


  void CreateDatabase() {
    openDatabase(
      'todo.db',
      version: 1
      , onCreate: (database, version) {
      print('Database is create');
      database.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT ,status TEXT)')
          .then((value) {
        print('Database is execute');
      }).catchError((error) {
        print('Error in DataBase Crease ${error.toString()}');
      });
    },
      onOpen: (database) {
        GetDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }


  GetDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(AppLoadingGetDatabaseState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      //tasks=value;
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        }
        else {
          archiveTasks.add(element);
        }
      });
      print(value);
      emit(AppGetDatabaseState());
    });
  }


  InsertDatabase({
    required String title,
    required String date,
    required String time,

  }) async {
    await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")')
          .
      then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        GetDatabase(database);
      }).catchError((error) {
        print('Error ${error.toString()}');
      });
    });
  }


  void deleteDatabase({
    required int id
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDatabaseState());
      GetDatabase(database);
    }
    );
  }

  void updateDatabase({
    required int id,
    required String status
  }) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppUpdateDatabaseState());
      GetDatabase(database);
    });
  }
}








