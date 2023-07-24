import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

/**
 * <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    'extraHeaders': {'foo': 'bar'},
 */

  IO.Socket socket = IO.io(
      "http://hs.k-telecom.org:8081",
      IO.OptionBuilder().setTransports([
        'websocket'
      ]).build()); //установил транспорт билдера - погуглить подробнее

  @override
  void initState() {
    socket.connect();
    socket.onConnect((data) => print("connect: $data"));
    socket.onConnectError((data) => {print("error connect: ${data}")});
    super.initState();
  }

  void _incrementCounter() {
    socket.connect();
    socket.onConnect((data) => print("connect: $data"));
    socket.onConnectError((data) => {print("error connect: ${data}")});
    // socket.onConnect((_) => print("conected"));
    setState(() {
      if (socket.connected) {
        _counter = 200;
        print("connecting code 200");
      } else {
        _counter = 404;
      }
    });
  }

  void _tryPing() {
    socket.emit('ping', {'for': 'ping'});
  }

  void _tryPong() {
    socket.on('pong', (data) {
      if (data.from == 'pong') {
        //дата является интом
        print("Эвент понг");
      } else {
        print("event another");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Response',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(onPressed: _tryPing, child: Text('Ping')),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: _tryPong, child: Text('Pong')),
            const SizedBox(height: 15),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
