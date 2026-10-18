// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_moderation_term_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateModerationTermDtoCWProxy {
  UpdateModerationTermDto category(
    UpdateModerationTermDtoCategoryEnum? category,
  );

  UpdateModerationTermDto active(bool? active);

  UpdateModerationTermDto note(String? note);

  UpdateModerationTermDto reason(String? reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateModerationTermDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateModerationTermDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateModerationTermDto call({
    UpdateModerationTermDtoCategoryEnum? category,
    bool? active,
    String? note,
    String? reason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateModerationTermDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateModerationTermDto.copyWith.fieldName(...)`
class _$UpdateModerationTermDtoCWProxyImpl
    implements _$UpdateModerationTermDtoCWProxy {
  const _$UpdateModerationTermDtoCWProxyImpl(this._value);

  final UpdateModerationTermDto _value;

  @override
  UpdateModerationTermDto category(
    UpdateModerationTermDtoCategoryEnum? category,
  ) => this(category: category);

  @override
  UpdateModerationTermDto active(bool? active) => this(active: active);

  @override
  UpdateModerationTermDto note(String? note) => this(note: note);

  @override
  UpdateModerationTermDto reason(String? reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateModerationTermDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateModerationTermDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateModerationTermDto call({
    Object? category = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return UpdateModerationTermDto(
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as UpdateModerationTermDtoCategoryEnum?,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool?,
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

extension $UpdateModerationTermDtoCopyWith on UpdateModerationTermDto {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateModerationTermDto.copyWith(...)` or like so:`instanceOfUpdateModerationTermDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateModerationTermDtoCWProxy get copyWith =>
      _$UpdateModerationTermDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateModerationTermDto _$UpdateModerationTermDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpdateModerationTermDto', json, ($checkedConvert) {
  final val = UpdateModerationTermDto(
    category: $checkedConvert(
      'category',
      (v) =>
          $enumDecodeNullable(_$UpdateModerationTermDtoCategoryEnumEnumMap, v),
    ),
    active: $checkedConvert('active', (v) => v as bool?),
    note: $checkedConvert('note', (v) => v as String?),
    reason: $checkedConvert('reason', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$UpdateModerationTermDtoToJson(
  UpdateModerationTermDto instance,
) => <String, dynamic>{
  'category': ?_$UpdateModerationTermDtoCategoryEnumEnumMap[instance.category],
  'active': ?instance.active,
  'note': ?instance.note,
  'reason': ?instance.reason,
};

const _$UpdateModerationTermDtoCategoryEnumEnumMap = {
  UpdateModerationTermDtoCategoryEnum.sexual: 'sexual',
  UpdateModerationTermDtoCategoryEnum.drogas: 'drogas',
  UpdateModerationTermDtoCategoryEnum.armas: 'armas',
  UpdateModerationTermDtoCategoryEnum.ilegal: 'ilegal',
  UpdateModerationTermDtoCategoryEnum.inmoral: 'inmoral',
  UpdateModerationTermDtoCategoryEnum.ventaProductos: 'venta_productos',
};
