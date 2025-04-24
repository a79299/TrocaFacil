import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = []; // Placeholder for messages

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text.trim());
        // TODO: Implement sending message logic (e.g., to Firebase)
        print("Message sent: ${_messageController.text.trim()}");
        _messageController.clear();
      });
      FocusScope.of(context).unfocus(); // Close keyboard
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from the previous screen
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final otherUserName = arguments?['otherUserName'] ?? 'Chat'; // Default title if name not passed

    return Scaffold(
      appBar: AppBar(title: Text(otherUserName)),
      body: Column(
        children: [
          // Message List Area (Placeholder)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true, // Show latest messages at the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // Simple display for sent messages (assuming all are sent by current user for now)
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(_messages[_messages.length - 1 - index]), // Display in reverse order
                  ),
                );
              },
            ),
          ),
          // Message Input Area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
