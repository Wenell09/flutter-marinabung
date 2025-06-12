import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final supabase = Supabase.instance.client;

  Future<void> registerUser(Map<String, dynamic> data) async {
    try {
      final response = await supabase.auth.signUp(
        email: data["email"],
        password: data["password"],
        data: {"display_name": data["username"]},
      );
      if (response.user == null) {
        throw Exception("Error register user");
      } else {
        debugPrint("success register user ${response.user!.email}");
      }
    } on AuthApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginUser(Map<String, dynamic> data) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: data["email"],
        password: data["password"],
      );
      if (response.user == null) {
        throw Exception("Error register user");
      } else {
        debugPrint("welcome user ${response.user!.email}");
      }
    } on AuthApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    await supabase.auth.signOut();
  }
}
