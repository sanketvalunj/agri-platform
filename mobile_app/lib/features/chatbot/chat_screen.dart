import 'package:agri_platform/services/tts_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // ✅ kIsWeb

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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TtsApiService _ttsApiService = TtsApiService();

  String? _currentPlayingUrl;
  bool isLoading = false;

  final List<Map<String, dynamic>> messages = [
    {
      "text": "Namaskar! 🌱\nI am Agri Bot.\nAsk me anything about farming.",
      "isUser": false,
      "audioUrl": null,
      "isGeneratingAudio": false,
      "audioError": null,
    }
  ];

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() => _currentPlayingUrl = null);
      }
    });

    // 🔕 AUTO-TTS DISABLED ON WEB (VERY IMPORTANT)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!kIsWeb && messages.isNotEmpty && !messages[0]["isUser"]) {
        _generateTtsForMessage(messages[0]);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

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
        "audioUrl": null,
        "isGeneratingAudio": false,
        "audioError": null,
      });
      isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final reply = await ChatService.sendMessage(
        userId: "demo_user",
        message: text,
      );

      if (!mounted) return;

      final index = messages.length;
      setState(() {
        messages.add({
          "text": reply,
          "isUser": false,
          "audioUrl": null,
          "isGeneratingAudio": false,
          "audioError": null,
        });
      });

      // 🔕 AUTO-TTS ONLY ON MOBILE
      if (!kIsWeb) {
        _generateTtsForMessage(messages[index]);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        messages.add({
          "text": "Sorry, something went wrong. Please try again.",
          "isUser": false,
          "audioUrl": null,
          "isGeneratingAudio": false,
          "audioError": null,
        });
      });
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  // ===================== TTS LOGIC =====================

  Future<void> _generateTtsForMessage(Map<String, dynamic> message) async {
    if (kIsWeb || message["isUser"] == true) return;

    try {
      setState(() => message['isGeneratingAudio'] = true);

      final audioUrl =
          await _ttsApiService.convertTextToSpeech(message['text']);

      setState(() {
        message['audioUrl'] = audioUrl;
        message['isGeneratingAudio'] = false;
      });
    } catch (e) {
      setState(() {
        message['isGeneratingAudio'] = false;
        message['audioError'] = e.toString();
      });
    }
  }

  Future<void> playTts(Map<String, dynamic> message) async {
    // ❌ Disable audio completely on Web
    if (kIsWeb) return;

    String? audioUrl = message['audioUrl'];

    if (audioUrl == null) {
      try {
        setState(() => message['isGeneratingAudio'] = true);

        audioUrl = await _ttsApiService.convertTextToSpeech(message['text']);

        setState(() {
          message['audioUrl'] = audioUrl;
          message['isGeneratingAudio'] = false;
        });
      } catch (e) {
        setState(() {
          message['isGeneratingAudio'] = false;
          message['audioError'] = e.toString();
        });
        return;
      }
    }

    final isPlaying = _currentPlayingUrl == audioUrl &&
        _audioPlayer.state == PlayerState.playing;

    final isPaused = _currentPlayingUrl == audioUrl &&
        _audioPlayer.state == PlayerState.paused;

    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else if (isPaused) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(audioUrl));
        setState(() => _currentPlayingUrl = audioUrl);
      }
    } catch (_) {}
  }

  // ===================== UI =====================

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.alerts),
          ),
        ],
      ),
      body: Column(
        children: [
          _quickChips(),
          Expanded(child: _chatList()),
          _inputBar(),
        ],
      ),
    );
  }

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
        ),
      ),
    );
  }

  Widget _chatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (_, index) {
        if (isLoading && index == messages.length) {
          return const Text("Agri Bot is typing… 🌾");
        }

        final msg = messages[index];
        if (msg["isUser"]) {
          return UserBubble(text: msg["text"]);
        }

        return BotBubble(
          text: msg["text"],
          onTtsPressed: () => playTts(msg),
          isGeneratingAudio: msg['isGeneratingAudio'] == true,
          audioError: msg['audioError'],
        );
      },
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: sendMessage,
              decoration: InputDecoration(
                hintText: 'Ask your farming question…',
                filled: true,
                fillColor: Colors.grey.shade100,
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

// ===================== BUBBLES =====================

class BotBubble extends StatelessWidget {
  final String text;
  final VoidCallback onTtsPressed;
  final bool isGeneratingAudio;
  final String? audioError;

  const BotBubble({
    Key? key,
    required this.text,
    required this.onTtsPressed,
    this.isGeneratingAudio = false,
    this.audioError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            const SizedBox(height: 6),
            IconButton(
              icon: Icon(
                isGeneratingAudio ? Icons.hourglass_empty : Icons.volume_up,
              ),
              onPressed: isGeneratingAudio ? null : onTtsPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class UserBubble extends StatelessWidget {
  final String text;
  const UserBubble({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
