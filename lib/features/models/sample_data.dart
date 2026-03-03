import 'package:notes_vault/core/enums/db_enums.dart';
import 'vault_item.dart';

class SampleData {
  SampleData._();

  static final List<VaultItem> items = [
    // ─── PASSWORDS ───────────────────────────────────────────────────────
    VaultItem(
      id: 'pwd-001',
      type: NoteType.password,
      title: 'GitHub',
      username: 'dev_explorer',
      password: 'Gh!tHub\$ecure2024',
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
      id: 'pwd-004',
      type: NoteType.password,
      title: 'Steam',
      username: 'gamer_pro_99',
      password: 'St3amG4mer!',
      websiteUrl: 'https://store.steampowered.com',
      category: NoteCategory.entertainment,
      tags: [ItemTag.temporary],
      isTrashed: true,
      passwordStrength: PasswordStrength.fair,
      createdAt: DateTime(2023, 6, 15, 20, 0),
      updatedAt: DateTime(2024, 12, 1, 8, 0),
      lastAccessedAt: DateTime(2024, 11, 28),
    ),

    VaultItem(
      id: 'pwd-005',
      type: NoteType.password,
      title: 'AWS Console',
      username: 'admin@company.io',
      password: 'Aws\$uperSecure!2024#Root',
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
      password: 'Gm@il_Pa\$\$w0rd',
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
      id: 'pwd-007',
      type: NoteType.password,
      title: 'LinkedIn',
      username: 'john.doe@work.com',
      password: 'L1nk3d!nPr0',
      websiteUrl: 'https://linkedin.com',
      category: NoteCategory.social,
      tags: [ItemTag.shared],
      passwordStrength: PasswordStrength.strong,
      createdAt: DateTime(2023, 5, 20, 16, 30),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      lastAccessedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),

    VaultItem(
      id: 'pwd-008',
      type: NoteType.password,
      title: 'Spotify',
      username: 'music_lover_42',
      password: 'Sp0t1fy!',
      websiteUrl: 'https://accounts.spotify.com',
      category: NoteCategory.entertainment,
      tags: [],
      passwordStrength: PasswordStrength.fair,
      createdAt: DateTime(2023, 9, 8, 22, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 14)),
      lastAccessedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),

