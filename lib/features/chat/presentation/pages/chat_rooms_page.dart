import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/core/common/controllers/app_profile_controller.dart';
import 'package:healthyways/features/chat/presentation/controllers/chat_controller.dart';
import 'package:healthyways/features/chat/presentation/widgets/chat_room_tile.dart';

class ChatRoomsPage extends StatefulWidget {
  const ChatRoomsPage({super.key});

  @override
  State<ChatRoomsPage> createState() => _ChatRoomsPageState();
}

class _ChatRoomsPageState extends State<ChatRoomsPage> {
  final controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    controller.fetchChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.chatRooms.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.chatRooms.hasError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${controller.chatRooms.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: controller.fetchChatRooms,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final rooms = controller.chatRooms.data ?? [];

      if (rooms.isEmpty) {
        return const Center(
          child: Text('No chats yet', style: TextStyle(color: Colors.white70)),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rooms.length,
        itemBuilder: (_, index) => ChatRoomTile(room: rooms[index]),
      );
    });
  }
}
