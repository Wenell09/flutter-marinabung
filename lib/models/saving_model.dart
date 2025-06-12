class SavingModel {
  final String savingId;
  final String userId;
  final String name;
  final int target;
  final int nominal;
  final int collected;
  final int remaining;
  final int estimation;
  final String createdAt;
  final String completedAt;
  final String photo;
  final String estimationDay;

  SavingModel({
    required this.savingId,
    required this.userId,
    required this.name,
    required this.target,
    required this.nominal,
    required this.collected,
    required this.remaining,
    required this.estimation,
    required this.createdAt,
    required this.completedAt,
    required this.photo,
    required this.estimationDay,
  });

  factory SavingModel.fromJson(Map<String, dynamic> json) {
    return SavingModel(
      savingId: json["saving_id"] ?? "",
      userId: json["user_id"] ?? "",
      name: json["name"] ?? "",
      target: json["target"] ?? 0,
      nominal: json["nominal"] ?? 0,
      collected: json["collected"] ?? 0,
      remaining: json["remaining"] ?? 0,
      estimation: json["estimation"] ?? 0,
      createdAt: json["created_at"] ?? "",
      completedAt: json["completed_at"] ?? "",
      photo: json["photo"] ?? "",
      estimationDay: json["estimation_day"] ?? "",
    );
  }
}
