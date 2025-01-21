import 'package:flutter/material.dart';

class CurrentItemScreen extends StatefulWidget {
  const CurrentItemScreen({Key? key}) : super(key: key);

  @override
  _CurrentItemScreenState createState() => _CurrentItemScreenState();
}

class _CurrentItemScreenState extends State<CurrentItemScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Current Item'),
      ),
      body: const Center(
        child: Text('This is the current item screen'),
      ),
    );
  }
}
