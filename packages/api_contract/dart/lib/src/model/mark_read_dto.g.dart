// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MarkReadDtoCWProxy {
  MarkReadDto upToId(String upToId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MarkReadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MarkReadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MarkReadDto call({String upToId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMarkReadDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMarkReadDto.copyWith.fieldName(...)`
class _$MarkReadDtoCWProxyImpl implements _$MarkReadDtoCWProxy {
  const _$MarkReadDtoCWProxyImpl(this._value);

  final MarkReadDto _value;

  @override
  MarkReadDto upToId(String upToId) => this(upToId: upToId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MarkReadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MarkReadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MarkReadDto call({Object? upToId = const $CopyWithPlaceholder()}) {
    return MarkReadDto(
      upToId: upToId == const $CopyWithPlaceholder()
          ? _value.upToId
          // ignore: cast_nullable_to_non_nullable
          : upToId as String,
    );
  }
}

extension $MarkReadDtoCopyWith on MarkReadDto {
  /// Returns a callable class that can be used as follows: `instanceOfMarkReadDto.copyWith(...)` or like so:`instanceOfMarkReadDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MarkReadDtoCWProxy get copyWith => _$MarkReadDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkReadDto _$MarkReadDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MarkReadDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['upToId']);
      final val = MarkReadDto(
        upToId: $checkedConvert('upToId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$MarkReadDtoToJson(MarkReadDto instance) =>
    <String, dynamic>{'upToId': instance.upToId};
