import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/core/providers/vault_provider.dart';
import 'package:notes_vault/core/utils/password_utils.dart';
import 'package:notes_vault/features/models/vault_item.dart';
import 'package:notes_vault/features/widgets/upsert/amoled_input.dart';
import 'package:notes_vault/features/widgets/upsert/pill_chip.dart';

class AddPasswordScreen extends ConsumerStatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  ConsumerState<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends ConsumerState<AddPasswordScreen> {
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isFavorite = false;
  NoteCategory _selectedCategory = NoteCategory.work;
  PasswordStrength _passwordStrength = PasswordStrength.weak;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateStrength);
  }

  void _updateStrength() {
    setState(() {
      _passwordStrength = PasswordUtils.calculateStrength(
        _passwordController.text,
      );
    });
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updateStrength);
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final title = _titleController.text.trim();
    final password = _passwordController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Password cannot be empty')));
      return;
    }

    final now = DateTime.now();
    final item = VaultItem(
      id: '',
      type: NoteType.password,
      title: title,
      username: _usernameController.text.isEmpty
          ? null
          : _usernameController.text.trim(),
      password: password,
      websiteUrl: _urlController.text.isEmpty
          ? null
          : _urlController.text.trim(),
      content: _notesController.text.isEmpty ? null : _notesController.text,
      category: _selectedCategory,
      isFavorite: _isFavorite,
      passwordStrength: _passwordStrength,
      createdAt: now,
      updatedAt: now,
    );

    await ref.read(vaultProvider.notifier).addItem(item);

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.chevron_left,
            color: theme.colorScheme.onSurface,
            size: 28,
          ),
        ),
        title: Text(
          'New Password',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white12, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 32),
                  _buildCredentialsSection(),
                  const SizedBox(height: 32),
                  _buildDetailsSection(),
                  const SizedBox(height: 32),
                  _buildFooterSection(),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
              ),
              child: const Text(
                'Last updated: Just now',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.white54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.lock, color: Colors.white54, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: AmoledInput(
                controller: _titleController,
                hintText: 'e.g. Service Name',
                borderless: true,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: Colors.white12),
      ],
    );
  }

  Widget _buildCredentialsSection() {
    return Column(
      children: [
        AmoledInput(
          label: 'Username or Email',
          controller: _usernameController,
          hintText: 'username@example.com',
          keyboardType: TextInputType.emailAddress,
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
                  Icons.content_copy,
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
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Strong password',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade500,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.refresh,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  'GENERATE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      children: [
        AmoledInput(
          label: 'Website / URL',
          controller: _urlController,
          hintText: 'https://...',
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16),
        AmoledInput(
          label: 'Notes',
          controller: _notesController,
          hintText: 'Additional details...',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  'TAGS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors.white54,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PillChip(
                    label: 'Work',
                    isActive: _selectedCategory == NoteCategory.work,
                    onTap: () =>
                        setState(() => _selectedCategory = NoteCategory.work),
                  ),
                  PillChip(
                    label: 'Personal',
                    isActive: _selectedCategory == NoteCategory.personal,
                    onTap: () => setState(
                      () => _selectedCategory = NoteCategory.personal,
                    ),
                  ),
                  PillChip(
                    label: 'Social',
                    isActive: _selectedCategory == NoteCategory.social,
                    onTap: () =>
                        setState(() => _selectedCategory = NoteCategory.social),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white30,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'FAVORITE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.white54,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _isFavorite = !_isFavorite),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: Icon(
                  _isFavorite ? Icons.star : Icons.star_border,
                  color: _isFavorite ? Colors.amber : Colors.white54,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
