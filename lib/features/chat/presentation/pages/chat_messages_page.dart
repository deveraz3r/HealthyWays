import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/features/chat/domain/entities/chat_room.dart';
import 'package:healthyways/features/chat/presentation/controllers/chat_controller.dart';
import 'package:healthyways/features/chat/presentation/widgets/message_bubble.dart';

class ChatMessagesPage extends StatefulWidget {
  final ChatRoom room;

  const ChatMessagesPage({super.key, required this.room});

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  final controller = Get.find<ChatController>();
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchMessages(widget.room.id);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Get.find<AppProfileController>().profile.data!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.messages.hasError) {
                return Center(
                  child: Text(
                    'Error: ${controller.messages.error}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }

              final messages = controller.messages.data ?? [];

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[index];
                  final isMe = msg.senderId == currentUserId;
                  return MessageBubble(message: msg, isMe: isMe);
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () =>
                      controller.isSendingMessage.value
                          ? const CircularProgressIndicator()
                          : IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              final text = messageController.text.trim();
                              if (text.isNotEmpty) {
                                controller.sendChatMessage(
                                  chatRoomId: widget.room.id,
                                  content: text,
                                );
                                messageController.clear();
                              }
                            },
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
