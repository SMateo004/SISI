// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overdue_list_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OverdueListDtoCWProxy {
  OverdueListDto items(List<OverdueRowDto> items);

  OverdueListDto totalBs(String totalBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OverdueListDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OverdueListDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OverdueListDto call({List<OverdueRowDto> items, String totalBs});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOverdueListDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOverdueListDto.copyWith.fieldName(...)`
class _$OverdueListDtoCWProxyImpl implements _$OverdueListDtoCWProxy {
  const _$OverdueListDtoCWProxyImpl(this._value);

  final OverdueListDto _value;

  @override
  OverdueListDto items(List<OverdueRowDto> items) => this(items: items);

  @override
  OverdueListDto totalBs(String totalBs) => this(totalBs: totalBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OverdueListDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OverdueListDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OverdueListDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? totalBs = const $CopyWithPlaceholder(),
  }) {
    return OverdueListDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<OverdueRowDto>,
      totalBs: totalBs == const $CopyWithPlaceholder()
          ? _value.totalBs
          // ignore: cast_nullable_to_non_nullable
          : totalBs as String,
    );
  }
}

extension $OverdueListDtoCopyWith on OverdueListDto {
  /// Returns a callable class that can be used as follows: `instanceOfOverdueListDto.copyWith(...)` or like so:`instanceOfOverdueListDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OverdueListDtoCWProxy get copyWith => _$OverdueListDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverdueListDto _$OverdueListDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OverdueListDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'totalBs']);
      final val = OverdueListDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => OverdueRowDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        totalBs: $checkedConvert('totalBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$OverdueListDtoToJson(OverdueListDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'totalBs': instance.totalBs,
    };
