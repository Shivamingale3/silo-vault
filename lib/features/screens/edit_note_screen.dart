import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/core/providers/vault_provider.dart';
import 'package:notes_vault/features/models/vault_item.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  final VaultItem item;

  const EditNoteScreen({super.key, required this.item});

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _contentController = TextEditingController(text: widget.item.content);
    _isFavorite = widget.item.isFavorite;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _onDone() async {
    final updated = VaultItem(
      id: widget.item.id,
      type: NoteType.note,
      title: _titleController.text.trim().isEmpty
          ? widget.item.title
          : _titleController.text.trim(),
      content: _contentController.text.isEmpty ? null : _contentController.text,
      category: widget.item.category,
      tags: widget.item.tags,
      isFavorite: _isFavorite,
      createdAt: widget.item.createdAt,
      updatedAt: DateTime.now(),
    );

    await ref.read(vaultProvider.notifier).updateItem(updated);

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // Force light-ish styling to match the iOS "paper" feel,
    // though it can adapt slightly if needed.
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leadingWidth: 90,
        leading: TextButton.icon(
          onPressed: () => context.pop(),
          icon: Icon(Icons.chevron_left, color: primaryColor, size: 28),
          label: Text(
            'Vault',
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 4),
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        title: Text(
          'Edit Note',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onDone,
            child: Text(
              'Done',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? Colors.white12 : Colors.black12,
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSubHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 24,
                    bottom: 100,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Note Title',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contentController,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.5,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Start writing...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFooter(primaryColor),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: primaryColor,
          elevation: 4,
          shape: const CircleBorder(),
          child: Icon(Icons.draw, color: theme.colorScheme.onPrimary, size: 28),
        ),
      ),
    );
  }

  Widget _buildSubHeader() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'LAST EDITED: ${widget.item.timeAgoUpdated.toUpperCase()}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: isDark ? Colors.white54 : const Color(0xFF8E8E93),
            ),
          ),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.share,
                  color: isDark ? Colors.white54 : Colors.black45,
                  size: 20,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.info_outline,
                  color: isDark ? Colors.white54 : Colors.black45,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Color primaryColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sell,
                      size: 14,
                      color: isDark ? Colors.white54 : const Color(0xFF8E8E93),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.item.category.name[0].toUpperCase() +
                          widget.item.category.name.substring(1),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: isDark ? Colors.white54 : const Color(0xFF8E8E93),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.format_list_bulleted,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.text_fields,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.image,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                onPressed: () {},
              ),
              Container(
                width: 1,
                height: 24,
                color: isDark ? Colors.white12 : Colors.black12,
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
                icon: Icon(
                  _isFavorite ? Icons.star : Icons.star_border,
                  color: _isFavorite
                      ? Colors.amber
                      : (isDark ? Colors.white54 : Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
