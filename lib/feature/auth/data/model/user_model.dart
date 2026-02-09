class UserModel {
  static String collection = "Users";
  UserModel({this.id, this.userName, this.email, this.password});
  UserModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        userName: json['userName'],
        email: json['email'],
        password: json['password'],
      );
  String? id;
  String? userName;
  String? email;
  String? password;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
    };
  }
}
