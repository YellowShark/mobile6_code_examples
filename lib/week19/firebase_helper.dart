import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseHelper {
  static Future<bool> login(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      // Код ошибка для случая, если пользователь не найден
      if (e.code == 'user-not-found') {
        print("Unknown user");
        // Код ошибка для случая, если пользователь ввёл неверный пароль
      } else if (e.code == 'wrong-password') {
        print("Wrong password");
      }
    } catch(e) {
      print("Unknown error");
    }
    return false;
  }

  static Future<bool> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('Invalid email address.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static String? getEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  static Future<void> completeSubscription(bool value) async {
    // Берём id пользователя, чтобы у каждого пользователя была своя ветка
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return;
    // Берём ссылку на корень дерева с записями для текущего пользователя
    final ref = FirebaseDatabase.instance.ref("subscriptions/$id/enable");
    // Сначала генерируем новую ветку с помощью push() и потом в эту же ветку
    // добавляем запись
    await ref.set(value);
  }

  static Stream<DatabaseEvent> subscriptionState() {
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) return const Stream.empty();
    final ref = FirebaseDatabase.instance.ref("subscriptions/$id/enable");
    return ref.onValue;
  }
}