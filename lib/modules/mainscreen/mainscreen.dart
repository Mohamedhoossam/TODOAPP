import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/componentes.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';


class MainScreen extends StatelessWidget {



  var titlecontroler = TextEditingController();
  var datecontroler = TextEditingController();
  var timecontroler = TextEditingController();
  var scaffoldkey=GlobalKey<ScaffoldState>();
  var formkey=GlobalKey<FormState>();


  @override


  Widget build(BuildContext context) {

    return BlocProvider(

      create: (BuildContext context) =>AppCubit()..CreateDatabase(),

      child: BlocConsumer<AppCubit,AppState>(
        listener: (context,state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return  Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              backgroundColor: Colors.red,
              




              elevation: 0.0,
              foregroundColor: Colors.indigo,
              title:  cubit.screensName[cubit.currentIndex],
            ),
            body: Container(
                color: Colors.white54,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: cubit.screens[cubit.currentIndex],
                )),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,

              onTap: (index){

                cubit.getIndex(index);


              },

              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'new task'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'done task'),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'archive task'),
              ],

              currentIndex: cubit.currentIndex,
              fixedColor: Colors.red,
              unselectedItemColor:Colors.black,




            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              child:
              Icon(cubit.floatIcon),
              onPressed: (){
                cubit.currentIndex=0;
                if(cubit.isShowBottomSheet){
                  if(formkey.currentState!.validate()){

                    cubit.InsertDatabase(title: titlecontroler.text, date: timecontroler.text, time: datecontroler.text);
                    titlecontroler.clear();
                    timecontroler.clear();
                    datecontroler.clear();


                }}
                else{

                scaffoldkey.currentState!.showBottomSheet((context)=>Form(
                key: formkey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                          color: Colors.grey,
                          child:
                          Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child:
                            Text('Cancel',style: TextStyle(fontSize: 16.0,color: Colors.white),),

                            ),
                          ],
                          ),
                      ),
                  ),
                  // SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [


                      DefultTextFormFiled(
                      labelText: 'New Task Title',
                      prefix: Icons.title,
                      control: titlecontroler,
                      validate: (value){
                      if(value!.isEmpty){

                      return 'Title Must Not be Empty';
                      }
                      },



                      ),
                      SizedBox(height: 15.0,),
                      DefultTextFormFiled(
                      labelText: 'New Task time',
                      prefix: Icons.watch_later_outlined,
                      control: timecontroler,
                      lockKeyboard: true,
                      validate: (value){
                      if(value!.isEmpty){

                      return 'time Must Not be Empty';
                      }
                      },
                      ontap: (){
                      showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {


                      timecontroler.text=value!.format(context);



                      });

                      }



                      ),
                      SizedBox(height: 15.0,),
                      DefultTextFormFiled(
                      labelText: 'New Task time',
                      prefix: Icons.calendar_today,
                      control: datecontroler,
                      lockKeyboard: true,
                      validate: (value){
                      if(value!.isEmpty){

                      return 'date Must Not be Empty';
                      }
                      },
                      ontap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse('2090-12-30')).then((value){

                      datecontroler.text=DateFormat.yMMMd().format(value!);

                      } );

                      }



                      ),

                      ],
                      ),
                    ),
                  ],
                ),

                )).closed.then((value){


                  cubit.getChangeIcon(Icons.edit, false);

                });


                cubit.getChangeIcon(Icons.add, true);
                }
              },

            ),


          );
        },

      ),
    );
  }


}
