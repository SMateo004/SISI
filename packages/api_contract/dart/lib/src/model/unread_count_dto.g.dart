// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_count_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UnreadCountDtoCWProxy {
  UnreadCountDto count(num count);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UnreadCountDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UnreadCountDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UnreadCountDto call({num count});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUnreadCountDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUnreadCountDto.copyWith.fieldName(...)`
class _$UnreadCountDtoCWProxyImpl implements _$UnreadCountDtoCWProxy {
  const _$UnreadCountDtoCWProxyImpl(this._value);

  final UnreadCountDto _value;

  @override
  UnreadCountDto count(num count) => this(count: count);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UnreadCountDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UnreadCountDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UnreadCountDto call({Object? count = const $CopyWithPlaceholder()}) {
    return UnreadCountDto(
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as num,
    );
  }
}

extension $UnreadCountDtoCopyWith on UnreadCountDto {
  /// Returns a callable class that can be used as follows: `instanceOfUnreadCountDto.copyWith(...)` or like so:`instanceOfUnreadCountDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UnreadCountDtoCWProxy get copyWith => _$UnreadCountDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountDto _$UnreadCountDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UnreadCountDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['count']);
      final val = UnreadCountDto(
        count: $checkedConvert('count', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$UnreadCountDtoToJson(UnreadCountDto instance) =>
    <String, dynamic>{'count': instance.count};
