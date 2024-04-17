import 'package:flutter/material.dart';
import 'package:flutter_ai/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

final _generationConfig = GenerationConfig(
  maxOutputTokens: 600,
  temperature: 2.0,
  topP: 0.95,
  topK: 40,
);

final model = GenerativeModel(
  generationConfig: _generationConfig,
  httpClient: http.Client(),
  model: 'gemini-pro',
  apiKey: api,
  safetySettings: [
    SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.low),
  ],
);

void main() {
  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter AI'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _GeminiChat(),
          ))));
}

class _GeminiChat extends StatelessWidget {
  final ValueNotifier<String> _genText = ValueNotifier("");
  final TextEditingController _textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            controller: _textEditController),
        ElevatedButton(
          onPressed: _fetchData,
          child: const Text('Генерация'),
        ),
        ValueListenableBuilder<String>(
          valueListenable: _genText,
          builder: (_, value, __) {
            return SizedBox(
                height: 300, child: SingleChildScrollView(child: Text(value)));
          },
        )
      ],
    );
  }

  Future<void> _fetchData() async {
    final content = [Content.text(_textEditController.text)];
    _genText.value = "Генерация...";
    await model.generateContent(content).then((value) {
      _genText.value = value.text ?? "Error";
    });
  }
}
