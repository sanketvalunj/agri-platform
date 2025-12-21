import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import '../../services/chat_service.dart';
import '../../shared/widgets/agri_bottom_nav.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  final List<Map<String, dynamic>> messages = [
    {
      "text": "Namaskar! 🌱\nI am Agri Bot.\nAsk me anything about farming.",
      "isUser": false,
      "type": "text"
    }
  ];

  final List<String> quickChips = [
    "Best crop for me",
    "Today mandi prices",
    "Will it rain?",
    "How to increase yield?"
  ];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "text": text,
        "isUser": true,
        "type": "text",
      });
      isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final reply = await ChatService.sendMessage(text);

      setState(() {
        messages.add({
          "text": reply,
          "isUser": false,
          "type": "text",
        });
      });
    } catch (_) {
      setState(() {
        messages.add({
          "text": "Sorry, something went wrong. Please try again.",
          "isUser": false,
          "type": "text",
        });
      });
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F3),
      appBar: AppBar(
        title: const Text('Ask Agri Bot'),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            tooltip: 'Alerts',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.alerts);
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          _quickChips(),
          Expanded(child: _chatList()),
          _inputBar(),
        ],
      ),
      bottomNavigationBar: const AgriBottomNav(currentIndex: 1),
    );
  }

  // 🟢 QUICK CHIPS
  Widget _quickChips() {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: quickChips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => ActionChip(
          label: Text(quickChips[i]),
          onPressed: () => sendMessage(quickChips[i]),
          backgroundColor: Colors.green.shade100,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // 💬 CHAT LIST
  Widget _chatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (_, index) {
        if (isLoading && index == messages.length) {
          return const BotBubble(
            text: "Agri Bot is typing… 🌾",
            isTyping: true,
          );
        }

        final msg = messages[index];
        return msg["isUser"]
            ? UserBubble(text: msg["text"])
            : BotBubble(text: msg["text"]);
      },
    );
  }

  // ✍️ INPUT BAR (VOICE + IMAGE + SEND)
  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.mic, color: Colors.green.shade700),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Voice input coming soon 🎤")),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.image, color: Colors.green.shade700),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Image input coming soon 🖼️")),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: sendMessage,
              decoration: InputDecoration(
                hintText: 'Ask your farming question…',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.green.shade700,
            onPressed: () => sendMessage(_controller.text),
            child: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}

/// 🤖 BOT MESSAGE
class BotBubble extends StatelessWidget {
  final String text;
  final bool isTyping;

  const BotBubble({required this.text, this.isTyping = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            )
          ],
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

/// 👤 USER MESSAGE
class UserBubble extends StatelessWidget {
  final String text;

  const UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade600, Colors.green.shade400],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
