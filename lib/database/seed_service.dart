import 'package:notes_vault/core/enums/db_enums.dart';
import 'package:notes_vault/database/vault_repository.dart';
import 'package:notes_vault/features/models/vault_item.dart';

/// Seeds the DB with sample data on first launch.
/// Entire operation runs in a single batch for atomicity.
class SeedService {
  static Future<void> seedIfEmpty() async {
    final repo = VaultRepository();
    final count = await repo.getItemCount();
    if (count > 0) return;

    await repo.addAllItems(_sampleItems);
  }

  static final List<VaultItem> _sampleItems = [
    // ─── PASSWORDS ───
    VaultItem(
      id: 'pwd-001',
      type: NoteType.password,
      title: 'GitHub',
      username: 'dev_explorer',
      password: r'Gh!tHub$ecure2024',
      websiteUrl: 'https://github.com/login',
      category: NoteCategory.development,
      tags: [ItemTag.important, ItemTag.pinned],
      isFavorite: true,
      passwordStrength: PasswordStrength.veryStrong,
      createdAt: DateTime(2024, 1, 12, 9, 30),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      lastAccessedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    VaultItem(
      id: 'pwd-002',
      type: NoteType.password,
      title: 'Netflix',
      username: 'movie_buff@gmail.com',
      password: 'N3tfl!xPr0',
      websiteUrl: 'https://netflix.com',
      category: NoteCategory.entertainment,
      tags: [ItemTag.shared],
      isFavorite: true,
      passwordStrength: PasswordStrength.strong,
      createdAt: DateTime(2023, 11, 5, 14, 0),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    VaultItem(
      id: 'pwd-003',
      type: NoteType.password,
      title: 'Adobe Creative Cloud',
      username: 'design@studio.com',
      password: 'Ad0beCC!2024',
      websiteUrl: 'https://account.adobe.com',
      category: NoteCategory.work,
      tags: [ItemTag.important, ItemTag.encrypted],
      isFavorite: true,
      passwordStrength: PasswordStrength.strong,
      createdAt: DateTime(2023, 8, 22, 10, 15),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      lastAccessedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    VaultItem(
      id: 'pwd-005',
      type: NoteType.password,
      title: 'AWS Console',
      username: 'admin@company.io',
      password: r'Aws$uperSecure!2024#Root',
      websiteUrl: 'https://console.aws.amazon.com',
      category: NoteCategory.development,
      tags: [ItemTag.important, ItemTag.encrypted, ItemTag.pinned],
      isFavorite: true,
      passwordStrength: PasswordStrength.veryStrong,
      createdAt: DateTime(2024, 2, 1, 8, 0),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    VaultItem(
      id: 'pwd-006',
      type: NoteType.password,
      title: 'Gmail',
      username: 'user.primary@gmail.com',
      password: r'Gm@il_Pa$$w0rd',
      websiteUrl: 'https://mail.google.com',
      category: NoteCategory.personal,
      tags: [ItemTag.important],
      isFavorite: true,
      passwordStrength: PasswordStrength.strong,
      createdAt: DateTime(2022, 3, 10, 12, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    VaultItem(
      id: 'pwd-009',
      type: NoteType.password,
      title: 'HDFC Banking Portal',
      username: 'cust_9847362510',
      password: r'B@nk!ng$ecure99',
      websiteUrl: 'https://netbanking.hdfcbank.com',
      category: NoteCategory.finance,
      tags: [ItemTag.important, ItemTag.encrypted, ItemTag.pinned],
      isFavorite: true,
      passwordStrength: PasswordStrength.veryStrong,
      createdAt: DateTime(2022, 1, 15, 10, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    // ─── NOTES ───
    VaultItem(
      id: 'note-001',
      type: NoteType.note,
      title: 'Grocery List',
      content:
          'Milk, Eggs, Bread, Butter, Cheese, Tomatoes, Onions, Garlic, Pasta, Olive Oil, Chicken breast, Rice, Yogurt, Bananas, Apples, Spinach, Bell peppers',
      category: NoteCategory.personal,
      tags: [ItemTag.temporary],
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    VaultItem(
      id: 'note-002',
      type: NoteType.note,
      title: 'Meeting Notes - Sprint Review',
      content:
          'Sprint 14 Review:\n- Completed user authentication module\n- Payment gateway integration 80% done\n- Dashboard redesign approved by stakeholders\n- Next sprint: focus on performance optimization',
      category: NoteCategory.work,
      tags: [ItemTag.important, ItemTag.pinned],
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    VaultItem(
      id: 'note-003',
      type: NoteType.note,
      title: 'Project Alpha Roadmap',
      content:
          'Phase 1: Security Audit. Our primary focus is completing the comprehensive penetration testing across all cloud environments.\n\nPhase 2: Beta Launch. Scheduled for late Q3.\n\nPhase 3: Public Release. Following the audit and successful beta feedback loops.',
      category: NoteCategory.work,
      tags: [ItemTag.important, ItemTag.encrypted, ItemTag.pinned],
      isFavorite: true,
      createdAt: DateTime(2024, 2, 15, 10, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    VaultItem(
      id: 'note-005',
      type: NoteType.note,
      title: 'API Keys Reference',
      content:
          'Firebase: AIzaSyD-XXXXX-REDACTED\nStripe Test: sk_test_XXXXX-REDACTED\nSendGrid: SG.XXXXX-REDACTED\n\nNOTE: Production keys are in the team 1Password vault.',
      category: NoteCategory.development,
      tags: [ItemTag.encrypted, ItemTag.important, ItemTag.pinned],
      isFavorite: true,
      createdAt: DateTime(2024, 1, 20, 11, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];
}
