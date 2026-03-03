import 'package:notes_vault/core/enums/db_enums.dart';

class VaultItem {
  final String id;
  final NoteType type;
  final String title;
  final String? content;
  final String? username;
  final String? password;
  final String? websiteUrl;
  final NoteCategory category;
  final List<ItemTag> tags;
  bool isFavorite;
  bool isTrashed;
  final PasswordStrength? passwordStrength;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastAccessedAt;

  VaultItem({
    required this.id,
    required this.type,
    required this.title,
    this.content,
    this.username,
    this.password,
    this.websiteUrl,
    required this.category,
    this.tags = const [],
    this.isFavorite = false,
    this.isTrashed = false,
    this.passwordStrength,
    required this.createdAt,
    required this.updatedAt,
    this.lastAccessedAt,
  });

  bool get isNote => type == NoteType.note;
  bool get isPassword => type == NoteType.password;

  /// Returns a human-readable "time ago" string for the last update.
  String get timeAgoUpdated => _timeAgo(updatedAt);

  /// Returns a human-readable "time ago" string for the creation date.
  String get timeAgoCreated => _timeAgo(createdAt);

  /// The subtitle shown on list tiles — username for passwords, content preview for notes.
  String get displaySubtitle {
    if (isPassword) return username ?? '';
    final text = content ?? '';
    return text.length > 50 ? '${text.substring(0, 50)}...' : text;
  }

  /// Checks if this item matches a search query (case-insensitive).
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) ||
        (content?.toLowerCase().contains(q) ?? false) ||
        (username?.toLowerCase().contains(q) ?? false) ||
        (websiteUrl?.toLowerCase().contains(q) ?? false) ||
        category.name.toLowerCase().contains(q);
  }

  /// Checks if this item has any of the given tags.
  bool hasAnyTag(Set<ItemTag> selectedTags) {
    if (selectedTags.isEmpty) return true;
    return tags.any((tag) => selectedTags.contains(tag));
  }

  static String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }
}
