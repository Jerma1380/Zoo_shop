import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  final String receiverId; // The receiver's user ID.

  const ChatPage({Key? key, required this.receiverId}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SupabaseClient _client = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = _client.auth.currentUser;
    if (user == null || _messageController.text.trim().isEmpty) return;

    await _client.from('chats').insert({
      'sender_id': user.id,
      'receiver_id': widget.receiverId,
      'message': _messageController.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = _client.auth.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text("User not logged in")));
    }

    // Stream for SENT messages
    final sentStream = _client
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('sender_id', user.id);

    // Stream for RECEIVED messages
    final receivedStream = _client
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('sender_id', widget.receiverId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: combineStreams(sentStream, receivedStream),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                // Messages sorted by 'created_at'
                final messages = snapshot.data!;
                messages.sort((a, b) => DateTime.parse(a['created_at'])
                    .compareTo(DateTime.parse(b['created_at'])));

                return ListView.builder(
                  reverse: true, // Reverse to make messages flow upwards
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMe = message['sender_id'] == user.id;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.blueAccent
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10),
                            topRight: const Radius.circular(10),
                            bottomLeft: isMe
                                ? const Radius.circular(10)
                                : Radius.zero,
                            bottomRight: isMe
                                ? Radius.zero
                                : const Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          message['message'] ?? '',
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
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
    );
  }

  /// Function to combine two independent streams of messages.
  Stream<List<Map<String, dynamic>>> combineStreams(
      Stream<List<Map<String, dynamic>>> stream1,
      Stream<List<Map<String, dynamic>>> stream2) {
    return Stream.fromFuture(
      Future.wait([
        stream1.first,
        stream2.first,
      ]).then((value) => [...value[0], ...value[1]]),
    );
  }
}
