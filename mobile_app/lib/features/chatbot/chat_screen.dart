import 'package:flutter/material.dart';
import '../../services/chat_service.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

/// ChatbotScreen
/// -------------
/// Purpose:
/// - Farmer advisory via chat
/// - Ask farming questions in simple language
///
/// UX Principles:
/// - Familiar chat layout (WhatsApp-like)
/// - Large text & spacing
/// - Big input & send buttons
/// - Voice-ready UI
///
/// NOW:
/// - Integrated with FastAPI backend
/// - Real chat responses
/// - Loading + error handling

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      "text": "Hello! I am Agri Bot 🌱\nAsk me any farming question.",
      "isUser": false,
    }
  ];

  bool isLoading = false;

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"text": text, "isUser": true});
      _controller.clear();
      isLoading = true;
    });

    try {
      final reply = await ChatService.sendMessage(text);

      setState(() {
        messages.add({"text": reply, "isUser": false});
      });
    } catch (e) {
      setState(() {
        messages.add({
          "text": "Sorry, something went wrong. Please try again.",
          "isUser": false,
        });
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 AppBar
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ask Agri Bot',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          // 💬 Chat Messages Area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (isLoading && index == messages.length) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: ChatBubble(
                      message: "Agri Bot is typing… 🌾",
                      isUser: false,
                    ),
                  );
                }

                final msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ChatBubble(
                    message: msg["text"],
                    isUser: msg["isUser"],
                  ),
                );
              },
            ),
          ),

          // ✍️ Input Area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                // 🎤 Voice Button (UI-only for now)
                SizedBox(
                  height: 52,
                  width: 52,
                  child: IconButton(
                    icon: Icon(
                      Icons.mic,
                      size: 30,
                      color: Colors.green.shade700,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voice input coming soon 🎤'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // 📝 Text Input
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => sendMessage(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Ask your farming question…',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // 📤 Send Button
                SizedBox(
                  height: 56,
                  width: 56,
                  child: ElevatedButton(
                    onPressed: sendMessage,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.green.shade700,
                      elevation: 2,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // 🟢 Bottom Navigation
      bottomNavigationBar: const AgriBottomNav(currentIndex: 1),
    );
  }
}

/// 💬 ChatBubble
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = isUser ? Colors.green.shade100 : Colors.grey.shade200;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
              ),
        ),
      ),
    );
  }
}
