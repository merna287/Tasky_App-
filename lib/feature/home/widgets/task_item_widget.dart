import 'package:flutter/material.dart';
import 'package:tasky_app/core/utils/app_assets.dart';
import 'package:tasky_app/feature/home/data/firebase/home_firebase.dart';
import 'package:tasky_app/feature/home/data/model/task_model.dart';
import 'package:tasky_app/feature/home/screens/detailed_task_screen.dart';
import 'package:tasky_app/feature/home/widgets/is_completed_radio_widget.dart';
class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({required this.taskItem,required this.onTaskDone, super.key});

  final TaskModel taskItem;
  final VoidCallback onTaskDone;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailedTaskScreen(taskItem: widget.taskItem),
          ),
        );
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff6E6A7C)),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(top: 10, bottom: 4),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                bool current = widget.taskItem.isDone ?? false;
                setState(() {
                  widget.taskItem.isDone = !current;
                });
                try {
                  await HomeFirebase.updateTask(widget.taskItem);
                  widget.onTaskDone();
                } catch (e) {
                  setState(() {
                    widget.taskItem.isDone = current;
                  });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update task")),
                  );
                }
              },
              child: IsCompletedRadioWidget(taskItem: widget.taskItem),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Text(
                  widget.taskItem.title.toString(),
                  style: TextStyle(
                    color: Color(0xff24252c),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _dateFormat(widget.taskItem.data ?? DateTime.now()),
                  style: TextStyle(
                    color: Color(0xff6E6A7C),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff5F33E1)),
              ),
              margin: const EdgeInsets.only(top: 12, right: 8),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Image.asset(AppAssets.flagImage),
                  Text(
                    widget.taskItem.priority.toString(),
                    style: TextStyle(
                      color: Color(0xff24252C),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateFormat(DateTime date) {
    final DateTime justDate = DateTime(date.year, date.month, date.day);
    final DateTime todayJustDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (justDate == todayJustDate) {
      return 'Today ${date.day}/${date.month}/${date.year}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  
}