// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_term_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModerationTermDtoCWProxy {
  ModerationTermDto id(String id);

  ModerationTermDto term(String term);

  ModerationTermDto kind(ModerationTermDtoKindEnum kind);

  ModerationTermDto category(ModerationTermDtoCategoryEnum category);

  ModerationTermDto active(bool active);

  ModerationTermDto note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationTermDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationTermDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationTermDto call({
    String id,
    String term,
    ModerationTermDtoKindEnum kind,
    ModerationTermDtoCategoryEnum category,
    bool active,
    String? note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModerationTermDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModerationTermDto.copyWith.fieldName(...)`
class _$ModerationTermDtoCWProxyImpl implements _$ModerationTermDtoCWProxy {
  const _$ModerationTermDtoCWProxyImpl(this._value);

  final ModerationTermDto _value;

  @override
  ModerationTermDto id(String id) => this(id: id);

  @override
  ModerationTermDto term(String term) => this(term: term);

  @override
  ModerationTermDto kind(ModerationTermDtoKindEnum kind) => this(kind: kind);

  @override
  ModerationTermDto category(ModerationTermDtoCategoryEnum category) =>
      this(category: category);

  @override
  ModerationTermDto active(bool active) => this(active: active);

  @override
  ModerationTermDto note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationTermDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationTermDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationTermDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? term = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return ModerationTermDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      term: term == const $CopyWithPlaceholder()
          ? _value.term
          // ignore: cast_nullable_to_non_nullable
          : term as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as ModerationTermDtoKindEnum,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as ModerationTermDtoCategoryEnum,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $ModerationTermDtoCopyWith on ModerationTermDto {
  /// Returns a callable class that can be used as follows: `instanceOfModerationTermDto.copyWith(...)` or like so:`instanceOfModerationTermDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModerationTermDtoCWProxy get copyWith =>
      _$ModerationTermDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationTermDto _$ModerationTermDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ModerationTermDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'term',
          'kind',
          'category',
          'active',
          'note',
        ],
      );
      final val = ModerationTermDto(
        id: $checkedConvert('id', (v) => v as String),
        term: $checkedConvert('term', (v) => v as String),
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(_$ModerationTermDtoKindEnumEnumMap, v),
        ),
        category: $checkedConvert(
          'category',
          (v) => $enumDecode(_$ModerationTermDtoCategoryEnumEnumMap, v),
        ),
        active: $checkedConvert('active', (v) => v as bool),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ModerationTermDtoToJson(ModerationTermDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'term': instance.term,
      'kind': _$ModerationTermDtoKindEnumEnumMap[instance.kind]!,
      'category': _$ModerationTermDtoCategoryEnumEnumMap[instance.category]!,
      'active': instance.active,
      'note': instance.note,
    };

const _$ModerationTermDtoKindEnumEnumMap = {
  ModerationTermDtoKindEnum.word: 'word',
  ModerationTermDtoKindEnum.regex: 'regex',
};

const _$ModerationTermDtoCategoryEnumEnumMap = {
  ModerationTermDtoCategoryEnum.sexual: 'sexual',
  ModerationTermDtoCategoryEnum.drogas: 'drogas',
  ModerationTermDtoCategoryEnum.armas: 'armas',
  ModerationTermDtoCategoryEnum.ilegal: 'ilegal',
  ModerationTermDtoCategoryEnum.inmoral: 'inmoral',
  ModerationTermDtoCategoryEnum.ventaProductos: 'venta_productos',
};
