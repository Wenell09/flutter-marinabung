import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_marinabung/bloc/auth/auth_bloc.dart';
import 'package:flutter_marinabung/cubit/index_bottom_cubit.dart';
import 'package:flutter_marinabung/pages/completed_page.dart';
import 'package:flutter_marinabung/pages/login_page.dart';
import 'package:flutter_marinabung/pages/widgets/bottom_bar_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Future.microtask(() {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final displayName = user.userMetadata?["display_name"] ?? "";
    final email = user.email ?? "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 230,
                color: Colors.black,
              ),
              const SizedBox(height: 70),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CompletedPage(),
                        )),
                        leading: Icon(Icons.history),
                        title: Text(
                          "Tabungan Selesaiku",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: const Text(
                                  "Apakah kamu ingin keluar?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Tidak"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<IndexBottomCubit>()
                                          .changeIndex(0);
                                      context
                                          .read<AuthBloc>()
                                          .add(LogoutUser());
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text("Ya"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const ListTile(
                          leading: Icon(Icons.logout, color: Colors.red),
                          title: Text(
                            "Keluar",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      const Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Versi Aplikasi\n1.0.0",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.27 - 65,
            left: MediaQuery.of(context).size.width / 2 - 62.5,
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage:
                  NetworkImage("http://idoxaxo.sufydely.com/profile_pic.png"),
            ),
          ),
          const BottomBarWidget(),
        ],
      ),
    );
  }
}
