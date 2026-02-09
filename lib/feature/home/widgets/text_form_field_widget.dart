import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.myValidator,
    this.keybroardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
  });

  final String label;
  final TextInputType keybroardType;
  final bool obscureText;
  final bool isPassword;
  final TextEditingController controller;
  final Validator myValidator;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late bool _isHidden;

  @override
  void initState() {
    super.initState();
    _isHidden = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff9D909E),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keybroardType,
          obscureText: widget.isPassword && _isHidden,
          validator: widget.myValidator,
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff7F7F7F),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isHidden = !_isHidden;
                      });
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xffDCDCDC),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xff5F33E1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
