import 'package:flutter/material.dart';
//import 'package:flutter_socket_io/flutter_socket_io.dart';
//import 'package:flutter_socket_io/socket_io_manager.dart';
//import 'package:flutter_socket_io_example/Socket.dart';
//import './socketIoManager.dart' as sockets; //  as socket
import 'package:bus_tracker/app/Socketio/socketIoManager.dart' as sockets;

//TODO: to run this test clear //:
//void main() => runApp(new MyAppSocket());

class MyAppSocket extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePageSocket(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePageSocket extends StatefulWidget {
  MyHomePageSocket({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageSocketState createState() => new _MyHomePageSocketState();
}

class _MyHomePageSocketState extends State<MyHomePageSocket> {
  int _counter = 0;
  var mTextMessageController = new TextEditingController();

  

  @override
  void initState() {
    super.initState();
    sockets.SocketIOClass().connectSocket02();
  }  

 onSocketInfo3(dynamic data) {
    print("Socket info2: " + data);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePageSocket object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child:
                  const Text('CONNECT  SOCKET 01', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                //_connectSocket01();
                sockets.SocketIOClass().connectSocket02();
                //SocketIOClass.socketIO.subscribe("socket_info3", onSocketInfo3);

                 // handle Notifications         

//                _sendChatMessage(mTextMessageController.text);
              },
            ),
            new RaisedButton(
              child:
              const Text('CONNECT SOCKET 02', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                //_connectSocket02();
//                _sendChatMessage(mTextMessageController.text);
              },
            ),
            new RaisedButton(
              child: const Text('SEND MESSAGE', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                //_showToast();
                sockets.SocketIOClass().showToast(mTextMessageController.text);
//                _sendChatMessage(mTextMessageController.text);
              },
            ),
            new RaisedButton(
              child: const Text('SUBSCRIBES',
                  style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                //_subscribes();
                sockets.SocketIOClass().subscribes();
//                _sendChatMessage(mTextMessageController.text);
              },
            ),
            new RaisedButton(
              child: const Text('UNSUBSCRIBES',
                  style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                //_unSubscribes();
                sockets.SocketIOClass().unSubscribes();
//                _sendChatMessage(mTextMessageController.text);
              },
            ),
            new RaisedButton(
              child: const Text('RECONNECT',
                  style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                //_reconnectSocket();
                sockets.SocketIOClass().reconnectSocket();
//                _sendChatMessage(mTextMessageController.text);
              },
            ),
            new RaisedButton(
              child: const Text('DISCONNECT',
                  style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                //_disconnectSocket();
                sockets.SocketIOClass().disconnectSocket();
//                _sendChatMessage(mTextMessageController.text);
              },
            ),
            new RaisedButton(
              child:
                  const Text('DESTROY', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              elevation: 0.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                //_destroySocket();
                sockets.SocketIOClass().destroySocket();
//                _sendChatMessage(mTextMessageController.text);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null, // SocketIOClass.incrementCounter, //_incrementCounter,        
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
