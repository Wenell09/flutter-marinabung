class UserModel {
  final String userId;
  final String username;
  final String email;
  final String password;
  final String profilePicture;
  final String createdAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.profilePicture,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      profilePicture: json["profile_picture"] ?? "",
      createdAt: json["created_at"] ?? "",
    );
  }
}
