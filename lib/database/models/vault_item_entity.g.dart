// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: experimental_member_use

part of 'vault_item_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVaultItemEntityCollection on Isar {
  IsarCollection<VaultItemEntity> get vaultItemEntitys => this.collection();
}

const VaultItemEntitySchema = CollectionSchema(
  name: r'VaultItemEntity',
  id: -8764594082228729346,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
      enumMap: _VaultItemEntitycategoryEnumValueMap,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'encryptedContent': PropertySchema(
      id: 2,
      name: r'encryptedContent',
      type: IsarType.string,
    ),
    r'encryptedPassword': PropertySchema(
      id: 3,
      name: r'encryptedPassword',
      type: IsarType.string,
    ),
    r'encryptedTitle': PropertySchema(
      id: 4,
      name: r'encryptedTitle',
      type: IsarType.string,
    ),
    r'encryptedUsername': PropertySchema(
      id: 5,
      name: r'encryptedUsername',
      type: IsarType.string,
    ),
    r'encryptedWebsiteUrl': PropertySchema(
      id: 6,
      name: r'encryptedWebsiteUrl',
      type: IsarType.string,
    ),
    r'isDirty': PropertySchema(id: 7, name: r'isDirty', type: IsarType.bool),
    r'isFavorite': PropertySchema(
      id: 8,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'isTrashed': PropertySchema(
      id: 9,
      name: r'isTrashed',
      type: IsarType.bool,
    ),
    r'itemId': PropertySchema(id: 10, name: r'itemId', type: IsarType.string),
    r'lastAccessedAt': PropertySchema(
      id: 11,
      name: r'lastAccessedAt',
      type: IsarType.dateTime,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 12,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'passwordStrength': PropertySchema(
      id: 13,
      name: r'passwordStrength',
      type: IsarType.string,
      enumMap: _VaultItemEntitypasswordStrengthEnumValueMap,
    ),
    r'tags': PropertySchema(id: 14, name: r'tags', type: IsarType.stringList),
    r'type': PropertySchema(
      id: 15,
      name: r'type',
      type: IsarType.string,
      enumMap: _VaultItemEntitytypeEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _vaultItemEntityEstimateSize,
  serialize: _vaultItemEntitySerialize,
  deserialize: _vaultItemEntityDeserialize,
  deserializeProp: _vaultItemEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'itemId': IndexSchema(
      id: -5342806140158601489,
      name: r'itemId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'itemId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'type': IndexSchema(
      id: 5117122708147080838,
      name: r'type',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'isFavorite': IndexSchema(
      id: 5742774614603939776,
      name: r'isFavorite',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isFavorite',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'isTrashed': IndexSchema(
      id: 3056854837835265747,
      name: r'isTrashed',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isTrashed',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _vaultItemEntityGetId,
  getLinks: _vaultItemEntityGetLinks,
  attach: _vaultItemEntityAttach,
  version: '3.3.0',
);

int _vaultItemEntityEstimateSize(
  VaultItemEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.name.length * 3;
  {
    final value = object.encryptedContent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encryptedPassword;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encryptedTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encryptedUsername;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.encryptedWebsiteUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.itemId.length * 3;
  {
    final value = object.passwordStrength;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.type.name.length * 3;
  return bytesCount;
}

void _vaultItemEntitySerialize(
  VaultItemEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category.name);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.encryptedContent);
  writer.writeString(offsets[3], object.encryptedPassword);
  writer.writeString(offsets[4], object.encryptedTitle);
  writer.writeString(offsets[5], object.encryptedUsername);
  writer.writeString(offsets[6], object.encryptedWebsiteUrl);
  writer.writeBool(offsets[7], object.isDirty);
  writer.writeBool(offsets[8], object.isFavorite);
  writer.writeBool(offsets[9], object.isTrashed);
  writer.writeString(offsets[10], object.itemId);
  writer.writeDateTime(offsets[11], object.lastAccessedAt);
  writer.writeDateTime(offsets[12], object.lastSyncedAt);
  writer.writeString(offsets[13], object.passwordStrength?.name);
  writer.writeStringList(offsets[14], object.tags);
  writer.writeString(offsets[15], object.type.name);
  writer.writeDateTime(offsets[16], object.updatedAt);
}

VaultItemEntity _vaultItemEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VaultItemEntity(
    encryptedContent: reader.readStringOrNull(offsets[2]),
    encryptedPassword: reader.readStringOrNull(offsets[3]),
    encryptedTitle: reader.readStringOrNull(offsets[4]),
    encryptedUsername: reader.readStringOrNull(offsets[5]),
    encryptedWebsiteUrl: reader.readStringOrNull(offsets[6]),
    isDirty: reader.readBoolOrNull(offsets[7]) ?? true,
    isFavorite: reader.readBoolOrNull(offsets[8]) ?? false,
    isTrashed: reader.readBoolOrNull(offsets[9]) ?? false,
    lastAccessedAt: reader.readDateTimeOrNull(offsets[11]),
    lastSyncedAt: reader.readDateTimeOrNull(offsets[12]),
    passwordStrength:
        _VaultItemEntitypasswordStrengthValueEnumMap[reader.readStringOrNull(
          offsets[13],
        )],
    tags: reader.readStringList(offsets[14]) ?? const [],
  );
  object.category =
      _VaultItemEntitycategoryValueEnumMap[reader.readStringOrNull(
        offsets[0],
      )] ??
      NoteCategoryEnum.personal;
  object.createdAt = reader.readDateTime(offsets[1]);
  object.isarId = id;
  object.itemId = reader.readString(offsets[10]);
  object.type =
      _VaultItemEntitytypeValueEnumMap[reader.readStringOrNull(offsets[15])] ??
      NoteTypeEnum.note;
  object.updatedAt = reader.readDateTime(offsets[16]);
  return object;
}

P _vaultItemEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_VaultItemEntitycategoryValueEnumMap[reader.readStringOrNull(
                offset,
              )] ??
              NoteCategoryEnum.personal)
          as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 9:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (_VaultItemEntitypasswordStrengthValueEnumMap[reader
              .readStringOrNull(offset)])
          as P;
    case 14:
      return (reader.readStringList(offset) ?? const []) as P;
    case 15:
      return (_VaultItemEntitytypeValueEnumMap[reader.readStringOrNull(
                offset,
              )] ??
              NoteTypeEnum.note)
          as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _VaultItemEntitycategoryEnumValueMap = {
  r'personal': r'personal',
  r'work': r'work',
  r'finance': r'finance',
  r'social': r'social',
  r'development': r'development',
  r'entertainment': r'entertainment',
  r'travel': r'travel',
  r'health': r'health',
};
const _VaultItemEntitycategoryValueEnumMap = {
  r'personal': NoteCategoryEnum.personal,
  r'work': NoteCategoryEnum.work,
  r'finance': NoteCategoryEnum.finance,
  r'social': NoteCategoryEnum.social,
  r'development': NoteCategoryEnum.development,
  r'entertainment': NoteCategoryEnum.entertainment,
  r'travel': NoteCategoryEnum.travel,
  r'health': NoteCategoryEnum.health,
};
const _VaultItemEntitypasswordStrengthEnumValueMap = {
  r'weak': r'weak',
  r'fair': r'fair',
  r'strong': r'strong',
  r'veryStrong': r'veryStrong',
};
const _VaultItemEntitypasswordStrengthValueEnumMap = {
  r'weak': PasswordStrengthEnum.weak,
  r'fair': PasswordStrengthEnum.fair,
  r'strong': PasswordStrengthEnum.strong,
  r'veryStrong': PasswordStrengthEnum.veryStrong,
};
const _VaultItemEntitytypeEnumValueMap = {
  r'note': r'note',
  r'password': r'password',
};
const _VaultItemEntitytypeValueEnumMap = {
  r'note': NoteTypeEnum.note,
  r'password': NoteTypeEnum.password,
};

Id _vaultItemEntityGetId(VaultItemEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _vaultItemEntityGetLinks(VaultItemEntity object) {
  return [];
}

void _vaultItemEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  VaultItemEntity object,
) {
  object.isarId = id;
}

extension VaultItemEntityByIndex on IsarCollection<VaultItemEntity> {
  Future<VaultItemEntity?> getByItemId(String itemId) {
    return getByIndex(r'itemId', [itemId]);
  }

  VaultItemEntity? getByItemIdSync(String itemId) {
    return getByIndexSync(r'itemId', [itemId]);
  }

  Future<bool> deleteByItemId(String itemId) {
    return deleteByIndex(r'itemId', [itemId]);
  }

  bool deleteByItemIdSync(String itemId) {
    return deleteByIndexSync(r'itemId', [itemId]);
  }

  Future<List<VaultItemEntity?>> getAllByItemId(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'itemId', values);
  }

  List<VaultItemEntity?> getAllByItemIdSync(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'itemId', values);
  }

  Future<int> deleteAllByItemId(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'itemId', values);
  }

  int deleteAllByItemIdSync(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'itemId', values);
  }

  Future<Id> putByItemId(VaultItemEntity object) {
    return putByIndex(r'itemId', object);
  }

  Id putByItemIdSync(VaultItemEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'itemId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByItemId(List<VaultItemEntity> objects) {
    return putAllByIndex(r'itemId', objects);
  }

  List<Id> putAllByItemIdSync(
    List<VaultItemEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'itemId', objects, saveLinks: saveLinks);
  }
}

