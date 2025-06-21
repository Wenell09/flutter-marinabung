import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/auth/auth_bloc.dart';
import 'package:flutter_marinabung/bloc/saving/saving_bloc.dart';
import 'package:flutter_marinabung/cubit/password_cubit.dart';
import 'package:flutter_marinabung/pages/home_page.dart';
import 'package:flutter_marinabung/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController inputEmail = TextEditingController();
    TextEditingController inputPassword = TextEditingController();
    return BlocProvider(
      create: (context) => PasswordCubit(),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 300,
              alignment: Alignment.center,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/marinabung.jpeg")),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 10),
                      Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      InputField(controller: inputEmail),
                      const SizedBox(height: 10),
                      Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      BlocBuilder<PasswordCubit, bool>(
                        builder: (context, state) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              obscureText: state,
                              controller: inputPassword,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () => context
                                      .read<PasswordCubit>()
                                      .showPassword(),
                                  icon: (state)
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthError) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  content: Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            );
                          } else if (state is AuthSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Welcome to MariNabung App")));
                            context
                                .read<SavingBloc>()
                                .add(GetSaving(userId: state.userId));
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ));
                          }
                        },
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return Container(
                                width: double.infinity,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () =>
                                  context.read<AuthBloc>().add(VerifAuth(
                                        type: "login",
                                        data: {
                                          "email": inputEmail.text,
                                          "password": inputPassword.text,
                                        },
                                      )),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: InkWell(
                          onTap: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          )),
                          child: Text(
                            "Belum punya akun? register disini!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  const InputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
