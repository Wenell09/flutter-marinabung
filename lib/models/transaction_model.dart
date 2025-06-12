class TransactionModel {
  final String transactionId;
  final String userId;
  final String savingId;
  final int nominal;
  final String note;
  final String createdAt;

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.savingId,
    required this.nominal,
    required this.note,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json["transaction_id"] ?? "",
      userId: json["user_id"] ?? "",
      savingId: json["saving_id"] ?? "",
      nominal: json["nominal"] ?? 0,
      note: json["note"] ?? "",
      createdAt: json["created_at"] ?? "",
    );
  }
}
