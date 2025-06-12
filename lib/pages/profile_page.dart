import 'package:flutter/material.dart';
import 'package:flutter_marinabung/pages/widgets/bottom_bar_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
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
              const SizedBox(
                height: 70,
              ),
              Text(
                user!.userMetadata!["display_name"],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email!,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
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
                                  "Are you sure want to logout?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("YA"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("NO"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: ListTile(
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
                      Divider(),
                      Center(
                        child: const Text(
                          textAlign: TextAlign.center,
                          "Versi Aplikasi\n1.0.0",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.27 - 65,
            left: MediaQuery.of(context).size.width / 2 - 62.5,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage:
                  NetworkImage("http://idoxaxo.sufydely.com/profile_pic.png"),
            ),
          ),
          BottomBarWidget(),
        ],
      ),
    );
  }
}
