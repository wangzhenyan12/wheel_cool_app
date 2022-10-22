import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheely_cool_app/models/items.dart';

class WheelScreen extends StatefulWidget {
  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<ItemsModel>(
        builder: (context, itemsModel, child) {
          return Text('items number: ${itemsModel.items.length}');
        },
      ),
    );
  }
}
