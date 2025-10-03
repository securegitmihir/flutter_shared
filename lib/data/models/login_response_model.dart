class LoginResponseModel {
  final bool? verified;
  final bool? isNewUser;

  LoginResponseModel({this.verified, this.isNewUser});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      verified: json['verified'],
      isNewUser: json['isNewUser'] ?? true
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verified': verified,
      'isNewUser': isNewUser,
    };
  }

}