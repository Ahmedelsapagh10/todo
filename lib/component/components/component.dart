import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/component/shared/cubit/cubit.dart';

Widget defaultTExtField({
  @required TextEditingController controller,
  @required TextInputType keyborardtype,
  @required String labletext,
  @required IconData prefix,
}) {
  TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Email..!';
        }
        return null;
      },
      controller: controller,
      keyboardType: keyborardtype,
      decoration: InputDecoration(
        labelText: labletext,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(),
      ));
  return null;
}

Widget buildTaskItem(Map model, context) => Dismissible(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                child: Text('${model['TIME']}'),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${model['TITLE']}',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text(
                      '${model['DATE']}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                  icon: Icon(Icons.check_box),
                  color: Colors.green,
                  onPressed: () {
                    appCubit.get(context).updateDataBase(
                          STATUS: 'done',
                          ID: model['ID'],
                        );
                  }),
              IconButton(
                  icon: Icon(Icons.archive),
                  color: Colors.black45,
                  onPressed: () {
                    appCubit
                        .get(context)
                        .updateDataBase(STATUS: 'archive', ID: model['ID']);
                  })
            ],
          ),
        ),
      ),
      key: Key(model['ID'].toString()),
      onDismissed: (direction) {
        appCubit.get(context).DeleteDataBase(
              ID: model['ID'],
            );
      },
    );
Widget ScreenBuilderMe(@required List<Map> tasks) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
        itemCount: tasks.length),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 50,
            color: Colors.white10,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Please Enter New Task!',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white10,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\u{1F609}',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white10,
            ),
          ),
        ],
      ),
    ),
  );
}
