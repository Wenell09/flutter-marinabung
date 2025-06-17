import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_marinabung/models/saving_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SavingRepository {
  final supabase = Supabase.instance.client;

  Future<void> addSaving(Map<String, dynamic> data) async {
    try {
      await dotenv.load(fileName: ".env");
      String photoUrl = "";
      if (data["file_path"] != "" && data["file"] != "") {
        await supabase.storage.from('images').upload(
              data["file_path"],
              data["file"],
              fileOptions: const FileOptions(upsert: false),
            );
        photoUrl = "${dotenv.env["SUPABASE_IMAGE_URL"]}/${data["file_path"]}";
      }
      await supabase.from("savings").insert({
        "saving_id": Uuid().v4(),
        "user_id": data["user_id"],
        "name": data["name"],
        "target": data["target"],
        "nominal": data["nominal"],
        "collected": 0,
        "remaining": data["target"],
        "estimation": data["target"] / data["nominal"],
        "created_at": DateTime.now().toIso8601String(),
        "photo": photoUrl,
        "estimation_day": data["estimation_day"]
      });
      debugPrint("Success add saving");
    } catch (e) {
      debugPrint("Error add saving: $e");
      throw Exception("Error add saving: $e");
    }
  }

  Future<List<SavingModel>> getSaving(String userId) async {
    try {
      final response =
          await supabase.from("savings").select("*").eq("user_id", userId);
      debugPrint("Success get saving:$response");
      return response.map((json) => SavingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<SavingModel>> getDetailSaving(
      String userId, String savingId) async {
    try {
      final response = await supabase
          .from("savings")
          .select("*")
          .eq("user_id", userId)
          .eq("saving_id", savingId);
      debugPrint("Success get detail saving:$response");
      return response.map((json) => SavingModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error get detail saving: $e");
      throw Exception(e.toString());
    }
  }

  Future<void> deleteSaving(String userId, String savingId) async {
    try {
      await supabase
          .from("savings")
          .delete()
          .eq("user_id", userId)
          .eq("saving_id", savingId);
      debugPrint("Success delete saving");
    } catch (e) {
      debugPrint("Error delete saving: $e");
      throw Exception(e.toString());
    }
  }
}
