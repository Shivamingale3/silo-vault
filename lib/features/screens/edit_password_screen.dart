import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/core/providers/vault_provider.dart';
import 'package:notes_vault/core/utils/password_utils.dart';
import 'package:notes_vault/features/models/vault_item.dart';
import 'package:notes_vault/features/widgets/upsert/amoled_input.dart';

class EditPasswordScreen extends ConsumerStatefulWidget {
  final VaultItem item;

  const EditPasswordScreen({super.key, required this.item});

  @override
  ConsumerState<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends ConsumerState<EditPasswordScreen> {
  late TextEditingController _titleController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _urlController;
  late TextEditingController _notesController;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _usernameController = TextEditingController(
      text: widget.item.username ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.item.password ?? '',
    );
    _urlController = TextEditingController(text: widget.item.websiteUrl ?? '');
    _notesController = TextEditingController(text: widget.item.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      return;
    }

    final password = _passwordController.text.trim();
    final updated = VaultItem(
      id: widget.item.id,
      type: NoteType.password,
      title: title,
      username: _usernameController.text.isEmpty
          ? null
          : _usernameController.text.trim(),
      password: password.isEmpty ? null : password,
      websiteUrl: _urlController.text.isEmpty
          ? null
          : _urlController.text.trim(),
      content: _notesController.text.isEmpty ? null : _notesController.text,
      category: widget.item.category,
      tags: widget.item.tags,
      isFavorite: widget.item.isFavorite,
      passwordStrength: password.isEmpty
          ? null
          : PasswordUtils.calculateStrength(password),
      createdAt: widget.item.createdAt,
      updatedAt: DateTime.now(),
    );

    await ref.read(vaultProvider.notifier).updateItem(updated);

    if (mounted) context.pop();
  }

  // ignore: unused_element
  Future<void> _onDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Password'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(vaultProvider.notifier).deleteItem(widget.item.id);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212).withValues(alpha: 0.95),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.chevron_left, color: primaryColor, size: 28),
        ),
        title: const Text(
          'Edit Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text(
              'Save',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white10, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            _buildHeaderWidget(primaryColor),
            const SizedBox(height: 32),
            _buildFormSection(),
            const SizedBox(height: 32),
            _buildDeleteButton(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWidget(Color primaryColor) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Icon(Icons.password, color: primaryColor, size: 36),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.item.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Last updated ${widget.item.timeAgoUpdated.toLowerCase()}',
          style: const TextStyle(fontSize: 14, color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        AmoledInput(
          label: 'Title',
          controller: _titleController,
          hintText: 'e.g. Netflix, Work Email',
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        AmoledInput(
          label: 'Username / Email',
          controller: _usernameController,
          hintText: 'Username or Email',
          keyboardType: TextInputType.emailAddress,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.content_copy,
              color: Colors.white54,
              size: 20,
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 16),
        AmoledInput(
          label: 'Password',
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: const TextStyle(fontFamily: 'monospace', color: Colors.white),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white54,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white54,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildPasswordStrengthIndicator(),
        const SizedBox(height: 16),
        AmoledInput(
          label: 'Website URL',
          controller: _urlController,
          hintText: 'https://example.com',
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16),
        AmoledInput(
          label: 'Notes',
          controller: _notesController,
          hintText: 'Add additional details...',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STRENGTH: WEAK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                height: 4,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.info, size: 14, color: Colors.white54),
              const SizedBox(width: 4),
              const Text(
                'Consider a stronger password with symbols and numbers.',
                style: TextStyle(fontSize: 11, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.delete, color: Colors.redAccent),
        label: const Text(
          'Delete Item',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
          foregroundColor: Colors.redAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
