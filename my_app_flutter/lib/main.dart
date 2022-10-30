import 'package:my_app_client/my_app_client.dart';
import 'package:flutter/material.dart';
import 'package:pixels/pixels.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.
var client = Client('http://localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();
final api = client.user;
// final pixorama = client.pixoramaendpoint;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyFixels(),
      // home: const MyHomePage(title: 'Serverpod Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // These fields hold the last result or error message that we've received from
  // the server or null if no result exists yet.
  // String? _resultMessage;
  // String? _errorMessage;

  // final _textEditingController = TextEditingController();

  // // Calls the `hello` method of the `example` endpoint. Will set either the
  // // `_resultMessage` or `_errorMessage` field, depending on if the call
  // // is successful.
  // void _callHello() async {
  //   try {
  //     final result = await client.example.hello(_textEditingController.text);
  //     setState(() {
  //       _resultMessage = result;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = '$e';
  //     });
  //   }
  // }

  User? user;

  Widget buildUser(User? user) => Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircleAvatar(
              backgroundImage: user != null ? NetworkImage(user.image) : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(user != null ? user.name : 'No User'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildUser(user),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = User(
                        name: 'Sarah Abs',
                        image:
                            'https://images.unsplash.com/photo-1666855281847-43a68297f42b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw5NHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
                      );

                      final newUser = await api.create(user);

                      setState(() {
                        this.user = newUser;
                      });
                    },
                    child: const Text('Create'),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final users = await api.readAll();
                      setState(() {
                        user = users.first;
                      });
                    },
                    child: const Text('Read'),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (user == null) return;

                      user!.name = 'Emma Field';
                      user!.image =
                          'https://images.unsplash.com/photo-1666892488136-644c2a6d15b8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4Mnx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60';

                      final newUser = await api.update(user!);
                      setState(() {
                        user = newUser;
                      });
                    },
                    child: const Text('Update'),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (user == null) return;

                      final id = user!.id!;
                      await api.delete(id);

                      setState(() {
                        user = null;
                      });
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.title),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 16.0),
    //           child: TextField(
    //             controller: _textEditingController,
    //             decoration: const InputDecoration(
    //               hintText: 'Enter your name',
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 16.0),
    //           child: ElevatedButton(
    //             onPressed: _callHello,
    //             // onPressed: () async{
    //             //   final result = await api.hello('world');
    //             //   debugPrint(result);
    //             // },
    //             child: const Text('Send to Server'),
    //           ),
    //         ),
    //         _ResultDisplay(
    //           resultMessage: _resultMessage,
    //           errorMessage: _errorMessage,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

// _ResultDisplays shows the result of the call. Either the returned result from
// the `example.hello` endpoint method or an error message.
// class _ResultDisplay extends StatelessWidget {
//   final String? resultMessage;
//   final String? errorMessage;

//   const _ResultDisplay({
//     this.resultMessage,
//     this.errorMessage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     String text;
//     Color backgroundColor;
//     if (errorMessage != null) {
//       backgroundColor = Colors.red[300]!;
//       text = errorMessage!;
//     } else if (resultMessage != null) {
//       backgroundColor = Colors.green[300]!;
//       text = resultMessage!;
//     } else {
//       backgroundColor = Colors.grey[300]!;
//       text = 'No server response yet.';
//     }

//     return Container(
//       height: 50,
//       color: backgroundColor,
//       child: Center(
//         child: Text(text),
//       ),
//     );
//   }
// }

class MyFixels extends StatefulWidget {
  const MyFixels({super.key});

  @override
  State<MyFixels> createState() => _MyFixelsState();
}

class _MyFixelsState extends State<MyFixels> {
  late final StreamingConnectionHandler connectionHandler;
  PixelImageController? imageController;

  @override
  void initState() {
    super.initState();

    _listenServer();

    connectionHandler = StreamingConnectionHandler(
      client: client,
      listener: (_) => setState(() {}),
    );

    connectionHandler.connect();

    // imageController = PixelImageController(
    //   palette: const PixelPalette.rPlace(),
    //   width: 64,
    //   height: 64,
    // );
  }

  Future<void> _listenServer() async {
    await for (var update in client.pixoramaendpoint.stream) {
      if (update is ImageData) {
        setState(() {
          imageController = PixelImageController(
              pixels: update.pixels,
              palette: const PixelPalette.rPlace(),
              width: update.width,
              height: update.height);
        });
      }

      // if (update is ImageUpdate) {
      //   setState(() {
      //     imageController?.setPixelIndex(
      //         pixelIndex: update.pixelIndex, colorIndex: update.colorIndex);
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Serverpod Example2")),
      // backgroundColor: Colors.black,
      body: Center(
        child: imageController == null
            ? const CircularProgressIndicator()
            : PixelEditor(
                controller: imageController!,
                onSetPixel: (details) {
                  // client.p
                  client.pixoramaendpoint.sendStreamMessage(
                    ImageUpdate(
                      pixelIndex: details.tapDetails.index,
                      colorIndex: details.colorIndex,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
