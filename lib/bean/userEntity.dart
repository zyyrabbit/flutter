class UserEntity {
  var username;
  var password;
 
  UserEntity.fromMap(Map<String, dynamic> map){
    username = map['username'];
    password = map['password'];
  }
}