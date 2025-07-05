class UserModel{
  
  final String uid;
  final String name;
  final String email;
  final String userType;

  UserModel({required this.uid, required this.name, required this.email, required this.userType});

  factory UserModel.fromjson( Map<String,dynamic> json){
     return UserModel(
      uid: json['uid'] ?? '', 
      name: json['name'] ?? '', 
      email: json['email'] ?? '', 
      userType: json['userType'] ?? '');

  }

  Map<String ,dynamic> tojson(){
     return {
      'uid': uid, 
      'name': name,
      'email': email, 
      'userType': userType};
  }
}