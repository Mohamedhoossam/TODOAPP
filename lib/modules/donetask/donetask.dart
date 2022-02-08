import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/componentes.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class DoneScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<AppCubit,AppState>(
      listener: (context,state){},
      builder: (context,state){
        var cubit =AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.doneTasks.length>0,
          builder: (context)=>ListView.separated(
            itemBuilder:(context,index)=>ScreenItem(cubit.doneTasks[index],context),
            separatorBuilder:(context,index)=>
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20.0,top: 5.0),
                  child: Container(
                    height: 5.0,width: double.infinity,
                    //color: Colors.white,
                  ),
                ) ,
            itemCount: cubit.doneTasks.length,),
          fallback:(context)=>Center(
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_empty,size: 220.0,color: Colors.grey,),
                Text(
                  'please Add Task!',
                  style: TextStyle(color: Colors.grey,fontSize: 20.0),
                ),
              ],),
          ),
        );

      },

    );
  }
}
