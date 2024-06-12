import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medtagapp/utils/credentials.dart';

class HealthResourcesPage extends StatefulWidget {
  const HealthResourcesPage({Key? key}) : super(key: key);

  @override
  _HealthResourcesPageState createState() => _HealthResourcesPageState();
}

class _HealthResourcesPageState extends State<HealthResourcesPage> {
  late TextEditingController _textEditingController;
  late GenerativeModel _model;
  final List<Map<String, String>> _chatHistory = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: Platform.environment['API_KEY'] ?? geminiApiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MedTag Bot',
          style: TextStyle(
            fontFamily: "Brand-Regular",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF67b8de),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chatHistory.length,
                itemBuilder: (context, index) {
                  final entry = _chatHistory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildChatBubble(entry['question']!, true),
                        const SizedBox(height: 4.0),
                        _buildChatBubble(entry['response']!, false),
                      ],
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Bir sağlık sorusu sorun...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _getAnswer(_textEditingController.text);
              },
              child: const Text('Soruyu Gönder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isQuestion) {
    return Align(
      alignment: isQuestion ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: isQuestion ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isQuestion ? Colors.white : Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Future<void> _getAnswer(String question) async {
    final chat = _model.startChat(history: [
      Content.text(question),
      Content.model([
        TextPart('Sizinle tanıştığıma memnun oldum. Ne bilmek istersiniz?'),
      ])
    ]);
    var content = Content.text(question);
    var response = await chat.sendMessage(content);
    String cleanedResponse =
        response.text?.replaceAll('*', '') ?? 'Cevap bulunamadı.';
    setState(() {
      _chatHistory.add({
        'question': question,
        'response': cleanedResponse,
      });
      _textEditingController.clear();
    });

    // Firestore'a kaydetme
    await _firestore.collection('chats').add({
      'question': question,
      'response': cleanedResponse,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
