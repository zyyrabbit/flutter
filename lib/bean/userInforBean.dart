class UserInforBean {
  String username;
  int id;
  String avatarPic;
  String password;

  UserInforBean({
    this.avatarPic,
    this.id,
    this.username,
    this.password
  });

 UserInforBean.fromJson(Map<String, dynamic> json) {
    if (json['login'] == null) {
      username = json['id'];
    }
    username = json['login'];
    if (json['id'].runtimeType == int) {
      id = json['id'];
    } else {
      id = int.parse(json['id']);
    }
    avatarPic = json['avatar_url'];
  }

  Map<String, dynamic> toJson() => {'avatarPic': avatarPic, 'id': id, 'username': username, 'password': password};
}
