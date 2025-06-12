import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final supabase = Supabase.instance.client;

  Future<void> updateUser(Map<String, dynamic> data) async {
    try {
      final response = await supabase.auth.updateUser(UserAttributes(
        email: data["email"],
        password: data["password"],
        data: {"display_name": data["username"]},
      ));
      if (response.user == null) {
        debugPrint('Update error user');
      } else {
        debugPrint('Update success: User ID ${response.user!.id}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
