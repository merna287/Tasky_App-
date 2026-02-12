import 'package:flutter/material.dart';
import 'package:tasky_app/core/utils/app_assets.dart';

class AlertDialogCustomWidget extends StatefulWidget {
  const AlertDialogCustomWidget({super.key, required this.getPriority});
  final void Function(int) getPriority;

  @override
  State<AlertDialogCustomWidget> createState() =>
      _AlertDialogCustomWidgetState();
}

class _AlertDialogCustomWidgetState extends State<AlertDialogCustomWidget> {
  List<int> priorityList = List.generate(10, (index) => index + 1);
  int selectedIndex = 5;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffffffff),
      title: Column(
        spacing: 10,
        children: [
          Text(
            'Task Priority',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xff24252C),
            ),
          ),
          Divider(),
          Wrap(
            children: priorityList
                .map(
                  (index) => _PriorityItemWidget(
                    index: index,
                    isSelected: selectedIndex == index,
                    onTap: () {
                      selectedIndex = index;
                      widget.getPriority(index);
                      setState(() {});
                    },
                  ),
                )
                .toList(),
          ),
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Color(0xffffffff),
                  elevation: 0,
                  height: 45,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xff5F33E1),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Color(0xff5F33E1),
                  elevation: 0,
                  height: 45,

                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityItemWidget extends StatelessWidget {
  const _PriorityItemWidget({
    required this.index,
    required this.isSelected,
    this.onTap,
  });
  final void Function()? onTap;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: isSelected ? Border.all(color: Color(0xff5F33E1)) : Border.all(color: Color(0xff6E6A7C)),
          color: isSelected ? Color(0xff5F33E1) : Color(0xffffffff),
        ),

        padding: EdgeInsets.symmetric(horizontal: 19, vertical: 7),
        margin: EdgeInsets.only(left: 6, bottom: 12),
        child: Column(
          children: [
            Image.asset(
              AppAssets.flagImage,
              color: isSelected ? Color(0xffffffff) : null,
            ),
            Text(
              index.toString(),
              style: TextStyle(
                color: isSelected ? Color(0xffffffff) : Color(0xff24252C),
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}