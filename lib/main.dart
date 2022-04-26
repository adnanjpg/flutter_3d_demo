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
    return MaterialApp(
      home: const MyHomePage(),
    );
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
    print('rx: $_rx, ry: $_ry, rz: $_rz');

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

class _AngleSlider extends StatefulWidget {
  final double angle;
  final void Function(double)? onChanged;

  const _AngleSlider({
    required this.angle,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<_AngleSlider> createState() => _AngleSliderState();
}

class _AngleSliderState extends State<_AngleSlider> {
  late double _angle;

  @override
  void initState() {
    _angle = widget.angle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slider.adaptive(
      value: _angle,
      min: 0,
      max: twoPIs,
      onChanged: (value) {
        _angle = value;
        setState(() {});

        widget.onChanged?.call(value);
      },
    );
  }
}

class Cube extends StatelessWidget {
  const Cube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          transform: Matrix4.identity()
            ..translate(.0, 100.0, .0)
            ..rotateX(-pi / 2)
          //
          ,
          alignment: Alignment.center,
          child: Container(
            color: Colors.blue,
            child: const FlutterLogo(
              size: 200,
            ),
          ),
        ),
        Transform(
          transform: Matrix4.identity()
            ..translate(100.0, .0, .0)
            ..rotateY(-pi / 2)
          //
          ,
          alignment: Alignment.center,
          child: Container(
            color: Colors.orange,
            child: const FlutterLogo(
              size: 200,
            ),
          ),
        ),
        Transform(
          transform: Matrix4.identity()..translate(.0, .0, -100.0)
          //
          ,
          child: Container(
            color: Colors.red,
            child: const FlutterLogo(
              size: 200,
            ),
          ),
        ),
      ],
    );
  }

  _buildFace() {
    return Transform(
      transform: Matrix4.identity()
        ..translate(.0, 100.0, .0)
        ..rotateX(pi / 2)

      //
      ,
      alignment: Alignment.center,
      child: Container(
        color: Colors.blue,
        child: const FlutterLogo(
          size: 200,
        ),
      ),
    );
  }
}
