class UserModel {
  final String userId;
  final String accessToken;
  final String refreshToken;

  UserModel({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"],
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
    );
  }
}