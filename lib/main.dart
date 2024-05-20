// import 'dart:async';

// void main() {
//   Stream<int> intStream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);
//   intStream.listen((data) {
//     print(data); // Prints numbers from 1 to 5
//   });
// }

// import 'dart:async';

// void main() {
//   // Create a StreamController
//   StreamController<int> controller = StreamController<int>();

//   // Get the stream from the controller
//   Stream<int> intStream = controller.stream;

//   // Listen to the stream
//   intStream.listen((data) {
//     print(data); // Prints numbers from 1 to 5
//   });

//   // Add data to the stream
//   for (int i = 1; i <= 5; i++) {
//     controller.add(i);
//   }

//   // Close the stream
//   controller.close();
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const PulseReader());
}

class PulseReader extends StatelessWidget {
  const PulseReader({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const PulseReaderScreen(),
    );
  }
}

class PulseReaderScreen extends StatefulWidget {
  const PulseReaderScreen({super.key});

  @override
  State<PulseReaderScreen> createState() => _PulseReaderScreenState();
}

class _PulseReaderScreenState extends State<PulseReaderScreen> {
  late StreamController _pulseController;
  late Stream _pulseStream;
  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _pulseController = StreamController<int>();
    _pulseStream = _pulseController.stream;
    _startPulseSimulation();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.close();
    super.dispose();
  }

  void _startPulseSimulation() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (_) {
      final int pulse = 60 + _random.nextInt(40);
      _pulseController.add(pulse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moraa, Jackie (Adult)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: _pulseStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Waiting for pulse data...',
                    style: TextStyle(fontSize: 24),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 24),
                  );
                } else if (!snapshot.hasData) {
                  return const Text(
                    'No pulse data available',
                    style: TextStyle(fontSize: 24),
                  );
                } else {
                  return Column(
                    children: [
                      const Text('Current Pulse:', style: TextStyle(fontSize: 24)),
                      Text(
                        '${snapshot.data} BPM',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
