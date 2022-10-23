import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheely_cool_app/models/items.dart';

class SetupScreen extends StatefulWidget {
  @override
  State<SetupScreen> createState() => _SetupWidgetState();
}

class _SetupWidgetState extends State<SetupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _textEditingControllersList = List<TextEditingController>();
  var _textFormFieldsList = List<Widget>();
  var _stringIdList = List<String>();
  static const int _itemsNumber = 5;

  @override
  void initState() {
    super.initState();
    for (var i = 1; i <= _itemsNumber; i++) {
      _stringIdList.add(i.toString());
      TextEditingController controller = TextEditingController();
      _getStringValuesSF(i.toString()).then((value) => controller.text = value);
      _textEditingControllersList.add(controller);
      _textFormFieldsList.add(
        Container(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter option",
              ),
              validator: (String value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            )),
      );
    }
  }

  Future<String> _getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  _setStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  @override
  void dispose() {
    for (var i = 0; i < _itemsNumber; i++) {
      _textEditingControllersList[i].dispose();
    }
    _textEditingControllersList.clear();
    _textFormFieldsList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Wheely Cool App',
            style: Theme.of(context).textTheme.headline1),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: _textFormFieldsList,
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.pushNamed(context, '/wheel');
            Provider.of<ItemsModel>(context, listen: false).removeAll();
            for (int i = 1; i <= _itemsNumber; i++) {
              String strOption = _textEditingControllersList[i - 1].text;
              Provider.of<ItemsModel>(context, listen: false).add(strOption);
              _setStringToSF(i.toString(), strOption);
            }
          }
        },
        child: const Text('Done'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
