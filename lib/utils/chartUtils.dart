import 'dart:math';

class ChartUtils {
  static double radianToAngle(double radian) {
    return radian * 180 / (pi);
  }

  static double angleToRadian(double angle) {
    return angle * pi / 180;
  }

  static double round(double v, int scale) {
    if (scale < 0) {
      throw "The scale must be a positive integer or zero";
    }

    return double.parse(v.toStringAsFixed(scale));
  }

  static int getQuadrant(double x, double y) {
    if (x >= 0) {
      return y >= 0 ? 4 : 1;
    }
    return y >= 0 ? 3 : 2;
  }

  static double distanceForTwoPoint(
      double x1, double y1, double x2, double y2) {
    double distanceX = x1 - x2;
    double distanceY = y1 - y2;
    return sqrt(pow(distanceX, 2) + pow(distanceY, 2));
  }

  static double getPointAngle(
      double centerX, double centerY, double x, double y) {
    double distance = distanceForTwoPoint(centerX, centerY, x, y);
    double radian = 0;
    if (x > centerX && y < centerY) {
      radian = pi * 2 - asin((centerY - y) / distance);
    } else if (x < centerX && y < centerY) {
      radian = pi + asin((centerY - y) / distance);
    } else if (x < centerX && y > centerY) {
      radian = pi - asin((y - centerY) / distance);
    } else if (x > centerX && y > centerY) {
      radian = asin((y - centerY) / distance);
    }
    return radianToAngle(radian);
  }

  static double calculateAngleFromVelocity(double velocityX, double velocityY,
      double levelAngle, int quadrant, double distance) {
    if (levelAngle > 270) {
      levelAngle = 360 - levelAngle;
    } else if (levelAngle > 90 && levelAngle < 180) {
      levelAngle = 180 - levelAngle;
    } else {
      levelAngle = levelAngle % 90;
    }

    double lineSpeed = (sqrt(pow(velocityX, 2) + pow(velocityY, 2)));
    double vectorAngle = radianToAngle(asin(abs(velocityY) / lineSpeed));
    if (vectorAngle == levelAngle) {
      return 0;
    }
    double circleLineAngle;
    bool isCW;
    if (quadrant == 4) {
      if (velocityX > 0 && velocityY < 0) {
        isCW = false;
        circleLineAngle = vectorAngle > levelAngle
            ? vectorAngle - levelAngle
            : 90 - vectorAngle - levelAngle;
      } else if (velocityX > 0 && velocityY > 0) {
        isCW = vectorAngle > levelAngle;
        circleLineAngle = vectorAngle > levelAngle
            ? 90 - vectorAngle + levelAngle
            : 90 + vectorAngle - levelAngle;
      } else if (velocityX < 0 && velocityY < 0) {
        isCW = vectorAngle < levelAngle;
        circleLineAngle = vectorAngle > levelAngle
            ? 90 - vectorAngle + levelAngle
            : 90 + vectorAngle - levelAngle;
      } else {
        isCW = true;
        circleLineAngle = vectorAngle > levelAngle
            ? vectorAngle + levelAngle - 90
            : 90 - vectorAngle - levelAngle;
      }
    } else if (quadrant == 3) {
      if (velocityX > 0 && velocityY < 0) {
        isCW = vectorAngle > levelAngle;
        circleLineAngle = vectorAngle > levelAngle
            ? 90 - vectorAngle + levelAngle
            : 90 + vectorAngle - levelAngle;
      } else if (velocityX > 0 && velocityY > 0) {
        isCW = false;
        circleLineAngle = vectorAngle > levelAngle
            ? vectorAngle - levelAngle
            : vectorAngle + levelAngle;
      } else if (velocityX < 0 && velocityY > 0) {
        isCW = vectorAngle < levelAngle;
        circleLineAngle = vectorAngle > levelAngle
            ? 90 - vectorAngle + levelAngle
            : 90 + vectorAngle - levelAngle;
      } else {
        isCW = true;
        circleLineAngle = vectorAngle > levelAngle
            ? vectorAngle + levelAngle - 90
            : 90 - vectorAngle - levelAngle;
      }
    } else if (quadrant == 2) {
      if (velocityX > 0 && velocityY < 0) {
        isCW = true;
        circleLineAngle = vectorAngle > levelAngle
            ? vectorAngle + levelAngle - 90
            : 90 - vectorAngle - levelAngle;
      } else if (velocityX > 0 && velocityY > 0) {
        isCW = vectorAngle < levelAngle;
        circleLineAngle = vectorAngle > levelAngle
            ? 90 - vectorAngle + levelAngle
            : 90 + vectorAngle - levelAngle;
      } else if (velocityX < 0 && velocityY > 0) {
        isCW = false;
        circleLineAngle = vectorAngle > levelAngle
            ? vectorAngle - levelAngle
            : 90 - vectorAngle - levelAngle;
      } else {
        isCW = vectorAngle > levelAngle;
        circleLineAngle = vectorAngle > levelAngle
            ? 90 - vectorAngle + levelAngle
            : 90 + vectorAngle - levelAngle;
      }
    } else {
      if (velocityX > 0 && velocityY < 0) {
        isCW = vectorAngle < levelAngle;
        circleLineAngle = vectorAngle > levelAngle
            ? 90 - vectorAngle + levelAngle
            : 90 + vectorAngle - levelAngle;
      } else if (velocityX > 0 && velocityY > 0) {
        isCW = true;
        circleLineAngle = vectorAngle > levelAngle
            ? vectorAngle + levelAngle - 90
            : 90 - vectorAngle - levelAngle;
      } else if (velocityX < 0 && velocityY > 0) {
        isCW = vectorAngle > levelAngle;
        circleLineAngle = vectorAngle > levelAngle
            ? 90 - vectorAngle + levelAngle
            : 90 + vectorAngle - levelAngle;
      } else {
        isCW = false;
        circleLineAngle = vectorAngle > levelAngle
            ? vectorAngle - levelAngle
            : vectorAngle + levelAngle;
      }
    }

    double circleSpeed = abs(lineSpeed * cos(circleLineAngle));
    return (circleSpeed / distance * (isCW ? 1 : -1));
  }

  static abs(double value) {
    if (value >= 0)
      return value;
    else {
      return -1 * value;
    }
  }

  static double randomNumber(int min, int max) {
    int res = min + Random().nextInt(max - min);
    return res.toDouble();
  }
}
