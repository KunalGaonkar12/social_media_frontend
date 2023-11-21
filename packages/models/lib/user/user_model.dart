class User {
  late String id;
  late String fullName;
  late String userName;
  late String email;
  List<String>? followers;
  late bool didQueryMatch;
  late bool isFollowed;

  User(
      {required this.id,
      required this.fullName,
      required this.userName,
      required this.email,
      this.followers,
      this.didQueryMatch = true,
      this.isFollowed = false});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    fullName = json["fullName"];
    userName = json["userName"];
    didQueryMatch = true;
    isFollowed = false;
    email = json["email"];
    followers =
        json["followers"] == null ? null : List<String>.from(json["followers"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["fullName"] = fullName;
    _data["userName"] = userName;
    _data["email"] = email;
    if (followers != null) {
      _data["followers"] = followers;
    }
    return _data;
  }
}
