import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const twoPis = 2 * pi;
const halfPi = pi / 2;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _rx = 0.0, _ry = 0.0, _rz = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _rx += details.delta.dx;
        _ry += details.delta.dy;

        _rx %= twoPis;
        _ry %= twoPis;

        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rx)
                ..rotateY(_ry)
                ..rotateZ(_rz)
              //
              ,
              alignment: Alignment.center,
              child: const Center(
                child: Cube(
                  color: Colors.green,
                  fullSize: 200,
                  halfSize: 120,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _AngleSlider(
              angle: _rx,
              onChanged: (value) {
                _rx = value;
                setState(() {});
              },
            ),
            _AngleSlider(
              angle: _ry,
              onChanged: (value) {
                _ry = value;
                setState(() {});
              },
            ),
            _AngleSlider(
              angle: _rz,
              onChanged: (value) {
                _rz = value;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AngleSlider extends StatelessWidget {
  final double angle;
  final void Function(double)? onChanged;

  const _AngleSlider({
    required this.angle,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider.adaptive(
      value: angle,
      min: 0,
      max: twoPis,
      onChanged: onChanged?.call,
    );
  }
}

class Cube extends StatelessWidget {
  final Color color;

  final double fullSize;
  final double halfSize;
  const Cube({
    required this.color,
    required this.fullSize,
    required this.halfSize,
    Key? key,
  }) : super(key: key);

  double get threeFourthsSize => fullSize - halfSize / 2;

  double get quarterSize => halfSize / 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CubeFace(
          color: color,
          translateX: -quarterSize,
          rotateY: -halfPi,
          width: halfSize,
          height: fullSize,
        ),
        CubeFace(
          color: color,
          translateX: threeFourthsSize,
          rotateY: -halfPi,
          width: halfSize,
          height: fullSize,
        ),
        CubeFace(
          color: color,
          translateZ: quarterSize,
          width: fullSize,
          height: fullSize,
        ),
        CubeFace(
          color: color,
          translateZ: -quarterSize,
          width: fullSize,
          height: fullSize,
        ),
        CubeFace(
          color: color,
          translateY: -quarterSize,
          rotateX: -halfPi,
          width: fullSize,
          height: halfSize,
        ),
        CubeFace(
          color: color,
          translateY: threeFourthsSize,
          rotateX: -halfPi,
          width: fullSize,
          height: halfSize,
        ),
      ],
    );
  }
}

class CubeFace extends StatelessWidget {
  final double? rotateX;
  final double? rotateY;
  final double? rotateZ;

  final double? translateX;
  final double? translateY;
  final double? translateZ;

  final double width;
  final double height;

  final Color color;

  const CubeFace({
    this.rotateX,
    this.rotateY,
    this.rotateZ,
    this.translateX,
    this.translateY,
    this.translateZ,
    required this.color,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Matrix4 transform = Matrix4.identity();

    if (translateX != null || translateY != null || translateZ != null) {
      transform.translate(translateX ?? .0, translateY ?? .0, translateZ ?? .0);
    }

    if (rotateX != null) {
      transform.rotateX(rotateX!);
    }

    if (rotateY != null) {
      transform.rotateY(rotateY!);
    }

    if (rotateZ != null) {
      transform.rotateZ(rotateZ!);
    }

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        color: color,
      ),
    );
  }
}
