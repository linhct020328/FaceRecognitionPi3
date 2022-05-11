import 'package:smarthome/model/acccount.dart';
import 'package:smarthome/model/token.dart';
import 'package:smarthome/provider/remote/authentication_provider.dart';

abstract class AuthenticationRepo {
  Future<Token> login(Account account);
}

class AuthenticationRepoImpl implements AuthenticationRepo {
  final AuthenticationProvider authenticationProvider;

  AuthenticationRepoImpl(this.authenticationProvider);

  @override
  Future<Token> login(Account account) => authenticationProvider.login(account);
}
