import 'package:flutter/material.dart';

// class HexagonalPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint =
//         Paint()
//           ..color = Colors.blue
//           ..style = PaintingStyle.stroke;
//     final path =
//         Path()
//           ..moveTo(0, size.height * 0.5)
//           // ..arcToPoint(Offset(5, size.height * 0.5-10),
//           //     radius: Radius.circular(size.width * 0.25),
//           //     clockwise: true)
//           ..lineTo(size.width * 0.25, 0)
//           ..lineTo(size.width * 0.75, 0)
//           ..lineTo(size.width, size.height * 0.5)
//           ..lineTo(size.width*0.75, size.height)
//           ..lineTo(size.width*0.25, size.height)
//           ..lineTo(0, size.height*0.5);
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// class RPSCustomPainter extends CustomPainter {
// @override
// void paint(Canvas canvas, Size size) {
//
// Path path = Path();
// path.moveTo(size.width*0.4595292,size.height*0.1058167);
// path.cubicTo(size.width*0.4847000,size.height*0.09183417,size.width*0.5153000,size.height*0.09183417,size.width*0.5404708,size.height*0.1058167);
// path.lineTo(size.width*0.8321375,size.height*0.2678538);
// path.cubicTo(size.width*0.8585917,size.height*0.2825512,size.width*0.8750000,size.height*0.3104363,size.width*0.8750000,size.height*0.3407004);
// path.lineTo(size.width*0.8750000,size.height*0.6593000);
// path.cubicTo(size.width*0.8750000,size.height*0.6895625,size.width*0.8585917,size.height*0.7174500,size.width*0.8321375,size.height*0.7321458);
// path.lineTo(size.width*0.5404708,size.height*0.8941833);
// path.cubicTo(size.width*0.5153000,size.height*0.9081667,size.width*0.4847000,size.height*0.9081667,size.width*0.4595292,size.height*0.8941833);
// path.lineTo(size.width*0.1678629,size.height*0.7321458);
// path.cubicTo(size.width*0.1414075,size.height*0.7174500,size.width*0.1250000,size.height*0.6895625,size.width*0.1250000,size.height*0.6593000);
// path.lineTo(size.width*0.1250000,size.height*0.3407004);
// path.cubicTo(size.width*0.1250000,size.height*0.3104363,size.width*0.1414075,size.height*0.2825512,size.width*0.1678629,size.height*0.2678538);
// path.lineTo(size.width*0.4595292,size.height*0.1058167);
// path.close();
//
// Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=2;
// paint_0_stroke.color=Color(0xff000000).withOpacity(1.0);
// canvas.drawPath(path,paint_0_stroke);
//
// // Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
// // paint_0_fill.color = Color(0xff000000).withOpacity(1.0);
// // canvas.drawPath(path,paint_0_fill);
//
// }
//
// @override
// bool shouldRepaint(covariant CustomPainter oldDelegate) {
// return true;
// }
// }

class HexagonPainter extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path = Path();
path.moveTo(size.width*0.3197917,size.height*0.8750000);
path.cubicTo(size.width*0.3086812,size.height*0.8750000,size.width*0.2983375,size.height*0.8722646,size.width*0.2887604,size.height*0.8667917);
path.cubicTo(size.width*0.2791917,size.height*0.8613271,size.width*0.2714792,size.height*0.8536458,size.width*0.2656250,size.height*0.8437500);
path.lineTo(size.width*0.08437542,size.height*0.5312500);
path.cubicTo(size.width*0.07882000,size.height*0.5212979,size.width*0.07604208,size.height*0.5108271,size.width*0.07604208,size.height*0.4998333);
path.cubicTo(size.width*0.07604208,size.height*0.4888333,size.width*0.07882000,size.height*0.4784729,size.width*0.08437542,size.height*0.4687500);
path.lineTo(size.width*0.2656250,size.height*0.1562500);
path.cubicTo(size.width*0.2714792,size.height*0.1463542,size.width*0.2791917,size.height*0.1386702,size.width*0.2887604,size.height*0.1331979);
path.cubicTo(size.width*0.2983375,size.height*0.1277327,size.width*0.3086813,size.height*0.1250000,size.width*0.3197917,size.height*0.1250000);
path.lineTo(size.width*0.6802083,size.height*0.1250000);
path.cubicTo(size.width*0.6913208,size.height*0.1250000,size.width*0.7016646,size.height*0.1277327,size.width*0.7112396,size.height*0.1331979);
path.cubicTo(size.width*0.7208104,size.height*0.1386702,size.width*0.7285208,size.height*0.1463542,size.width*0.7343750,size.height*0.1562500);
path.lineTo(size.width*0.9156250,size.height*0.4687500);
path.cubicTo(size.width*0.9211813,size.height*0.4787021,size.width*0.9239583,size.height*0.4891729,size.width*0.9239583,size.height*0.5001667);
path.cubicTo(size.width*0.9239583,size.height*0.5111667,size.width*0.9211813,size.height*0.5215271,size.width*0.9156250,size.height*0.5312500);
path.lineTo(size.width*0.7343750,size.height*0.8437500);
path.cubicTo(size.width*0.7285208,size.height*0.8536458,size.width*0.7208104,size.height*0.8613271,size.width*0.7112396,size.height*0.8667917);
path.cubicTo(size.width*0.7016646,size.height*0.8722646,size.width*0.6913208,size.height*0.8750000,size.width*0.6802083,size.height*0.8750000);
path.lineTo(size.width*0.3197917,size.height*0.8750000);
path.close();

Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=2;
paint_0_stroke.color=Color(0xffa04Ff0).withAlpha(100);
canvas.drawPath(path,paint_0_stroke);

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xffa04Ff0).withAlpha(40);
canvas.drawPath(path,paint_0_fill);
}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}
