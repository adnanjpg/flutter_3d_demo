import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const twoPIs = 2 * pi;

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

        _rx %= twoPIs;
        _ry %= twoPIs;

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
                child: Cube(),
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
      max: twoPIs,
      onChanged: onChanged?.call,
    );
  }
}

class Cube extends StatelessWidget {
  const Cube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        CubeFace(
          color: Colors.blue,
          translateY: 100.0,
          rotateX: -pi / 2,
        ),
        CubeFace(
          color: Colors.purple,
          translateX: -100,
          rotateY: -pi / 2,
        ),
        CubeFace(
          color: Colors.black,
          translateZ: 100,
        ),
        CubeFace(
          color: Colors.orange,
          translateX: 100.0,
          rotateY: -pi / 2,
        ),
        CubeFace(
          color: Colors.pink,
          translateY: -100.0,
          rotateX: -pi / 2,
        ),
        CubeFace(
          color: Colors.red,
          translateZ: -100.0,
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

  final Color color;

  const CubeFace({
    this.rotateX,
    this.rotateY,
    this.rotateZ,
    this.translateX,
    this.translateY,
    this.translateZ,
    required this.color,
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
        color: color,
        child: const FlutterLogo(
          size: 200,
        ),
      ),
    );
  }
}
