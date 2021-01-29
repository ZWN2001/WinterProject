class User{
  String _account;
  String _password;

  User(this._account,
      this._password);

  get account => _account;
  get password => _password;

  @override
  String toString() {
    return "|$_account $_password|";
  }

  @override
  bool operator ==(other) {
    return (_account == other._username) && (_password == other._password);
  }
}