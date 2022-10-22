import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheely_cool_app/customWidgets/pieChartWidget.dart';
import 'package:wheely_cool_app/models/items.dart';

class WheelScreen extends StatefulWidget {
  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  List<double> _angles;
  List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _colors = [
      Colors.red,
      Colors.cyan,
      Colors.black,
      Colors.yellow,
      Colors.grey
    ];
    _angles = [
      1 / 5,
      1 / 5,
      1 / 5,
      1 / 5,
      1 / 5,
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var pieChart = PieChartWidget(_angles, _colors,
        startTurns: .0,
        radius: screenWidth * 0.4,
        contents: Provider.of<ItemsModel>(context, listen: false).items);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: pieChart,
          ),
          Image.asset(
            "assets/left_arrow.png",
            height: screenWidth * 0.1,
            width: screenWidth * 0.1,
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          pieChart.spin();
        },
        child: const Text('Spin'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
