import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

int samplesize = 10;
int speed = 0;

class _MyHomePageState extends State<MyHomePage> {
  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;
  List<int> _numbers = [];
  int duration = 100000;
  _changeSpeed() {
    if (speed >= 9) {
      speed = 0;
      duration = 100000;
    } else {
      speed++;
      duration = duration ~/ 2;
    }
  }

  _changeSize() {
    if (samplesize == 10)
      samplesize = 20;
    else if (samplesize == 20)
      samplesize = 30;
    else if (samplesize == 30)
      samplesize = 40;
    else if (samplesize == 40)
      samplesize = 50;
    else if (samplesize == 50)
      samplesize = 100;
    else if (samplesize == 100)
      samplesize = 200;
    else if (samplesize == 200)
      samplesize = 400;
    else if (samplesize == 400)
      samplesize = 500;
    else
      samplesize = 10;
  }

  int counter = 0;
  void _randomize() {
    _numbers = [];
    for (int i = 0; i < samplesize; i++) _numbers.add(Random().nextInt(500));
    _streamController.add(_numbers);
  }

  Future<void> _sort() async {
    for (int i = 0; i < _numbers.length; i++) {
      for (int j = 0; j < _numbers.length - i - 1; j++) {
        if (_numbers[j] > _numbers[j + 1])
          _numbers[j] =
              _numbers[j] + _numbers[j + 1] - (_numbers[j + 1] = _numbers[j]);
        await Future.delayed(Duration(microseconds: duration));
        _streamController.add(_numbers);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
    _randomize();
  }

  @override
  Widget build(BuildContext context) {
    var a = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Bubble Sort')),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 0.0),
        child: StreamBuilder<Object>(
            stream: _stream,
            initialData: _numbers,
            builder: (context, snapshot) {
              List<int> numbers = snapshot.data;
              int counter = 0;

              return Row(
                children: numbers.map((int num) {
                  counter++;
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: CustomPaint(
                        painter: BarPainter(
                          width: MediaQuery.of(context).size.width /
                              (samplesize + 1),
                          value: num,
                          index: counter,
                          a: a,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Text('Sort'),
              onPressed: _sort,
            ),
            FlatButton(
              child: Text('Randomize'),
              onPressed: _randomize,
            ),
            FlatButton(
              onPressed: () {
                _changeSpeed();
                setState(() {});
              },
              child: Text("${speed + 1}x"),
            ),
            FlatButton(
              onPressed: () {
                _changeSize();
                _randomize();
                setState(() {});
              },
              child: Text("${samplesize}S"),
            ),
          ],
        ),
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  final double width;
  final int value;
  final int index;
  var a;
  BarPainter({this.width, this.value, this.index, this.a});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    if (this.value < 500 * .10) {
      paint.color = Color(0xFFDEEDCF);
    } else if (this.value < 500 * .20) {
      paint.color = Color(0xFFBFE1B0);
    } else if (this.value < 500 * .30) {
      paint.color = Color(0xFF99D492);
    } else if (this.value < 500 * .40) {
      paint.color = Color(0xFF74C67A);
    } else if (this.value < 500 * .50) {
      paint.color = Color(0xFF56B870);
    } else if (this.value < 500 * .60) {
      paint.color = Color(0xFF39A96B);
    } else if (this.value < 500 * .70) {
      paint.color = Color(0xFF1D9A6C);
    } else if (this.value < 500 * .80) {
      paint.color = Color(0xFF188977);
    } else if (this.value < 500 * .90) {
      paint.color = Color(0xFF137177);
    } else {
      paint.color = Color(0xFF0E4D64);
    }
    paint.strokeWidth = a / samplesize;
    paint.strokeCap = StrokeCap.square;

    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble()), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
