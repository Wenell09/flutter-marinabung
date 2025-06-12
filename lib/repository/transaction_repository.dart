import 'package:flutter/material.dart';
import 'package:flutter_marinabung/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class TransactionRepository {
  final supabase = Supabase.instance.client;
  Future<void> addTransaction(Map<String, dynamic> data) async {
    try {
      await supabase.from("transaction").insert({
        "transaction_id": Uuid().v4(),
        "user_id": data["user_id"],
        "saving_id": data["saving_id"],
        "nominal": data["nominal"],
        "note": data["note"],
        "created_at": DateTime.now().toIso8601String(),
      });
      debugPrint("Success add transaction");
      final dataSaving = await supabase
          .from("savings")
          .select("*")
          .eq("user_id", data["user_id"])
          .eq("saving_id", data["saving_id"]);
      int collectedSum = dataSaving[0]["collected"] + data["nominal"];
      if (collectedSum >= dataSaving[0]["target"]) {
        await supabase
            .from("savings")
            .update({
              "collected": dataSaving[0]["target"],
              "remaining": 0,
              "estimation": 0,
              "completed_at": DateTime.now().toIso8601String(),
            })
            .eq("user_id", data["user_id"])
            .eq("saving_id", data["saving_id"]);
        debugPrint("Success update saving after add transaction");
      } else {
        await supabase
            .from("savings")
            .update({
              "collected": collectedSum,
              "remaining": dataSaving[0]["remaining"] - data["nominal"],
              "estimation": ((dataSaving[0]["target"] - collectedSum) /
                      dataSaving[0]["nominal"])
                  .floor(),
            })
            .eq("user_id", data["user_id"])
            .eq("saving_id", data["saving_id"]);
        debugPrint("Success update saving after add transaction");
      }
    } catch (e) {
      debugPrint("error add transaction:e");
      throw Exception("error add transaction:e");
    }
  }

  Future<List<TransactionModel>> getTransaction(
      String savingId, String userId) async {
    try {
      final response = await supabase
          .from("transaction")
          .select("*")
          .eq("user_id", userId)
          .eq("saving_id", savingId);
      debugPrint("Success get transaction:$response");
      return response.map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("error get transaction:$e");
      throw Exception(e.toString());
    }
  }
}
