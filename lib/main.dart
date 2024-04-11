import 'package:flutter/material.dart';
import 'package:flutter_ai/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(model: 'gemini-pro', apiKey: api);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Flutter AI'),
            ),
            body: const Padding(
              padding: EdgeInsets.all(8.0),
              child: _GeminiChat(),
            )));
  }
}

class _GeminiChat extends StatefulWidget {
  const _GeminiChat();

  @override
  State<_GeminiChat> createState() => _GeminiChatState();
}

class _GeminiChatState extends State<_GeminiChat> {
  String genText = "";
  final _textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditController.text = genText;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        TextField(
          controller: _textEditController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _fetchData();
          },
          child: const Text('Генерация'),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Text(genText),
          ),
        )
      ],
    ));
  }

  Future<void> _fetchData() async {
    final content = [Content.text(_textEditController.text)];
    setState(() {
      genText = "Генерация...";
    });
    await model.generateContent(content).then((value) {
      genText = value.text ?? "Error";
      setState(() {});
    });
  }
}
