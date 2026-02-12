import 'package:flutter/material.dart';

class RowDetailsWidget extends StatelessWidget {
  const RowDetailsWidget({
    required this.icon,
    required this.leftText,
    required this.rightText,
    super.key,
  });
  final String icon;
  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Image.asset(icon),
        Text(
          leftText,
          style: TextStyle(
            color: Color(0xff24252C),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xffD1CFDB),
          ),
          child: Text(
            rightText,
            style: TextStyle(
              color: Color(0xff24252C),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}