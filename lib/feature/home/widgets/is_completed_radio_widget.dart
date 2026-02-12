import 'package:flutter/material.dart';
import 'package:tasky_app/feature/home/data/model/task_model.dart';

class IsCompletedRadioWidget extends StatelessWidget {
  const IsCompletedRadioWidget({
    required this.taskItem,
    super.key,
  });
  final TaskModel taskItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Color(0xff5F33E1)),
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffffffff),
      ),
      width: 20,
      height: 20,
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: BoxBorder.all(color: Color(0xffffffff)),
          borderRadius: BorderRadius.circular(20),
          color: (taskItem.isDone?? false)
              ? Color(0xff5F33E1)
              : Color(0xffffffff),
        ),
      ),
    );
  }
}