// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_match_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModerationMatchDtoCWProxy {
  ModerationMatchDto termId(String termId);

  ModerationMatchDto term(String term);

  ModerationMatchDto kind(ModerationMatchDtoKindEnum kind);

  ModerationMatchDto category(ModerationMatchDtoCategoryEnum category);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationMatchDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationMatchDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationMatchDto call({
    String termId,
    String term,
    ModerationMatchDtoKindEnum kind,
    ModerationMatchDtoCategoryEnum category,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModerationMatchDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModerationMatchDto.copyWith.fieldName(...)`
class _$ModerationMatchDtoCWProxyImpl implements _$ModerationMatchDtoCWProxy {
  const _$ModerationMatchDtoCWProxyImpl(this._value);

  final ModerationMatchDto _value;

  @override
  ModerationMatchDto termId(String termId) => this(termId: termId);

  @override
  ModerationMatchDto term(String term) => this(term: term);

  @override
  ModerationMatchDto kind(ModerationMatchDtoKindEnum kind) => this(kind: kind);

  @override
  ModerationMatchDto category(ModerationMatchDtoCategoryEnum category) =>
      this(category: category);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationMatchDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationMatchDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationMatchDto call({
    Object? termId = const $CopyWithPlaceholder(),
    Object? term = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
  }) {
    return ModerationMatchDto(
      termId: termId == const $CopyWithPlaceholder()
          ? _value.termId
          // ignore: cast_nullable_to_non_nullable
          : termId as String,
      term: term == const $CopyWithPlaceholder()
          ? _value.term
          // ignore: cast_nullable_to_non_nullable
          : term as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as ModerationMatchDtoKindEnum,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as ModerationMatchDtoCategoryEnum,
    );
  }
}

extension $ModerationMatchDtoCopyWith on ModerationMatchDto {
  /// Returns a callable class that can be used as follows: `instanceOfModerationMatchDto.copyWith(...)` or like so:`instanceOfModerationMatchDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModerationMatchDtoCWProxy get copyWith =>
      _$ModerationMatchDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationMatchDto _$ModerationMatchDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ModerationMatchDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['termId', 'term', 'kind', 'category'],
      );
      final val = ModerationMatchDto(
        termId: $checkedConvert('termId', (v) => v as String),
        term: $checkedConvert('term', (v) => v as String),
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(_$ModerationMatchDtoKindEnumEnumMap, v),
        ),
        category: $checkedConvert(
          'category',
          (v) => $enumDecode(_$ModerationMatchDtoCategoryEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ModerationMatchDtoToJson(ModerationMatchDto instance) =>
    <String, dynamic>{
      'termId': instance.termId,
      'term': instance.term,
      'kind': _$ModerationMatchDtoKindEnumEnumMap[instance.kind]!,
      'category': _$ModerationMatchDtoCategoryEnumEnumMap[instance.category]!,
    };

const _$ModerationMatchDtoKindEnumEnumMap = {
  ModerationMatchDtoKindEnum.word: 'word',
  ModerationMatchDtoKindEnum.regex: 'regex',
};

const _$ModerationMatchDtoCategoryEnumEnumMap = {
  ModerationMatchDtoCategoryEnum.sexual: 'sexual',
  ModerationMatchDtoCategoryEnum.drogas: 'drogas',
  ModerationMatchDtoCategoryEnum.armas: 'armas',
  ModerationMatchDtoCategoryEnum.ilegal: 'ilegal',
  ModerationMatchDtoCategoryEnum.inmoral: 'inmoral',
  ModerationMatchDtoCategoryEnum.ventaProductos: 'venta_productos',
};
