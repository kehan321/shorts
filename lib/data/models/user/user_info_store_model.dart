class UserInfoStoreModel {
  UserInfoStoreModel({
    required this.message,
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final String message;
  final User? user;
  final String accessToken;
  final String refreshToken;

  UserInfoStoreModel copyWith({
    String? message,
    User? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserInfoStoreModel(
      message: message ?? this.message,
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory UserInfoStoreModel.fromJson(Map<String, dynamic> json) {
    final nested = json["user"];
    final User? user = nested is Map
        ? User.fromJson(Map<String, dynamic>.from(nested))
        : User.maybeFromFlatAuthResponse(json);

    return UserInfoStoreModel(
      message: json["message"]?.toString() ?? "",
      user: user,
      accessToken: json["accessToken"]?.toString() ?? "",
      refreshToken: json["refreshToken"]?.toString() ?? "",
    );
  }
  factory UserInfoStoreModel.empty() {
    return UserInfoStoreModel(
      message: "",
      user: User.empty(),
      accessToken: "",
      refreshToken: "",
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "user": user?.toJson(),
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };

  @override
  String toString() {
    return "$message, $user, $accessToken, $refreshToken, ";
  }
}

class User {
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.role,
    required this.subscriptionStatus,
    required this.subscriptionPlan,
    required this.subscriptionEndDate,
  });

  final String id;
  final String email;
  final String name;
  final dynamic avatar;
  final String role;
  final String subscriptionStatus;
  final String subscriptionPlan;
  final DateTime? subscriptionEndDate;

  User copyWith({
    String? id,
    String? email,
    String? name,
    dynamic avatar,
    String? role,
    String? subscriptionStatus,
    String? subscriptionPlan,
    DateTime? subscriptionEndDate,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      avatar: json["avatar"] ?? json["image"],
      role: json["role"]?.toString() ?? "",
      subscriptionStatus: json["subscriptionStatus"]?.toString() ?? "",
      subscriptionPlan: json["subscriptionPlan"]?.toString() ?? "",
      subscriptionEndDate: DateTime.tryParse(
        json["subscriptionEndDate"]?.toString() ?? "",
      ),
    );
  }

  /// DummyJSON (and similar) put profile fields on the same object as tokens.
  static User? maybeFromFlatAuthResponse(Map<String, dynamic> json) {
    if (!json.containsKey('accessToken')) return null;
    if (!json.containsKey('email') && !json.containsKey('username')) {
      return null;
    }

    final first = json["firstName"]?.toString() ?? "";
    final last = json["lastName"]?.toString() ?? "";
    var displayName = '$first $last'.trim();
    if (displayName.isEmpty) {
      displayName =
          json["name"]?.toString() ?? json["username"]?.toString() ?? "";
    }

    return User(
      id: json["id"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      name: displayName,
      avatar: json["image"] ?? json["avatar"],
      role: json["role"]?.toString() ?? "",
      subscriptionStatus: json["subscriptionStatus"]?.toString() ?? "",
      subscriptionPlan: json["subscriptionPlan"]?.toString() ?? "",
      subscriptionEndDate: DateTime.tryParse(
        json["subscriptionEndDate"]?.toString() ?? "",
      ),
    );
  }
  factory User.empty() {
    return User(
      id: "",
      email: "",
      name: "",
      avatar: null,
      role: "",
      subscriptionStatus: "",
      subscriptionPlan: "",
      subscriptionEndDate: null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "avatar": avatar,
    "role": role,
    "subscriptionStatus": subscriptionStatus,
    "subscriptionPlan": subscriptionPlan,
    "subscriptionEndDate": subscriptionEndDate?.toIso8601String(),
  };

  @override
  String toString() {
    return "$id, $email, $name, $avatar, $role, $subscriptionStatus, $subscriptionPlan, $subscriptionEndDate, ";
  }
}

/*
{
	"message": "Registration successful",
	"user": {
		"id": "69a8124a506272e4f478803e",
		"email": "johsn@example.com",
		"name": "johsn",
		"avatar": null,
		"role": "user",
		"subscriptionStatus": "active",
		"subscriptionPlan": "monthly",
		"subscriptionEndDate": "2026-04-04T11:06:50.887Z"
	},
	"accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2OWE4MTI0YTUwNjI3MmU0ZjQ3ODgwM2UiLCJlbWFpbCI6ImpvaHNuQGV4YW1wbGUuY29tIiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NzI2MjI0MTEsImV4cCI6MTc3MjcwODgxMX0.gCgoPwNUIiUHYULoRv5b83KCERFT0Ez6Pny3JJVEvok",
	"refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2OWE4MTI0YTUwNjI3MmU0ZjQ3ODgwM2UiLCJlbWFpbCI6ImpvaHNuQGV4YW1wbGUuY29tIiwicm9sZSI6InVzZXIiLCJpYXQiOjE3NzI2MjI0MTEsImV4cCI6MTc3MzIyNzIxMX0.GUgdnwE71HHLvSqtEkmv_nwO01muELO6jPJpDlQmODw"
}*/
