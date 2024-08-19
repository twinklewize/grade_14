import 'package:ffi_package/ffi_package.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Duktape duktape;
  String output = '';

  @override
  void initState() {
    super.initState();
    duktape = Duktape();
    output = 'Duktape initialized';
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: Center(
          child: Text(output, style: textStyle),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            const jsCode = '2 * 2';
            duktape.evalString(jsCode);
            final result = duktape.getInt(-1);
            setState(() {
              output = '$jsCode = $result';
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
