import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/screens/mainAppScreen.dart';


// Connection with Backend
Future<String> getMoodGenieResponse(String userPrompt) async {
  final url = Uri.parse('https://moodgenie.onrender.com/chat'); // e.g., http://192.168.1.5:8000/chat

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"user_prompt": userPrompt}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['response']; // This is what you show to the user
  } else {
    throw Exception('Failed to get response from MoodGenie');
  }
}

Future<String> getSummaryFromMoodGenie() async {
  final url = Uri.parse('https://moodgenie.onrender.com/summary');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['summary'];
  } else {
    throw Exception('Failed to get summary');
  }
}


class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Message> _messages = [
    Message(
      "Hi! I'm MoodGenie 🤖, your AI mood companion. How are you feeling today?",
      false,
    ),
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  void _sendMessage() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add(Message(input, true));
      _isTyping = true;
    });

    _controller.clear();

    // Scroll to bottom after user message is added
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Simulate AI delay
    Future.delayed(const Duration(seconds: 1), () async {
      try {
        final botReply = await getMoodGenieResponse(input);
        // Show AI's response
        setState(() {
          _messages.add(Message(botReply, false));
          _isTyping = false;
        });
      } catch (e) {
        setState(() {
          _messages.add(Message("MoodGenie is facing some technical issues 😔", false));
          _isTyping = false;
        });
      }

      // Scroll again after AI message is added
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      try {
        final moodSummary = await getSummaryFromMoodGenie();

        // ✅ Save to history
        historyScreenKey.currentState?.save_mood_history(moodSummary);

      } catch (e) {
        print("Failed to save mood summary.");
      }

    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color.fromARGB(255, 0, 17, 77).withOpacity(0.95);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/MoodGenie.png", scale: 40,),
                SizedBox(width: 10,),
                const Text(
                "Mood Genie",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
                SizedBox(width: 10,),
                Image.asset("assets/MoodGenie.png",scale: 40,),
              ],
            ),
            
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Typing...",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    );
                  }

                  final message = _messages[index];
                  return Align(
                    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Colors.blueAccent
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color.fromARGB(98, 0, 0, 0)
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black
                        ),
                        cursorColor: const Color.fromARGB(181, 0, 0, 0),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(182, 238, 108, 9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
