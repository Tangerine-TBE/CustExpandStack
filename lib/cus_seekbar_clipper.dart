import 'package:flutter/widgets.dart';

class SeekBarClipper extends CustomClipper<RRect> {
  final int selectNum;
  final double radius;
  final int num;

  SeekBarClipper(
      {required this.selectNum,required this.num, required this.radius});

  @override
  RRect getClip(Size size) {
    double offsetWidth = size.width / num *  selectNum;
    if (offsetWidth > size.width) {
      offsetWidth = size.width;
    }
    return RRect.fromRectAndCorners(
      Rect.fromLTRB(0, 0, offsetWidth, size.height),
      topLeft: Radius.circular(
        radius,
      ),
      topRight: Radius.circular(
        radius,
      ),
      bottomLeft: Radius.circular(
        radius,
      ),
      bottomRight: Radius.circular(
        radius,
      ),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return true;
  }
}