extension VaultItemEntityQueryWhereSort
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QWhere> {
  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhere> anyIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isFavorite'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhere> anyIsTrashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isTrashed'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension VaultItemEntityQueryWhere
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QWhereClause> {
  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  itemIdEqualTo(String itemId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'itemId', value: [itemId]),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  itemIdNotEqualTo(String itemId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'itemId',
                lower: [],
                upper: [itemId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'itemId',
                lower: [itemId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'itemId',
                lower: [itemId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'itemId',
                lower: [],
                upper: [itemId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause> typeEqualTo(
    NoteTypeEnum type,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'type', value: [type]),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  typeNotEqualTo(NoteTypeEnum type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [],
                upper: [type],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [type],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [type],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'type',
                lower: [],
                upper: [type],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  categoryEqualTo(NoteCategoryEnum category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'category', value: [category]),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  categoryNotEqualTo(NoteCategoryEnum category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isFavoriteEqualTo(bool isFavorite) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isFavorite', value: [isFavorite]),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isFavoriteNotEqualTo(bool isFavorite) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [],
                upper: [isFavorite],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [isFavorite],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [isFavorite],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [],
                upper: [isFavorite],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isTrashedEqualTo(bool isTrashed) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isTrashed', value: [isTrashed]),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  isTrashedNotEqualTo(bool isTrashed) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isTrashed',
                lower: [],
                upper: [isTrashed],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isTrashed',
                lower: [isTrashed],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isTrashed',
                lower: [isTrashed],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isTrashed',
                lower: [],
                upper: [isTrashed],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'updatedAt', value: [updatedAt]),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [],
                upper: [updatedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [updatedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [updatedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [],
                upper: [updatedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  updatedAtGreaterThan(DateTime updatedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [updatedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  updatedAtLessThan(DateTime updatedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [],
          upper: [updatedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterWhereClause>
  updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [lowerUpdatedAt],
          includeLower: includeLower,
          upper: [upperUpdatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension VaultItemEntityQueryFilter
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QFilterCondition> {
  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryEqualTo(NoteCategoryEnum value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryGreaterThan(
    NoteCategoryEnum value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryLessThan(
    NoteCategoryEnum value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryBetween(
    NoteCategoryEnum lower,
    NoteCategoryEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'encryptedContent'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'encryptedContent'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedContent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedContent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedContent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedContent',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedContent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedContent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedContent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedContent',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedContent', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedContent', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'encryptedPassword'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'encryptedPassword'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedPassword',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedPassword',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedPassword',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedPassword',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedPassword',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedPassword',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedPassword',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedPassword',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedPassword', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedPasswordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedPassword', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'encryptedTitle'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'encryptedTitle'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedTitle', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedTitle', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'encryptedUsername'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'encryptedUsername'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedUsername',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedUsername',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedUsername', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'encryptedUsername', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'encryptedWebsiteUrl'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'encryptedWebsiteUrl'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedWebsiteUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedWebsiteUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedWebsiteUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedWebsiteUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedWebsiteUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedWebsiteUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedWebsiteUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedWebsiteUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedWebsiteUrl', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  encryptedWebsiteUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'encryptedWebsiteUrl',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  isDirtyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isDirty', value: value),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFavorite', value: value),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  isTrashedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isTrashed', value: value),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'itemId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemId', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  itemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'itemId', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastAccessedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastAccessedAt'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastAccessedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastAccessedAt'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastAccessedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastAccessedAt', value: value),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastAccessedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastAccessedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastAccessedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastAccessedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastAccessedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastAccessedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSyncedAt'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSyncedAt'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSyncedAt', value: value),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastSyncedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSyncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastSyncedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSyncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSyncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'passwordStrength'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'passwordStrength'),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthEqualTo(
    PasswordStrengthEnum? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'passwordStrength',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthGreaterThan(
    PasswordStrengthEnum? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'passwordStrength',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthLessThan(
    PasswordStrengthEnum? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'passwordStrength',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthBetween(
    PasswordStrengthEnum? lower,
    PasswordStrengthEnum? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'passwordStrength',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'passwordStrength',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'passwordStrength',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'passwordStrength',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'passwordStrength',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'passwordStrength', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  passwordStrengthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'passwordStrength', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tags',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tags',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, true, length, true);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, 0, true);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, false, 999999, true);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, length, include);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, include, 999999, true);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeEqualTo(NoteTypeEnum value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeGreaterThan(
    NoteTypeEnum value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeLessThan(
    NoteTypeEnum value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeBetween(
    NoteTypeEnum lower,
    NoteTypeEnum upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'type',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'type',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'type', value: ''),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension VaultItemEntityQueryObject
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QFilterCondition> {}

extension VaultItemEntityQueryLinks
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QFilterCondition> {}

extension VaultItemEntityQuerySortBy
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QSortBy> {
  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedContent', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedContent', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPassword', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPassword', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedTitle', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedTitle', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedUsername', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedUsername', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedWebsiteUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedWebsiteUrl', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByEncryptedWebsiteUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedWebsiteUrl', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy> sortByIsDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDirty', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByIsDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDirty', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByIsTrashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTrashed', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByIsTrashedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTrashed', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy> sortByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByLastAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccessedAt', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByLastAccessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccessedAt', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByPasswordStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordStrength', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByPasswordStrengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordStrength', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension VaultItemEntityQuerySortThenBy
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QSortThenBy> {
  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedContent', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedContent', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPassword', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPassword', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedTitle', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedTitle', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedUsername', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedUsername', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedWebsiteUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedWebsiteUrl', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByEncryptedWebsiteUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedWebsiteUrl', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy> thenByIsDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDirty', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByIsDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDirty', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByIsTrashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTrashed', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByIsTrashedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTrashed', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy> thenByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByLastAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccessedAt', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByLastAccessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccessedAt', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByPasswordStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordStrength', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByPasswordStrengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordStrength', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension VaultItemEntityQueryWhereDistinct
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct> {
  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct> distinctByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByEncryptedContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedContent',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByEncryptedPassword({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedPassword',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByEncryptedTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedTitle',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByEncryptedUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedUsername',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByEncryptedWebsiteUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedWebsiteUrl',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByIsDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDirty');
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByIsTrashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTrashed');
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct> distinctByItemId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByLastAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAccessedAt');
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByPasswordStrength({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'passwordStrength',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct> distinctByType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VaultItemEntity, VaultItemEntity, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension VaultItemEntityQueryProperty
    on QueryBuilder<VaultItemEntity, VaultItemEntity, QQueryProperty> {
  QueryBuilder<VaultItemEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<VaultItemEntity, NoteCategoryEnum, QQueryOperations>
  categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<VaultItemEntity, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<VaultItemEntity, String?, QQueryOperations>
  encryptedContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedContent');
    });
  }

  QueryBuilder<VaultItemEntity, String?, QQueryOperations>
  encryptedPasswordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedPassword');
    });
  }

  QueryBuilder<VaultItemEntity, String?, QQueryOperations>
  encryptedTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedTitle');
    });
  }

  QueryBuilder<VaultItemEntity, String?, QQueryOperations>
  encryptedUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedUsername');
    });
  }

  QueryBuilder<VaultItemEntity, String?, QQueryOperations>
  encryptedWebsiteUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedWebsiteUrl');
    });
  }

  QueryBuilder<VaultItemEntity, bool, QQueryOperations> isDirtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDirty');
    });
  }

  QueryBuilder<VaultItemEntity, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<VaultItemEntity, bool, QQueryOperations> isTrashedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTrashed');
    });
  }

  QueryBuilder<VaultItemEntity, String, QQueryOperations> itemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemId');
    });
  }

  QueryBuilder<VaultItemEntity, DateTime?, QQueryOperations>
  lastAccessedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAccessedAt');
    });
  }

  QueryBuilder<VaultItemEntity, DateTime?, QQueryOperations>
  lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<VaultItemEntity, PasswordStrengthEnum?, QQueryOperations>
  passwordStrengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordStrength');
    });
  }

  QueryBuilder<VaultItemEntity, List<String>, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<VaultItemEntity, NoteTypeEnum, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<VaultItemEntity, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
