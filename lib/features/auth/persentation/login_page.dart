import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/core/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget{
  
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          MyTextField(
            label: "Email",
            validator: validator,
          ),
          MyTextField.hide(
            label: "Password",
            validator: validator,
          ),
          Row(
            children: [
              Text("Belum punya akun?"),
              TextButton(onPressed: () {
                context.go(AppRouter.signup);
              }, child: Text("Sign Up"))
            ],
          )
        ],
      ),
    );
  }

  String? validator(String? value) {
    if(value == null || value.isEmpty){
      return "Column tidak boleh kosong";
    }
    return null;
  }
}