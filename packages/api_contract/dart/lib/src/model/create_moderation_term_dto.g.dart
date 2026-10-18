// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_moderation_term_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateModerationTermDtoCWProxy {
  CreateModerationTermDto term(String term);

  CreateModerationTermDto kind(CreateModerationTermDtoKindEnum kind);

  CreateModerationTermDto category(
    CreateModerationTermDtoCategoryEnum category,
  );

  CreateModerationTermDto note(String? note);

  CreateModerationTermDto reason(String? reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateModerationTermDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateModerationTermDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateModerationTermDto call({
    String term,
    CreateModerationTermDtoKindEnum kind,
    CreateModerationTermDtoCategoryEnum category,
    String? note,
    String? reason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateModerationTermDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateModerationTermDto.copyWith.fieldName(...)`
class _$CreateModerationTermDtoCWProxyImpl
    implements _$CreateModerationTermDtoCWProxy {
  const _$CreateModerationTermDtoCWProxyImpl(this._value);

  final CreateModerationTermDto _value;

  @override
  CreateModerationTermDto term(String term) => this(term: term);

  @override
  CreateModerationTermDto kind(CreateModerationTermDtoKindEnum kind) =>
      this(kind: kind);

  @override
  CreateModerationTermDto category(
    CreateModerationTermDtoCategoryEnum category,
  ) => this(category: category);

  @override
  CreateModerationTermDto note(String? note) => this(note: note);

  @override
  CreateModerationTermDto reason(String? reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateModerationTermDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateModerationTermDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateModerationTermDto call({
    Object? term = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return CreateModerationTermDto(
      term: term == const $CopyWithPlaceholder()
          ? _value.term
          // ignore: cast_nullable_to_non_nullable
          : term as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as CreateModerationTermDtoKindEnum,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as CreateModerationTermDtoCategoryEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String?,
    );
  }
}

extension $CreateModerationTermDtoCopyWith on CreateModerationTermDto {
  /// Returns a callable class that can be used as follows: `instanceOfCreateModerationTermDto.copyWith(...)` or like so:`instanceOfCreateModerationTermDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateModerationTermDtoCWProxy get copyWith =>
      _$CreateModerationTermDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateModerationTermDto _$CreateModerationTermDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateModerationTermDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['term', 'kind', 'category']);
  final val = CreateModerationTermDto(
    term: $checkedConvert('term', (v) => v as String),
    kind: $checkedConvert(
      'kind',
      (v) => $enumDecode(_$CreateModerationTermDtoKindEnumEnumMap, v),
    ),
    category: $checkedConvert(
      'category',
      (v) => $enumDecode(_$CreateModerationTermDtoCategoryEnumEnumMap, v),
    ),
    note: $checkedConvert('note', (v) => v as String?),
    reason: $checkedConvert('reason', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$CreateModerationTermDtoToJson(
  CreateModerationTermDto instance,
) => <String, dynamic>{
  'term': instance.term,
  'kind': _$CreateModerationTermDtoKindEnumEnumMap[instance.kind]!,
  'category': _$CreateModerationTermDtoCategoryEnumEnumMap[instance.category]!,
  'note': ?instance.note,
  'reason': ?instance.reason,
};

const _$CreateModerationTermDtoKindEnumEnumMap = {
  CreateModerationTermDtoKindEnum.word: 'word',
  CreateModerationTermDtoKindEnum.regex: 'regex',
};

const _$CreateModerationTermDtoCategoryEnumEnumMap = {
  CreateModerationTermDtoCategoryEnum.sexual: 'sexual',
  CreateModerationTermDtoCategoryEnum.drogas: 'drogas',
  CreateModerationTermDtoCategoryEnum.armas: 'armas',
  CreateModerationTermDtoCategoryEnum.ilegal: 'ilegal',
  CreateModerationTermDtoCategoryEnum.inmoral: 'inmoral',
  CreateModerationTermDtoCategoryEnum.ventaProductos: 'venta_productos',
};
