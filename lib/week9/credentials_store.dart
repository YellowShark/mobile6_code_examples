import 'package:shared_preferences/shared_preferences.dart';

class CredentialsStore {
  late SharedPreferences _prefs;

  CredentialsStore() {
    _initPrefs();
  }

  Future rememberMe() async {
    await _prefs.setBool('remember', true);
  }

  bool wasRemembered() {
    return _prefs.getBool('remember') ?? false;
  }

  Future forgetRemembered() async {
    return await _prefs.remove('remember');
  }

  String getCurrentLogin() {
   return _prefs.getString('login') ?? '';
  }

  Future<bool> signUp(String login, String password) async {
    final savedLogin = _prefs.getString('login');
    if (login == savedLogin) return false;
    await _prefs.setString('login', login);
    await _prefs.setString('password', password);
    return true;
  }

  LoginResult login(String login, String password) {
    final savedLogin = _prefs.getString('login');
    final savedPassword = _prefs.getString('password');

    if (savedLogin != login) {
      return LoginResult.wrongLogin;
    }

    if (savedPassword != password) {
      return LoginResult.wrongPassword;
    }

    return LoginResult.success;
  }

  Future _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
}

enum LoginResult {
  wrongLogin('Такого пользователя нет!'),
  wrongPassword('Неверный пароль!'),
  success('Успешная авторизация!'),
  ;

  final String message;

  const LoginResult(this.message);
}
