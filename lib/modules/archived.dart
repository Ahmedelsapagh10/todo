import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/component/components/component.dart';
import 'package:todoapp/component/shared/cubit/cubit.dart';
import 'package:todoapp/component/shared/cubit/states.dart';

class ArchivedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = appCubit.get(context).archiveTasks;
        return ScreenBuilderMe(tasks);
      },
    );
  }
}
