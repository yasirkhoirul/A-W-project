import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/core/utils/validators.dart';
import 'package:a_and_w/core/widgets/button.dart';
import 'package:a_and_w/core/widgets/form_layout.dart';
import 'package:a_and_w/core/widgets/snackbar.dart';
import 'package:a_and_w/core/widgets/text_field.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  static final formKey = GlobalKey<FormState>();
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: LoginPage.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FormLayout(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/logoshop.png',
                      height: 150,
                      width: 150,
                    ),
                    Text(
                      "Welcome Back!",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    MyTextField(
                      label: "Email",
                      validator: Validators.email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    MyTextField.hide(
                      label: "Password",
                      validator: Validators.password,
                      controller: passwordController,
                    ),
                    Row(
                      children: [
                        const Text("Belum punya akun?"),
                        TextButton(
                          onPressed: () {
                            context.push(AppRouter.signup);
                          },
                          child: const Text("Sign Up"),
                        ),
                      ],
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
                    CustomSnackBar.showSuccess(context, 'Login berhasil');
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 10,
                      children: [
                        MyButton(
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (LoginPage.formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                OnLoginWithEmailEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                            }
                          },
                          text: "Login",
                        ),
                        MyButton(
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            context.read<AuthBloc>().add(OnLoginWithGoogleEvent());
                          },
                          icon: Icons.account_circle,
                          text: "Login with Google",
                        ),
                      ],
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
