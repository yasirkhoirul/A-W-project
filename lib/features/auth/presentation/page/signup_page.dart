import 'package:a_and_w/core/utils/validators.dart';
import 'package:a_and_w/core/widgets/button.dart';
import 'package:a_and_w/core/widgets/form_layout.dart';
import 'package:a_and_w/core/widgets/snackbar.dart';
import 'package:a_and_w/core/widgets/text_field.dart';
import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  static final formKey = GlobalKey<FormState>();
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final noHpController = TextEditingController();
  final provinsiController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    namaController.dispose();
    noHpController.dispose();
    provinsiController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Form(
        key: SignupPage.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FormLayout(
                  children: [
                    Image.asset('assets/images/logoshop.png',
                      height: 150,
                      width: 150,
                    ),
                    Text(
                      "Create an Account",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    MyTextField(
                      label: "Email",
                      validator: Validators.email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    MyTextField(
                      label: "Nama",
                      validator: (value) =>
                          Validators.required(value, fieldName: "Nama"),
                      controller: namaController,
                    ),
                    MyTextField.hide(
                      label: "Password",
                      validator: Validators.password,
                      controller: passwordController,
                    ),
                    MyTextField.hide(
                      label: "Confirm Password",
                      validator: (value) => Validators.confirmPassword(
                        value,
                        passwordController.text,
                      ),
                      controller: confirmPasswordController,
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    CustomSnackBar.showError(context, state.message);
                  }
                  if (state is AuthSuccess) {
                    CustomSnackBar.showSuccess(context, 'Sign Up berhasil');
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () {
                        if (SignupPage.formKey.currentState!.validate()) {
                          final UserEntities user = UserEntities(
                            emailController.text,
                            passwordController.text,
                            namaController.text,
                          );
                          context.read<AuthBloc>().add(OnSignUpEvent(user));
                        }
                      },
                      text: "Sign Up",
                      isLoading: state is AuthLoading,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
