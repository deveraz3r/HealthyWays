import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthyways/features/chat/domain/entities/chat_room.dart';
import 'package:healthyways/features/chat/presentation/pages/chat_messages_page.dart';
import 'package:healthyways/features/permission_requests/presentation/controllers/premission_request_controller.dart';
import 'package:shimmer/shimmer.dart';

class ChatRoomTile extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomTile({super.key, required this.room});

  @override
  State<ChatRoomTile> createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  final _names = <String>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    final controller = Get.find<PermissionRequestController>();
    final names = await Future.wait(
      widget.room.participantIds.map((id) => controller.getNameById(id)),
    );
    if (mounted) {
      setState(() {
        _names.clear();
        _names.addAll(names);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        title:
            _isLoading
                ? Shimmer.fromColors(
                  baseColor: Colors.grey[700]!,
                  highlightColor: Colors.grey[500]!,
                  child: Container(
                    height: 14,
                    width: 160,
                    color: Colors.grey[700],
                  ),
                )
                : Text(
                  _names.join(', '),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
        subtitle: Text(
          widget.room.lastMessage ?? 'No messages yet',
          style: const TextStyle(color: Colors.white60),
        ),
        onTap: () => Get.to(() => ChatMessagesPage(room: widget.room)),
      ),
    );
  }
}
