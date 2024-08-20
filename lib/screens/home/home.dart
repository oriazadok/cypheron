import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';
import '../chat/chat.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user?.name}'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: () {
        //       _authService.signOut();
        //       Navigator.pushReplacementNamed(context, '/welcome');
        //     },
        //   ),
        // ],
      ),
      body: ListView(
        children: [
          // Dummy contacts for now
          ListTile(
            title: Text('Contact 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chat(contactName: 'Contact 1')),
              );
            },
          ),
          ListTile(
            title: Text('Contact 2'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chat(contactName: 'Contact 2')),
              );
            },
          ),
        ],
      ),
    );
  }
}
