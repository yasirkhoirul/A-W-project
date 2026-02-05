import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String? Function(String?)? validator;
  final bool obscureText;
  final String label;
  final Widget? iconSuffix;
  final Widget? iconSuffixEffect;

  const MyTextField({
    super.key,
    this.validator,
    this.obscureText = false,
    required this.label,
    this.iconSuffix,
    this.iconSuffixEffect, 
  });
  const MyTextField.hide({
    super.key,
    this.validator,
    this.obscureText = true,
    required this.label,
    this.iconSuffix = const Icon(Icons.visibility),
    this.iconSuffixEffect = const Icon(Icons.visibility_off), 
    
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscured,
      validator: widget.validator,
      decoration: InputDecoration(
        suffix: (widget.iconSuffix != null || widget.iconSuffixEffect != null) ? InkWell(
          onTap: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
          child: _isObscured ? widget.iconSuffixEffect : widget.iconSuffix):null,
        border: OutlineInputBorder(),
        labelText: widget.label,
      ),
    );
  }
}
