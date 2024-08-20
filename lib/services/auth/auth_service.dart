import '../../models/user/user_model.dart';
import 'package:hive/hive.dart';

class AuthService {
  Box<UserModel> userBox = Hive.box<UserModel>('userBox');

  Future<void> signIn(String email, String password) async {
    // Normally, you would authenticate with a backend server.
    // Simulate a successful login and store the user data locally.

    final user = UserModel(
      id: '123',
      name: 'John Doe',
      email: email,
      passwordHash: 'hashed_password',
    );

    // Save user data locally
    await userBox.put('currentUser', user);
  }

  UserModel? getCurrentUser() {
    return userBox.get('currentUser');
  }

  Future<void> signOut() async {
    await userBox.delete('currentUser');
  }

  Future<void> signUp(String name, String email, String password) async {
    // Normally, you would send this data to a backend server.
    // Simulate a successful signup and store the user data locally.

    final user = UserModel(
      id: '124',
      name: name,
      email: email,
      passwordHash: 'hashed_password',
    );

    // Save user data locally
    await userBox.put('currentUser', user);
  }
}
