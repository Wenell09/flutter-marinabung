// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/saving/saving_bloc.dart';
import 'package:flutter_marinabung/pages/home_page.dart';
import 'package:flutter_marinabung/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 1),
      () {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          context.read<SavingBloc>().add(GetSaving(userId: user.id));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
        }
      },
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/marinabung.jpeg")),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
              ),
              Text(
                "Mari Nabung",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
