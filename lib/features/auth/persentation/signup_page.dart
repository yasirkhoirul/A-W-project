import 'package:a_and_w/core/widget/text_field.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextField(label: "Email", validator: validator,),
        MyTextField(label: "Nama", validator: validator,),
        MyTextField(label: "No Hp", validator: validator,),
        MyTextField(label: "Provinsi", validator: validator,),
        MyTextField.hide(label: "Password", validator: validator,),
        MyTextField.hide(label: "Confirm Password", validator: validator,),
      ],
    );
  }
  String? validator(String? value) {
    if(value == null || value.isEmpty){
      return "Column tidak boleh kosong";
    }
    return null;
  }
}