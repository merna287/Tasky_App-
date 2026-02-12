import 'package:flutter/material.dart';
import 'package:tasky_app/core/network/result_firebase.dart';
import 'package:tasky_app/core/utils/app_assets.dart';
import 'package:tasky_app/core/utils/app_dialog.dart';
import 'package:tasky_app/core/utils/validetor_app.dart';
import 'package:tasky_app/feature/home/data/firebase/home_firebase.dart';
import 'package:tasky_app/feature/home/data/model/task_model.dart';
import 'package:tasky_app/feature/home/widgets/alert_dialog_task_priority.dart';
import 'package:tasky_app/feature/home/widgets/text_form_field_widget.dart';

class BottomSheetAddTask extends StatefulWidget {
  const BottomSheetAddTask({super.key});

  @override
  State<BottomSheetAddTask> createState() => _BottomSheetAddTaskState();
}

class _BottomSheetAddTaskState extends State<BottomSheetAddTask> {
  late TextEditingController taskName;
  late TextEditingController taskDescription;
  late DateTime selectedDate = DateTime.now();
  late int priorityIndex = 5;
  @override
  void initState() {
    super.initState();
    taskName = TextEditingController();
    taskDescription = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "Add Task",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          TextFormFieldWidget(
            hint: "Do math homework",
            controller: taskName,
            myValidator: ValidatorApp.validateName,
          ),
          TextFormFieldWidget(
            hint: "Description",
            controller: taskDescription,
            myValidator: ValidatorApp.validateName,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _IconAddTask(
                imagePath: AppAssets.timerImage,
                onTap: () async {
                  selectedDate =
                      await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                        initialDate: DateTime.now(),
                      ) ??
                      DateTime.now();
                },
              ),
              SizedBox(width: 3),
              _IconAddTask(
                imagePath: AppAssets.flagImage,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialogCustomWidget(
                      getPriority: (index) {
                        priorityIndex = index;
                      },
                    ),
                  );
                },
              ),
              Spacer(),
              _IconAddTask(
                imagePath: AppAssets.sendImage,
                onTap: _addTaskToFirebase
              )
            ],
          ),
        ],
      ),
    );
  }
  void _addTaskToFirebase() async{
    AppDialog.showLoading(context);
    final task = TaskModel(
      title: taskName.text.trim(),
      description: taskDescription.text.trim(),
      data: selectedDate,
      priority: priorityIndex,
    );
    final result = await HomeFirebase.addUser(task);
    Navigator.of(context).pop();
    switch (result) {
      case Success<TaskModel>():
        Navigator.of(context).pop();
      case ErrorState<TaskModel>():
        AppDialog.showError(
          context: context,
          message: result.error,
        );
    }
  }
}

class _IconAddTask extends StatelessWidget {
  _IconAddTask({required this.imagePath, required this.onTap});
  String imagePath;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(imagePath, height: 24, width: 24, fit: BoxFit.contain),
    );
  }
}