    VaultItem(
      id: 'pwd-009',
      type: NoteType.password,
      title: 'HDFC Banking Portal',
      username: 'cust_9847362510',
      password: 'B@nk!ng\$ecure99',
      websiteUrl: 'https://netbanking.hdfcbank.com',
      category: NoteCategory.finance,
      tags: [ItemTag.important, ItemTag.encrypted, ItemTag.pinned],
      isFavorite: true,
      passwordStrength: PasswordStrength.veryStrong,
      createdAt: DateTime(2022, 1, 15, 10, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),

    VaultItem(
      id: 'pwd-010',
      type: NoteType.password,
      title: 'Slack Workspace',
      username: 'john@startup.io',
      password: 'Sl@ckW0rk!',
      websiteUrl: 'https://startup-io.slack.com',
      category: NoteCategory.work,
      tags: [ItemTag.shared, ItemTag.important],
      passwordStrength: PasswordStrength.strong,
      createdAt: DateTime(2024, 1, 5, 9, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      lastAccessedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    VaultItem(
      id: 'pwd-011',
      type: NoteType.password,
      title: 'Docker Hub',
      username: 'devops_john',
      password: 'D0ck3r!Hub2024',
      websiteUrl: 'https://hub.docker.com',
      category: NoteCategory.development,
      tags: [ItemTag.encrypted],
      passwordStrength: PasswordStrength.strong,
      createdAt: DateTime(2024, 3, 12, 14, 30),
      updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      lastAccessedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),

    VaultItem(
      id: 'pwd-012',
      type: NoteType.password,
      title: 'Old Twitter Account',
      username: 'tweet_master',
      password: 'Tw1tt3r!',
      websiteUrl: 'https://x.com',
      category: NoteCategory.social,
      tags: [ItemTag.archived],
      isTrashed: true,
      passwordStrength: PasswordStrength.weak,
      createdAt: DateTime(2021, 7, 1, 18, 0),
      updatedAt: DateTime(2024, 6, 15, 12, 0),
    ),

    // ─── NOTES ─────────────────────────────────────────────────────────
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
          'Sprint 14 Review:\n- Completed user authentication module\n- Payment gateway integration 80% done\n- Dashboard redesign approved by stakeholders\n- Next sprint: focus on performance optimization\n- Action items: John to review PR #234, Sarah to update API docs\n- Blockers: Waiting on third-party API credentials from vendor',
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
          'Phase 1: Security Audit. Our primary focus is completing the comprehensive penetration testing across all cloud environments. All API endpoints must be validated against the new Zero-Trust architecture.\n\nPhase 2: Beta Launch. Scheduled for late Q3. We will invite the first cohort of 500 power users to test the stability of the core ledger components.\n\nPhase 3: Public Release. Following the audit and successful beta feedback loops, the global rollout will begin. Final localization for 12 languages is currently underway.',
      category: NoteCategory.work,
      tags: [ItemTag.important, ItemTag.encrypted, ItemTag.pinned],
      isFavorite: true,
      createdAt: DateTime(2024, 2, 15, 10, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),

    VaultItem(
      id: 'note-004',
      type: NoteType.note,
      title: 'Travel Itinerary - Goa Trip',
      content:
          'Day 1: Arrive at Dabolim Airport, check-in at Radisson Blu\nDay 2: North Goa beaches - Baga, Calangute, Anjuna\nDay 3: Old Goa heritage walk, Se Cathedral, Basilica of Bom Jesus\nDay 4: Dudhsagar Falls trekking, spice plantation visit\nDay 5: South Goa - Palolem Beach, Cabo de Rama Fort\nDay 6: Water sports at Dona Paula, departure\n\nFlight: AI-442, 6:30 AM\nHotel booking ref: RAD-GOA-78923',
      category: NoteCategory.travel,
      tags: [ItemTag.temporary, ItemTag.important],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),

    VaultItem(
      id: 'note-005',
      type: NoteType.note,
      title: 'API Keys Reference',
      content:
          'Firebase: AIzaSyD-XXXXX-REDACTED\nStripe Test: sk_test_XXXXX-REDACTED\nSendGrid: SG.XXXXX-REDACTED\nGoogle Maps: AIzaSyC-XXXXX-REDACTED\nTwilio SID: AC-XXXXX-REDACTED\n\nNOTE: Production keys are in the team 1Password vault. These are dev/staging only.',
      category: NoteCategory.development,
      tags: [ItemTag.encrypted, ItemTag.important, ItemTag.pinned],
      isFavorite: true,
      createdAt: DateTime(2024, 1, 20, 11, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),

    VaultItem(
      id: 'note-006',
      type: NoteType.note,
      title: 'Workout Plan',
      content:
          'Monday: Chest + Triceps (Bench press 4x8, Incline DB press 3x10, Cable flyes 3x12, Tricep dips 3x12, Overhead extension 3x10)\nTuesday: Back + Biceps (Deadlift 4x6, Lat pulldown 3x10, Barbell rows 3x8, Hammer curls 3x12, Preacher curl 3x10)\nWednesday: Rest / Light cardio\nThursday: Shoulders + Abs (OHP 4x8, Lateral raises 3x15, Face pulls 3x12, Planks 3x60s, Hanging leg raises 3x12)\nFriday: Legs (Squats 4x8, Leg press 3x10, RDLs 3x10, Leg curls 3x12, Calf raises 4x15)\nWeekend: Active recovery / Sports',
      category: NoteCategory.health,
      tags: [ItemTag.pinned],
      createdAt: DateTime(2024, 3, 1, 7, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    VaultItem(
      id: 'note-007',
      type: NoteType.note,
      title: 'Book Recommendations',
      content:
          '1. "Atomic Habits" by James Clear - Building better habits\n2. "Clean Code" by Robert C. Martin - Must read for devs\n3. "The Pragmatic Programmer" by Hunt & Thomas\n4. "Deep Work" by Cal Newport - Focus strategies\n5. "System Design Interview" by Alex Xu\n6. "Sapiens" by Yuval Noah Harari\n7. "The Psychology of Money" by Morgan Housel\n8. "Designing Data-Intensive Applications" by Martin Kleppmann',
      category: NoteCategory.personal,
      tags: [ItemTag.archived],
      createdAt: DateTime(2023, 12, 10, 20, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),

    VaultItem(
      id: 'note-008',
      type: NoteType.note,
      title: 'Recipe - Butter Chicken',
      content:
          'Ingredients: 500g chicken thighs, 2 cups tomato puree, 1 cup cream, butter 50g, ginger-garlic paste, garam masala, kasuri methi, red chili powder, salt, sugar\n\nMarinate chicken in yogurt + spices for 2 hrs.\nGrill or pan-sear chicken until charred.\nMake gravy: Butter → onions → ginger-garlic → tomatoes → spices → cream.\nAdd chicken, simmer 15 min. Finish with kasuri methi & butter.\n\nServe with naan or jeera rice.',
      category: NoteCategory.personal,
      tags: [ItemTag.pinned],
      isFavorite: true,
      createdAt: DateTime(2024, 1, 8, 19, 0),
      updatedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),

    VaultItem(
      id: 'note-009',
      type: NoteType.note,
      title: 'Deleted Draft - Old Resume',
      content: 'Outdated resume content from 2022. No longer relevant.',
      category: NoteCategory.work,
      tags: [ItemTag.archived],
      isTrashed: true,
      createdAt: DateTime(2022, 5, 1, 10, 0),
      updatedAt: DateTime(2024, 8, 20, 14, 0),
    ),
  ];

  /// All non-trashed items.
  static List<VaultItem> get activeItems =>
      items.where((item) => !item.isTrashed).toList();

  /// All favorited (non-trashed) items.
  static List<VaultItem> get favoriteItems =>
      activeItems.where((item) => item.isFavorite).toList();

  /// All trashed items.
  static List<VaultItem> get trashedItems =>
      items.where((item) => item.isTrashed).toList();

  /// All passwords (non-trashed).
  static List<VaultItem> get passwordItems =>
      activeItems.where((item) => item.isPassword).toList();

  /// All notes (non-trashed).
  static List<VaultItem> get noteItems =>
      activeItems.where((item) => item.isNote).toList();

  /// The N most recently updated active items.
  static List<VaultItem> recentItems({int count = 5}) {
    final sorted = List<VaultItem>.from(activeItems)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted.take(count).toList();
  }

  /// All unique tags present in active items.
  static Set<ItemTag> get allActiveTags {
    final tags = <ItemTag>{};
    for (final item in activeItems) {
      tags.addAll(item.tags);
    }
    return tags;
  }

  /// Password count.
  static int get passwordCount => passwordItems.length;

  /// Note count.
  static int get noteCount => noteItems.length;

  /// Favorite count.
  static int get favoriteCount => favoriteItems.length;

  /// Trash count.
  static int get trashCount => trashedItems.length;
}
