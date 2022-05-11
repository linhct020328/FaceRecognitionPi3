class Account{
  String userName;
  String password;

  Account(this.userName, this.password);

  Map<String, dynamic> toJson(){
    return {
      'username': this.userName,
      'password': this.password
    };
  }
}