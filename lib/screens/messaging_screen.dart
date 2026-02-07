import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';
import '../services/messaging_service.dart';
import '../services/connection_service.dart';
import '../utilities/themes.dart';

class MessagingScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String otherUserPicture;

  const MessagingScreen({
    Key? key,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserPicture,
  }) : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MessagingService _messagingService = MessagingService();
  final ConnectionService _connectionService = ConnectionService();

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _markMessagesAsRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    _messagingService.getConversation(widget.otherUserId, _auth.currentUser!.uid).listen((messages) {
      setState(() {
        _messages = messages;
      });
      _scrollToBottom();
    });
  }

  Future<void> _markMessagesAsRead() async {
    await _messagingService.markMessagesAsRead(widget.otherUserId);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final success = await _messagingService.sendTextMessage(
      widget.otherUserId,
      _messageController.text.trim(),
    );

    if (success) {
      _messageController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Scaffold(body: Center(child: Text('Please login')));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: ScoutConnectTheme.primaryColor,
              backgroundImage: widget.otherUserPicture.isNotEmpty
                  ? NetworkImage(widget.otherUserPicture)
                  : null,
              child: widget.otherUserPicture.isEmpty
                  ? const Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.otherUserName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Show user profile
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet. Start the conversation!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMe = message.senderId == currentUser.uid;
                      
                      return _buildMessageBubble(message, isMe);
                    },
                  ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // TODO: Attach file
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: ScoutConnectTheme.primaryColor,
              backgroundImage: widget.otherUserPicture.isNotEmpty
                  ? NetworkImage(widget.otherUserPicture)
                  : null,
              child: widget.otherUserPicture.isEmpty
                  ? const Icon(Icons.person, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isMe ? ScoutConnectTheme.primaryColor : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.connectionRequest)
                    _buildConnectionRequestMessage(message)
                  else if (message.type == MessageType.connectionAccepted)
                    _buildConnectionUpdateMessage(message, 'accepted')
                  else if (message.type == MessageType.connectionDeclined)
                    _buildConnectionUpdateMessage(message, 'declined')
                  else
                    _buildTextMessage(message),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: ScoutConnectTheme.accentColor,
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConnectionRequestMessage(Message message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_add, size: 16, color: ScoutConnectTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              'Connection Request',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ScoutConnectTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(message.content),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () async {
                  final connectionId = '${message.senderId}_${message.receiverId}';
                  await _connectionService.acceptConnectionRequest(connectionId);
                },
                child: const Text('Accept'),
                style: TextButton.styleFrom(
                  backgroundColor: ScoutConnectTheme.successColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  final connectionId = '${message.senderId}_${message.receiverId}';
                  await _connectionService.declineConnectionRequest(connectionId);
                },
                child: const Text('Decline'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectionUpdateMessage(Message message, String action) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              action == 'accepted' ? Icons.check_circle : Icons.cancel,
              size: 16,
              color: action == 'accepted' 
                  ? ScoutConnectTheme.successColor 
                  : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              'Connection ${action}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: action == 'accepted' 
                    ? ScoutConnectTheme.successColor 
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(message.content),
      ],
    );
  }

  Widget _buildTextMessage(Message message) {
    return Text(
      message.content,
      style: TextStyle(
        color: message.senderId == _auth.currentUser!.uid 
            ? Colors.white 
            : Colors.black87,
      ),
    );
  }
}
