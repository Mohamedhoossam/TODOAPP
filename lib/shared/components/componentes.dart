import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget DefultButton({
  Color background = Colors.blue,
  double width = double.infinity,
  required String text,
  required VoidCallback function,
  double radius = 0.0,
  bool isUpperCase = true,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
              fontSize: 25.0, fontStyle: FontStyle.normal, color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

Widget DefultTextFormFiled({
  double radius = 10.0,
  IconData? prefix,
  IconData? suffix,
  String? labelText,
  hintText,
  FormFieldValidator<String>? validate,
  TextInputType? type,
  TextEditingController? control,
  VoidCallback? onpress,
  Color labelColor = Colors.grey,
  double labelFontSize = 15,
  String? labelFontFamily,
  FontWeight? fontweight,
  bool scure = false,
  bool lockKeyboard = false,
  GestureTapCallback? ontap,
}) =>
    TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(onPressed: onpress, icon: Icon(suffix))
            : null,
        labelText: labelText,
        labelStyle: TextStyle(
            color: labelColor,
            fontSize: labelFontSize,
            fontFamily: labelFontFamily),
        hintText: hintText,
        hintStyle: TextStyle(
            color: labelColor,
            fontSize: labelFontSize,
            fontFamily: labelFontFamily,
            fontWeight: fontweight),
      ),
      keyboardType: type,
      controller: control,
      validator: validate,
      obscureText: scure,
      style: TextStyle(color: Colors.black),
      readOnly: lockKeyboard,
      onTap: ontap,
    );

Widget ScreenItem(Map model,context) =>
    Slidable(

      actionPane:SlidableScrollActionPane(),
      actionExtentRatio: .25,
      key: Key(model['id'].toString()),

      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.secondary: 1.0
        },
        onDismissed: (actionType) {
          AppCubit.get(context).deleteDatabase(id: model['id']);
        },
      ),

      actions: [

       IconSlideAction(
         caption: 'Delete',
         color: Colors.red,
         icon: Icons.delete,
         onTap: (){
           AppCubit.get(context).deleteDatabase(id: model['id']);
         },
       ),
      ],
      secondaryActions: [
        model['status']=='archive'?
        IconSlideAction(
          caption: 'Done',
          color: Colors.green,
          icon: Icons.check_box,
          onTap: (){
            AppCubit.get(context).updateDatabase(id: model['id'], status: 'done');
          },
        ):
        IconSlideAction(
          caption: 'Archive',
          color: Colors.indigo,
          icon: Icons.archive,
          onTap: (){
            AppCubit.get(context).updateDatabase(id: model['id'], status: 'archive');
          },
        ),


        model['status']=='done'||model['status']=='archive'?
        IconSlideAction(
          caption: 'Tasks',
          color: Colors.limeAccent,
          icon: Icons.menu,
          onTap: (){
            AppCubit.get(context).updateDatabase(id: model['id'], status: 'new');
          },
        ) :
        IconSlideAction(
          caption: 'Done',
          color: Colors.green,
          icon: Icons.check_box,
          onTap: (){
            AppCubit.get(context).updateDatabase(id: model['id'], status: 'done');
          },
        ),

      ],
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0),

          ),
          color: Colors.grey,
        ),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'DateLine : ',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      '${model['date']}',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      width:20.0,
                    ),
                    Text('${model['time']}',style: TextStyle(color: Colors.white),),



                  ],
                ),
                SizedBox(height: 12.0,),
                Text(
                  '${model['title']}',maxLines: 10,overflow:TextOverflow.visible ,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white

                  ),
                ),

              ],
            ),

        ),
      ),
    );


