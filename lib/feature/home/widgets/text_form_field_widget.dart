import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    this.label,
    required this.controller,
    required this.myValidator,
    this.keybroardType = TextInputType.text,
    this.hint,
    this.obscureText = false,
    this.isPassword = false,
    this.widthBorder = 1.0,
    this.prefixIcon,
  });

  final String? label;
  final String? hint;
  final TextInputType keybroardType;
  final bool obscureText;
  final bool isPassword;
  final TextEditingController controller;
  final Validator myValidator;
  final double widthBorder ;
  final Widget? prefixIcon;

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
          widget.label ?? "",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff928F9D),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keybroardType,
          obscureText: widget.isPassword && _isHidden,
          validator: widget.myValidator,
          decoration: InputDecoration(
            hintText: widget.hint ?? widget.label,
            hintStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xff928F9D),
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isHidden ? Icons.visibility_off : Icons.visibility,
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xffBEBEBE),
                width: widget.widthBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff5F33E1)),
            ),
          ),
        ),
      ],
    );
  }
}
