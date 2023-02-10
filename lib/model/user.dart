class UserAccount {
  final String firstName, lastName, email, password;
  final String? imageProfile, lastLogin;
  final bool isDisable;
  final bool? isLogin;

  UserAccount(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.imageProfile,
      required this.isLogin,
      required this.isDisable,
      required this.lastLogin});

  UserAccount.fromJson(Map<String, dynamic>? json)
      : this(
            email: json!['email'] as String,
            password: json['password'] as String,
            firstName: json['firstName'] as String,
            lastName: json['lastName'] as String,
            isDisable: json['isDisable'] as bool,
            isLogin: json['isLogin'] as bool?,
            imageProfile: json['imageProfile'] as String?,
            lastLogin: json['lastLogin'] as String?);

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'isDisable': isDisable,
      'imageProfile': imageProfile,
      'isLogin': isLogin,
      'lastLogin': lastLogin
    };
  }
}
