// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_cap_state_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DebtCapStateDtoCWProxy {
  DebtCapStateDto capBs(String capBs);

  DebtCapStateDto reached(bool reached);

  DebtCapStateDto amountToUnlockBs(String amountToUnlockBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DebtCapStateDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DebtCapStateDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DebtCapStateDto call({String capBs, bool reached, String amountToUnlockBs});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDebtCapStateDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDebtCapStateDto.copyWith.fieldName(...)`
class _$DebtCapStateDtoCWProxyImpl implements _$DebtCapStateDtoCWProxy {
  const _$DebtCapStateDtoCWProxyImpl(this._value);

  final DebtCapStateDto _value;

  @override
  DebtCapStateDto capBs(String capBs) => this(capBs: capBs);

  @override
  DebtCapStateDto reached(bool reached) => this(reached: reached);

  @override
  DebtCapStateDto amountToUnlockBs(String amountToUnlockBs) =>
      this(amountToUnlockBs: amountToUnlockBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DebtCapStateDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DebtCapStateDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DebtCapStateDto call({
    Object? capBs = const $CopyWithPlaceholder(),
    Object? reached = const $CopyWithPlaceholder(),
    Object? amountToUnlockBs = const $CopyWithPlaceholder(),
  }) {
    return DebtCapStateDto(
      capBs: capBs == const $CopyWithPlaceholder()
          ? _value.capBs
          // ignore: cast_nullable_to_non_nullable
          : capBs as String,
      reached: reached == const $CopyWithPlaceholder()
          ? _value.reached
          // ignore: cast_nullable_to_non_nullable
          : reached as bool,
      amountToUnlockBs: amountToUnlockBs == const $CopyWithPlaceholder()
          ? _value.amountToUnlockBs
          // ignore: cast_nullable_to_non_nullable
          : amountToUnlockBs as String,
    );
  }
}

extension $DebtCapStateDtoCopyWith on DebtCapStateDto {
  /// Returns a callable class that can be used as follows: `instanceOfDebtCapStateDto.copyWith(...)` or like so:`instanceOfDebtCapStateDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DebtCapStateDtoCWProxy get copyWith => _$DebtCapStateDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebtCapStateDto _$DebtCapStateDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DebtCapStateDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['capBs', 'reached', 'amountToUnlockBs'],
      );
      final val = DebtCapStateDto(
        capBs: $checkedConvert('capBs', (v) => v as String),
        reached: $checkedConvert('reached', (v) => v as bool),
        amountToUnlockBs: $checkedConvert(
          'amountToUnlockBs',
          (v) => v as String,
        ),
      );
      return val;
    });

Map<String, dynamic> _$DebtCapStateDtoToJson(DebtCapStateDto instance) =>
    <String, dynamic>{
      'capBs': instance.capBs,
      'reached': instance.reached,
      'amountToUnlockBs': instance.amountToUnlockBs,
    };
