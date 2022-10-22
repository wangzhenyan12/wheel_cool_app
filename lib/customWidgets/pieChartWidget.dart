import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wheely_cool_app/utils/chartUtils.dart';

class PieChartWidget extends StatefulWidget {
  @required
  List<double> proportions;

  @required
  List<String> contents;

  @required
  List<Color> colors;

  double startTurns = .0;
  double radius = 130;

  var _pieChartWidgetState = _PieChartWidgetState();

  PieChartWidget(this.proportions, this.colors,
      {this.contents, this.radius, this.startTurns});

  void spin() {
    _pieChartWidgetState.spin();
  }

  @override
  _PieChartWidgetState createState() {
    return _pieChartWidgetState;
  }
}

class _PieChartWidgetState extends State<PieChartWidget>
    with TickerProviderStateMixin {
  AnimationController autoAnimationController;

  Animation<double> tween;

  double turns = .0;

  GlobalKey _key = GlobalKey();

  double vA = 40.0;

  Offset offset;

  double pBy;

  double pBx;

  double pAx;

  double pAy;

  double mCenterX;
  double mCenterY;

  Animation<double> _valueTween;

  double animalValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2 * widget.radius,
      height: 2 * widget.radius,
      child: GestureDetector(
        child: CustomPaint(
          painter: PieChartPainter(turns, widget.startTurns, widget.proportions,
              widget.colors, widget.contents, _key),
          key: _key,
        ),
        onPanEnd: _onPanEnd,
        onPanDown: _onPanDown,
        onPanUpdate: _onPanUpdate,
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    pBx = details.globalPosition.dx;
    pBy = details.globalPosition.dy;

    double dTurns = getTurns();

    setState(() {
      turns += dTurns;
    });

    pAx = pBx;
    pAy = pBy;
  }

  void _onPanDown(DragDownDetails details) {
    if (offset == null) {
      //获取position
      RenderBox box = _key.currentContext.findRenderObject();
      offset = box.localToGlobal(Offset.zero);
      mCenterX = offset.dx + 130;
      mCenterY = offset.dy + 130;
    }

    pAx = details.globalPosition.dx; //初始的点的 x坐标
    pAy = details.globalPosition.dy; //初始的点的 y坐标
  }

  double getTurns() {
    double acDistance = ChartUtils.distanceForTwoPoint(
        offset.dx + 2 * widget.radius, offset.dy + widget.radius, pAx, pAy);

    double aoDistance = ChartUtils.distanceForTwoPoint(
        offset.dx + widget.radius, offset.dy + widget.radius, pAx, pAy);

    double ocdistance = widget.radius;

    int c = 1;

    if (pAy < (offset.dy + widget.radius)) {
      c = -1;
    }

    double cosAOC = (aoDistance * aoDistance +
            ocdistance * ocdistance -
            acDistance * acDistance) /
        (2 * aoDistance * ocdistance);
    double AOC = c * acos(cosAOC);

    double bcDistance = ChartUtils.distanceForTwoPoint(
        offset.dx + 2 * widget.radius, offset.dy + widget.radius, pBx, pBy);

    double boDistance = ChartUtils.distanceForTwoPoint(
        offset.dx + widget.radius, offset.dy + widget.radius, pBx, pBy);

    c = 1;
    if (pBy < (offset.dy + widget.radius)) {
      c = -1;
    }

    double cosBOC = (boDistance * boDistance +
            ocdistance * ocdistance -
            bcDistance * bcDistance) /
        (2 * boDistance * ocdistance);
    double BOC = c * acos(cosBOC);

    return BOC - AOC;
  }

  void _onPanEnd(DragEndDetails details) {
    double vx = details.velocity.pixelsPerSecond.dx;
    double vy = details.velocity.pixelsPerSecond.dy;
    if (vx != 0 || vy != 0) {
      onFling(vx, vy);
    }
  }

  void onFling(double velocityX, double velocityY) {
    double levelAngle = ChartUtils.getPointAngle(mCenterX, mCenterY, pBx, pBy);
    int quadrant = ChartUtils.getQuadrant(pBx - mCenterX, pBy - mCenterY);
    double distance =
        ChartUtils.distanceForTwoPoint(mCenterX, mCenterY, pBx, pBy);
    double inertiaInitAngle = ChartUtils.calculateAngleFromVelocity(
        velocityX, velocityY, levelAngle, quadrant, distance);

    if (inertiaInitAngle != null && inertiaInitAngle != 0) {
      double t = ChartUtils.abs(inertiaInitAngle) / vA;
      double s = t * inertiaInitAngle / 2;

      animalValue = turns;
      var time = new DateTime.now();
      int direction = 1;

      if (inertiaInitAngle < 0) {
        direction = -1;
      }

      _startAnimation(inertiaInitAngle, t, direction);
    }
  }

  void _startAnimation(double inertiaInitAngle, double t, int direction) {
    var time = DateTime.now();
    autoAnimationController = AnimationController(
        duration: Duration(milliseconds: (t * 1000).toInt()), vsync: this)
      ..addListener(() {
        var animalTime = DateTime.now();
        int t1 =
            animalTime.millisecondsSinceEpoch - time.millisecondsSinceEpoch;
        setState(() {
          double s1 = (2 * inertiaInitAngle - direction * vA * (t1 / 1000)) *
              t1 /
              (2 * 1000);
          turns = animalValue + s1;
        });
      });

    autoAnimationController.forward();
  }

  void spin() {
    double inertiaInitAngle = ChartUtils.randomNumber(55, 300);
    debugPrint("$inertiaInitAngle");
    double t = ChartUtils.abs(inertiaInitAngle) / vA;
    animalValue = turns;
    int direction = 1;
    _startAnimation(inertiaInitAngle, t, direction);
  }

  @override
  void dispose() {
    super.dispose();
    if (autoAnimationController != null) {
      autoAnimationController.dispose();
    }
  }
}

class PieChartPainter extends CustomPainter {
  GlobalKey _key = GlobalKey();

  double turns = .0;
  double startTurns = .0;

  List<String> contents;

  PieChartPainter(this.turns, this.startTurns, this.angles, this.colors,
      this.contents, this._key);

  List<double> angles;

  List<Color> colors;

  double startAngles = 0;

  @override
  void paint(Canvas canvas, Size size) {
    drawAcr(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawAcr(Canvas canvas, Size size) {
    startAngles = 0;

    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (int i = 0; i < angles.length; i++) {
      paint..color = colors[i];
      canvas.drawArc(rect, 2 * pi * startAngles + turns + startTurns,
          2 * pi * angles[i], true, paint);
      startAngles += angles[i];
    }

    startAngles = 0;

    for (int i = 0; i < contents.length; i++) {
      canvas.save();

      ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.left,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        fontSize: 15.0,
      ));
      pb.pushStyle(ui.TextStyle(color: Colors.white));
      double roaAngle =
          2 * pi * (startAngles + angles[i] / 2) + turns + startTurns;

      pb.addText(contents[i]);
      ParagraphConstraints pc = ParagraphConstraints(width: 400);
      Paragraph paragraph = pb.build()..layout(pc);
      Offset offset = Offset(60, 0 - paragraph.height / 2);
      canvas.translate(size.width / 2, size.height / 2);

      canvas.rotate((1) * roaAngle);

      canvas.drawParagraph(paragraph, offset);

      canvas.restore();
      startAngles += angles[i];
    }
  }
}
