import 'package:flutter/material.dart';
import 'cypher_ffi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FFI Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String cypherResult = '';
  final CypherFFI cypherFFI = CypherFFI();

  void _runCypher() {
    setState(() {
      cypherResult = cypherFFI.runCypher('Hello, World!', 'mySecretKey', 'e'); // 'e' for encrypt
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter FFI Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Cypher Result:'),
            Text(
              cypherResult,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runCypher,
              child: Text('Run Cypher'),
            ),
          ],
        ),
      ),
    );
  }
}
