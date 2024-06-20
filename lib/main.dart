import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

const apiKey = 'REPLACE WITH YOUR OWN API KEY';

Future<String> generateResponse() async {
  final model =
      GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
  const prompt = 'Do these look store-bought or homemade?';

  ByteData byteData = await rootBundle.load('assets/images/cookies.jpg');
  Uint8List bytes = byteData.buffer.asUint8List();

  final content = [
    Content.multi([
      TextPart(prompt),
      DataPart('image/jpg', bytes),
    ])
  ];

  final response = await model.generateContent(content);
  return response.text ?? 'No response';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? response = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () async {
                response = await generateResponse().whenComplete(() {
                  setState(() {});
                });
              },
              child: const Text('Tap me'),
            ),
            Text(response!)
          ],
        ),
      ),
    );
  }
}
