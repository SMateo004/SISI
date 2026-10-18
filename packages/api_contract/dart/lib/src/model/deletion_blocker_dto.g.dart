// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deletion_blocker_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeletionBlockerDtoCWProxy {
  DeletionBlockerDto code(DeletionBlockerDtoCodeEnum code);

  DeletionBlockerDto message(String message);

  DeletionBlockerDto balanceBs(String? balanceBs);

  DeletionBlockerDto paymentReference(String? paymentReference);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeletionBlockerDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeletionBlockerDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DeletionBlockerDto call({
    DeletionBlockerDtoCodeEnum code,
    String message,
    String? balanceBs,
    String? paymentReference,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeletionBlockerDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeletionBlockerDto.copyWith.fieldName(...)`
class _$DeletionBlockerDtoCWProxyImpl implements _$DeletionBlockerDtoCWProxy {
  const _$DeletionBlockerDtoCWProxyImpl(this._value);

  final DeletionBlockerDto _value;

  @override
  DeletionBlockerDto code(DeletionBlockerDtoCodeEnum code) => this(code: code);

  @override
  DeletionBlockerDto message(String message) => this(message: message);

  @override
  DeletionBlockerDto balanceBs(String? balanceBs) => this(balanceBs: balanceBs);

  @override
  DeletionBlockerDto paymentReference(String? paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeletionBlockerDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeletionBlockerDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DeletionBlockerDto call({
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
  }) {
    return DeletionBlockerDto(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as DeletionBlockerDtoCodeEnum,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String?,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String?,
    );
  }
}

extension $DeletionBlockerDtoCopyWith on DeletionBlockerDto {
  /// Returns a callable class that can be used as follows: `instanceOfDeletionBlockerDto.copyWith(...)` or like so:`instanceOfDeletionBlockerDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeletionBlockerDtoCWProxy get copyWith =>
      _$DeletionBlockerDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletionBlockerDto _$DeletionBlockerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeletionBlockerDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code', 'message']);
      final val = DeletionBlockerDto(
        code: $checkedConvert(
          'code',
          (v) => $enumDecode(_$DeletionBlockerDtoCodeEnumEnumMap, v),
        ),
        message: $checkedConvert('message', (v) => v as String),
        balanceBs: $checkedConvert('balanceBs', (v) => v as String?),
        paymentReference: $checkedConvert(
          'paymentReference',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$DeletionBlockerDtoToJson(DeletionBlockerDto instance) =>
    <String, dynamic>{
      'code': _$DeletionBlockerDtoCodeEnumEnumMap[instance.code]!,
      'message': instance.message,
      'balanceBs': ?instance.balanceBs,
      'paymentReference': ?instance.paymentReference,
    };

const _$DeletionBlockerDtoCodeEnumEnumMap = {
  DeletionBlockerDtoCodeEnum.ACCOUNT_IS_ADMIN: 'ACCOUNT_IS_ADMIN',
  DeletionBlockerDtoCodeEnum.ACCOUNT_HAS_ACTIVE_JOB: 'ACCOUNT_HAS_ACTIVE_JOB',
  DeletionBlockerDtoCodeEnum.ACCOUNT_HAS_PENDING_PAYMENT:
      'ACCOUNT_HAS_PENDING_PAYMENT',
  DeletionBlockerDtoCodeEnum.ACCOUNT_HAS_DEBT: 'ACCOUNT_HAS_DEBT',
};
