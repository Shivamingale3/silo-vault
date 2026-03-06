import 'package:flutter/material.dart';
import 'package:notes_vault/core/security/encryption_service.dart';
import 'package:notes_vault/database/models/vault_item_entity.dart';
import 'package:notes_vault/database/vault_repository.dart';

class DbViewerScreen extends StatefulWidget {
  const DbViewerScreen({super.key});

  @override
  State<DbViewerScreen> createState() => _DbViewerScreenState();
}

class _DbViewerScreenState extends State<DbViewerScreen> {
  List<VaultItemEntity> _entities = [];
  bool _isLoading = true;
  final Set<int> _expanded = {};
  final Map<String, String> _decryptedCache = {};

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  String? _error;

  Future<void> _loadEntities() async {
    try {
      final repo = VaultRepository();
      final entities = await repo.getAllRawEntities();
      if (!mounted) return;
      setState(() {
        _entities = entities;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<String> _decryptField(String ciphertext) async {
    if (_decryptedCache.containsKey(ciphertext)) {
      return _decryptedCache[ciphertext]!;
    }
    try {
      final plain = await EncryptionService.decrypt(ciphertext);
      _decryptedCache[ciphertext] = plain;
      return plain;
    } catch (e) {
      return '[DECRYPTION ERROR]';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          'Database Viewer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(
                '${_entities.length} entries',
                style: TextStyle(fontSize: 12, color: colorScheme.primary),
              ),
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Failed to load database',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : _entities.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.storage_outlined,
                    size: 48,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Database is empty',
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _entities.length,
              itemBuilder: (context, index) {
                try {
                  return _buildEntityCard(context, _entities[index], index);
                } catch (e) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Error rendering entry $index: $e',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }

  Widget _buildEntityCard(
    BuildContext context,
    VaultItemEntity entity,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isExpanded = _expanded.contains(index);

    final typeColor = entity.type == NoteTypeEnum.password
        ? Colors.orange
        : Colors.teal;

    return Card(
      color: colorScheme.surfaceContainer,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() {
          if (isExpanded) {
            _expanded.remove(index);
          } else {
            _expanded.add(index);
          }
        }),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row ──
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      entity.type.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ID: ${entity.itemId.length > 8 ? '${entity.itemId.substring(0, 8)}…' : entity.itemId}',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ),
                  if (entity.isFavorite)
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                  if (entity.isTrashed)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.delete, size: 14, color: Colors.red),
                    ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),

              // ── Encrypted title preview ──
              if (entity.encryptedTitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  entity.encryptedTitle!.length > 50
                      ? '${entity.encryptedTitle!.substring(0, 50)}…'
                      : entity.encryptedTitle!,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: Colors.red.shade300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // ── Expanded Details ──
              if (isExpanded) ...[
                const Divider(height: 20),
                _buildFieldRow(context, 'isarId', entity.isarId.toString()),
                _buildFieldRow(context, 'itemId', entity.itemId),
                _buildFieldRow(context, 'type', entity.type.name),
                _buildEncryptedField(
                  context,
                  'encryptedTitle',
                  entity.encryptedTitle,
                ),
                _buildEncryptedField(
                  context,
                  'encryptedContent',
                  entity.encryptedContent,
                ),
                _buildEncryptedField(
                  context,
                  'encryptedUsername',
                  entity.encryptedUsername,
                ),
                _buildEncryptedField(
                  context,
                  'encryptedPassword',
                  entity.encryptedPassword,
                ),
                _buildEncryptedField(
                  context,
                  'encryptedWebsiteUrl',
                  entity.encryptedWebsiteUrl,
                ),
                _buildFieldRow(context, 'category', entity.category.name),
                _buildFieldRow(context, 'tags', entity.tags.join(', ')),
                _buildFieldRow(
                  context,
                  'isFavorite',
                  entity.isFavorite.toString(),
                ),
                _buildFieldRow(
                  context,
                  'isTrashed',
                  entity.isTrashed.toString(),
                ),
                _buildFieldRow(
                  context,
                  'passwordStrength',
                  entity.passwordStrength?.name ?? 'null',
                ),
                _buildFieldRow(
                  context,
                  'createdAt',
                  entity.createdAt.toIso8601String(),
                ),
                _buildFieldRow(
                  context,
                  'updatedAt',
                  entity.updatedAt.toIso8601String(),
                ),
                _buildFieldRow(
                  context,
                  'lastAccessedAt',
                  entity.lastAccessedAt?.toIso8601String() ?? 'null',
                ),
                _buildFieldRow(context, 'isDirty', entity.isDirty.toString()),
                _buildFieldRow(
                  context,
                  'lastSyncedAt',
                  entity.lastSyncedAt?.toIso8601String() ?? 'null',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'null' : value,
              style: TextStyle(
                fontSize: 11,
                fontFamily: label.contains('Id') ? 'monospace' : null,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncryptedField(
    BuildContext context,
    String label,
    String? ciphertext,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    if (ciphertext == null) {
      return _buildFieldRow(context, label, 'null');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 130,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade300,
                  ),
                ),
              ),
              const Icon(Icons.lock, size: 10, color: Colors.red),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  ciphertext.length > 40
                      ? '${ciphertext.substring(0, 40)}…'
                      : ciphertext,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: Colors.red.shade300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Decrypt button
          Padding(
            padding: const EdgeInsets.only(left: 130, top: 2, bottom: 2),
            child: GestureDetector(
              onTap: () async {
                final decrypted = await _decryptField(ciphertext);
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: colorScheme.surfaceContainer,
                      title: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      content: SelectableText(
                        decrypted,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(
                'Tap to decrypt →',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
