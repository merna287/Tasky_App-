import 'package:flutter/material.dart';
import 'package:tasky_app/core/utils/app_assets.dart';
import 'package:tasky_app/feature/home/data/firebase/home_firebase.dart';
import 'package:tasky_app/feature/home/data/model/task_model.dart';
import 'package:tasky_app/feature/home/widgets/alert_dialog_task_priority.dart';
import 'package:tasky_app/feature/home/widgets/is_completed_radio_widget.dart';
import 'package:tasky_app/feature/home/widgets/row_details_widget.dart';

class DetailedTaskScreen extends StatefulWidget {
  const DetailedTaskScreen({required this.taskItem, super.key});
  final TaskModel taskItem;

  @override
  State<DetailedTaskScreen> createState() => _DetailedTaskScreenState();
}

class _DetailedTaskScreenState extends State<DetailedTaskScreen> {
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  late int priorityIndex;

  @override
  void initState() {
    super.initState();
    descriptionController =
      TextEditingController(text: widget.taskItem.description ?? "");
    selectedDate = widget.taskItem.data ?? DateTime.now();
    priorityIndex = widget.taskItem.priority ?? 5;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xffD1CFDB),
                ),
                child: Icon(Icons.close, color: Color(0xffFC0C0C), size: 24),
              ),
            ),
            SizedBox(height: 40),
            Row(
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: isCompletedTap,
                  child: IsCompletedRadioWidget(taskItem: widget.taskItem),
                ),
                Text(
                  widget.taskItem.title.toString(),
                  style: TextStyle(
                    color: Color(0xff24252C),
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            TextFormField(
              controller: descriptionController,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Color(0xff6E6A7C),
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 22),
            GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                  initialDate: selectedDate,
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate; 
                  });
                }
              },
              child: RowDetailsWidget(
                icon: AppAssets.timerImage,
                leftText: 'Task Time',
                rightText:
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
            ),
            SizedBox(height: 28),
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialogCustomWidget(
                    getPriority: (index) async {
                      priorityIndex = index;
                      setState(() {});
                    },
                  ),
                );
              },
              child: RowDetailsWidget(
                icon: AppAssets.flagImage,
                leftText: 'Task Priority',
                rightText: priorityIndex.toString(),
              ),
            ),
            SizedBox(height: 28),

            GestureDetector(
              onTap: () async {
                if (widget.taskItem.id != null) {
                  await HomeFirebase.deleteTask(widget.taskItem.id!);
                  Navigator.pop(context);
                }
              },
              child: Row(
                spacing: 5,
                children: [
                  Icon(Icons.delete_outline, color: Color(0xffFF4949)),
                  Text(
                    'Delete Task',
                    style: TextStyle(
                      color: Color(0xffFF4949),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            MaterialButton(
              onPressed: () async {
                widget.taskItem.description = descriptionController.text;
                widget.taskItem.data = selectedDate;
                widget.taskItem.priority = priorityIndex;
                await HomeFirebase.updateTask(widget.taskItem);
                Navigator.pop(context);
              },
              minWidth: double.infinity,
              height: 48,
              color: Color(0xff5F33E1),
              textColor: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Edit Task'),
            ),
          ],
        ),
      ),
    );
  }

  void isCompletedTap() async {
    widget.taskItem.isDone = !(widget.taskItem.isDone ?? false);

    await HomeFirebase.updateTask(widget.taskItem);
    setState(() {});
    
  }
}
