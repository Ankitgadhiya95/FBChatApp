class UserModel {
  final String? name;
  final String? email;
  final String? password;
  final String? uid;
  final String? images;

  UserModel(
      {required this.name,
      required this.email,
      required this.password,
      required this.uid,
      required this.images});

  factory UserModel.fromJson(Map mapData) {
    return UserModel(
        name: mapData['name'],
        email: mapData['email'],
        password: mapData['password'],
        uid: mapData['uid'],
        images: mapData['image']);
  }
}

List<UserModel> userList = [];
