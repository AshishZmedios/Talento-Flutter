import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:talento_flutter/core/constants/constants.dart';
import 'package:talento_flutter/core/utils/time_tracker.dart';
import 'package:talento_flutter/domain/repositories/GeminiService.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class SuggestionChip {
  final String text;
  final IconData icon;
  final List<Color> gradientColors;

  const SuggestionChip({
    required this.text,
    required this.icon,
    required this.gradientColors,
  });
}

class ArtificialIntelligence extends StatefulWidget {
  const ArtificialIntelligence({super.key});

  @override
  State<ArtificialIntelligence> createState() => _ArtificialIntelligenceState();
}

class _ArtificialIntelligenceState extends State<ArtificialIntelligence>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _showWelcomeLoader = true;
  bool _showSuggestions = false;
  bool _isSuggestFabVisible = true;
  double _lastScrollPosition = 0;
  String responseText = '';
  final GeminiService _geminiService = GeminiService();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _suggestionsController;
  late Animation<double> _suggestionsScaleAnimation;
  late Animation<double> _suggestionsOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _suggestionsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _suggestionsScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _suggestionsController, curve: Curves.easeOut),
    );

    _suggestionsOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _suggestionsController, curve: Curves.easeOut),
    );

    _scrollController.addListener(_onScroll);
    _fadeController.forward();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _showWelcomeLoader = false;
        _messages.add({
          "isUser": false,
          "text": "Hi! 👋 I'm your AI assistant. How can I help you today?",
          "timestamp": DateTime.now(),
        });
      });
    });
  }

  void _onScroll() {
    final currentScroll = _scrollController.offset;
    if (currentScroll > _lastScrollPosition &&
        _isSuggestFabVisible &&
        currentScroll > 100) {
      setState(() {
        _isSuggestFabVisible = false;
        if (_showSuggestions) {
          _showSuggestions = false;
          _suggestionsController.reverse();
        }
      });
    } else if (currentScroll < _lastScrollPosition && !_isSuggestFabVisible) {
      setState(() => _isSuggestFabVisible = true);
    }
    _lastScrollPosition = currentScroll;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _suggestionsController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final DateTime messageTime = DateTime.now();
    setState(() {
      _messages.add({
        "isUser": true,
        "text": message,
        "timestamp": messageTime,
      });
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Add a slight delay before showing typing indicator
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final response = await _geminiService.generateResponse(message);

      // Add a small delay to make the response feel more natural
      await Future.delayed(Duration(milliseconds: 300));

      setState(() {
        _messages.add({
          "isUser": false,
          "text": response,
          "timestamp": DateTime.now(),
        });
        _isTyping = false;
      });
    } catch (e) {
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        _messages.add({
          "isUser": false,
          "text": "Oops! Something went wrong. Please try again.",
          "timestamp": DateTime.now(),
        });
        _isTyping = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<bool> _handleBackPress() async {
    if (_messages.isEmpty) return true;

    return await showDialog<bool>(
          context: context,
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.exit_to_app_rounded,
                          color: AppConstants.primaryColor,
                          size: 32,
                        ),
                      ),
                      getVerticalSpacer(16),
                      Text(
                        "Exit Chat?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      getVerticalSpacer(8),
                      Text(
                        "Do you want to leave this conversation?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      getVerticalSpacer(24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          getHorizontalSpacer(12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _messages.clear();
                                  _isTyping = false;
                                });
                                Navigator.of(context).pop(true);
                                Navigator.of(context).pop(true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Exit",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        ) ??
        false;
  }

  Widget _buildMessageBubble(String text, bool isUser, DateTime timestamp) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser) ...[
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.primaryColor,
                          AppConstants.primaryColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.primaryColor.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      FontAwesomeIcons.lightbulb,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  getHorizontalSpacer(8),
                ],
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? AppConstants.primaryColor : Colors.white,
                      gradient:
                          isUser
                              ? LinearGradient(
                                colors: [
                                  AppConstants.primaryColor,
                                  AppConstants.primaryColor.withValues(
                                    alpha: 0.9,
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                              : null,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 20),
                      ),
                      border:
                          !isUser
                              ? Border.all(color: Colors.grey[200]!, width: 1.5)
                              : null,
                      boxShadow: [
                        BoxShadow(
                          color: (isUser
                                  ? AppConstants.primaryColor
                                  : Colors.grey[300]!)
                              .withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        getVerticalSpacer(4),
                        Text(
                          DateFormat('hh:mm a').format(timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                isUser
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isUser) ...[
                  getHorizontalSpacer(8),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.primaryColor,
                          AppConstants.primaryColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.primaryColor.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              FontAwesomeIcons.lightbulb,
              color: Colors.white,
              size: 16,
            ),
          ),
          getHorizontalSpacer(8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[100]!, Colors.grey[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TypingDots(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final List<SuggestionChip> suggestions = [
      SuggestionChip(
        text: "Find jobs",
        icon: Icons.work_outline,
        gradientColors: [Color(0xFF7CB9E8), Color(0xFF4A90E2)],
      ),
      SuggestionChip(
        text: "Update my resume",
        icon: Icons.edit_document,
        gradientColors: [Color(0xFF98FB98), Color(0xFF32CD32)],
      ),
      SuggestionChip(
        text: "Mock interview",
        icon: Icons.record_voice_over,
        gradientColors: [Color(0xFFFFB347), Color(0xFFFF8C00)],
      ),
      SuggestionChip(
        text: "Remote Jobs",
        icon: Icons.laptop_mac,
        gradientColors: [Color(0xFFDDA0DD), Color(0xFF9370DB)],
      ),
      SuggestionChip(
        text: "Interview Tips",
        icon: Icons.lightbulb_outline,
        gradientColors: [Color(0xFF87CEEB), Color(0xFF1E90FF)],
      ),
      SuggestionChip(
        text: "Resume Builder",
        icon: Icons.description_outlined,
        gradientColors: [Color(0xFFFFB6C1), Color(0xFFFF69B4)],
      ),
    ];

    return AnimatedBuilder(
      animation: _suggestionsController,
      builder: (context, child) {
        return Positioned(
          bottom: 160,
          left: 16,
          child: Opacity(
            opacity: _suggestionsOpacityAnimation.value,
            child: Transform.scale(
              scale: _suggestionsScaleAnimation.value,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      suggestions.map((suggestion) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _sendMessage(suggestion.text);
                                setState(() {
                                  _showSuggestions = false;
                                });
                                _suggestionsController.reverse();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: IntrinsicWidth(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: suggestion.gradientColors,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: suggestion.gradientColors[0]
                                            .withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        suggestion.icon,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      getHorizontalSpacer(8),
                                      Text(
                                        suggestion.text,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: TimeTracker(
        screenName: AppConstants.artificialIntelligenceScreen,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: ModernBackButton(
              onPressed:
                  () =>
                      _messages.length > 2
                          ? _handleBackPress()
                          : Navigator.pop(context),
            ),
            title: Text(
              "AI Assistant",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            actions: [
              if (_messages.isNotEmpty && _messages.length > 2)
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                    ),
                                    getVerticalSpacer(16),
                                    Text(
                                      "Clear Conversation",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    getVerticalSpacer(8),
                                    Text(
                                      "Are you sure you want to clear the conversation?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    getVerticalSpacer(24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        getHorizontalSpacer(12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _messages.clear();
                                                _isTyping = false;
                                              });
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                              ),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              "Clear",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    label: Text(
                      "Clear",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: Stack(
            children: [
              if (_showWelcomeLoader)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.primaryColor,
                              ),
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ),
                      getVerticalSpacer(24),
                      Text(
                        "Initializing AI Assistant...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              SafeArea(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: 16, bottom: 80),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == _messages.length) {
                      return _buildTypingIndicator();
                    }
                    final message = _messages[index];
                    return _buildMessageBubble(
                      message["text"],
                      message["isUser"],
                      message["timestamp"],
                    );
                  },
                ),
              ),
              if (_showSuggestions) _buildSuggestionChips(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(45),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hintText: "Ask me anything...",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 16),
                                  maxLines: null,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: _sendMessage,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppConstants.primaryColor,
                                      AppConstants.primaryColor.withValues(
                                        alpha: 0.8,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.primaryColor
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap:
                                        () => _sendMessage(
                                          _messageController.text,
                                        ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton:
              _isSuggestFabVisible
                  ? Container(
                    margin: EdgeInsets.only(bottom: 80),
                    child: ScaleTransition(
                      scale: _suggestionsController.drive(
                        Tween<double>(begin: 1.0, end: 0.8),
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _showSuggestions = !_showSuggestions;
                          });
                          if (_showSuggestions) {
                            _suggestionsController.forward();
                          } else {
                            _suggestionsController.reverse();
                          }
                        },
                        backgroundColor: AppConstants.primaryColor.withValues(
                          alpha: 0.8,
                        ),
                        child: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          color: Colors.white,
                          progress: _suggestionsController,
                        ),
                      ),
                    ),
                  )
                  : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        ),
      ),
    );
  }
}

class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dot1, _dot2, _dot3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();

    _dot1 = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    _dot2 = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    _dot3 = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_buildDot(_dot1), _buildDot(_dot2), _buildDot(_dot3)],
    );
  }
}
