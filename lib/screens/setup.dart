import 'package:flutter/material.dart';

class SetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Wheely Cool App',
            style: Theme.of(context).textTheme.headline1),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Deliver features faster'),
            Text('Craft beautiful UIs'),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        child: const Text('Done'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
