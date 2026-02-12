import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/network/result_firebase.dart';
import 'package:tasky_app/core/utils/app_assets.dart';
import 'package:tasky_app/core/utils/app_dialog.dart';
import 'package:tasky_app/core/utils/validetor_app.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:tasky_app/feature/auth/screen/login_screem.dart';
import 'package:tasky_app/feature/home/data/firebase/home_firebase.dart';
import 'package:tasky_app/feature/home/data/model/task_model.dart';
import 'package:tasky_app/feature/home/widgets/bottom_sheet_add_task.dart';
import 'package:tasky_app/feature/home/widgets/empty_home_screen.dart';
import 'package:tasky_app/feature/home/widgets/task_item_widget.dart';
import 'package:tasky_app/feature/home/widgets/text_form_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchField = TextEditingController();
  List<TaskModel> tasks = [];
  List<TaskModel> completedTasksList = [];
  DateTime _selectedDate = DateTime.now();
  bool isLoading = true;

  void getCompletedTasks(DateTime date) async {
    isLoading = true;
    final result = await HomeFirebase.getCompletedTasks(date);
    switch (result) {
      case Success<List<TaskModel>>():
        completedTasksList = result.value;
        break;
      case ErrorState<List<TaskModel>>():
        AppDialog.showError(context: context, message: result.error);
        break;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllTasks(_selectedDate);
    getCompletedTasks(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(AppAssets.taskyImage),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: Row(
              children: [
                SvgPicture.asset(AppAssets.logoutImage),
                Text(
                  ' Log out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffFF4949),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormFieldWidget(
                    hint: 'Search for your task...',
                    widthBorder: 2,
                    controller: searchField,
                    myValidator: ValidatorApp.validateName,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AppAssets.searchImage,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            DatePicker(
              DateTime.now(),
              daysCount: 30,
              height: 90,
              initialSelectedDate: DateTime.now(),
              selectionColor: Color.fromARGB(255, 138, 125, 163),
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                  getAllTasks(date);
                });
                getCompletedTasks(date);
              },
            ),
            SizedBox(height: 10),
            Flexible(
              flex: 2,
              child: isLoading ? _LoadingStateUI() : _ListOfTasksState(),
            ),
            SizedBox(height: 10),
            Flexible(flex: 1,child: comletedTasksState()),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton(
            onPressed: () async  {
              await showModalBottomSheet(
                context: context,
                builder: (context) => BottomSheetAddTask(),
              );
              getAllTasks(_selectedDate);
              getCompletedTasks(_selectedDate);
            },
            shape: CircleBorder(),
            backgroundColor: const Color(0xff24252C),
            child: const Icon(Icons.add, color: Color(0xff5F33E1)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _LoadingStateUI() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _ListOfTasksState() {
    tasks.sort((a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));
    return tasks.isEmpty
        ? EmptyHomeScreen()
        : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemBuilder: (context, index) =>
                TaskItemWidget(taskItem: tasks[index], onTaskDone: () {getAllTasks(_selectedDate);
                  getCompletedTasks(_selectedDate); },),
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemCount: tasks.length,
          );
  }

  Widget comletedTasksState() {
    return completedTasksList.isEmpty
        ? SizedBox()
        : Column(
            children: [
              Divider(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff6E6A7C)),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  "Completed",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: .w400,
                    color: Color(0xff24252C),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemBuilder: (context, index) =>
                      TaskItemWidget(taskItem: completedTasksList[index], onTaskDone: () {getAllTasks(_selectedDate);
                        getCompletedTasks(_selectedDate);  },),
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: completedTasksList.length,
                ),
              ),
            ],
          );
  }

  void getAllTasks(DateTime? date) async {
    isLoading = true;
    setState(() {});
    final selectedDate = DateTime(date!.year, date.month, date.day);
    final result = await HomeFirebase.getTasks(selectedDate);
    switch (result) {
      case Success<List<TaskModel>>():
        tasks = result.value;
        tasks.sort((a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0));
      case ErrorState<List<TaskModel>>():
        AppDialog.showError(context: context, message: result.error);
    }
    isLoading = false;
    setState(() {});
  }
  
}
