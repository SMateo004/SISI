// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_info_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PayInfoDtoCWProxy {
  PayInfoDto qrUrl(String? qrUrl);

  PayInfoDto catchUpAmountBs(String catchUpAmountBs);

  PayInfoDto unlockAmountBs(String unlockAmountBs);

  PayInfoDto totalBalanceBs(String totalBalanceBs);

  PayInfoDto paymentReference(String? paymentReference);

  PayInfoDto dueAt(DateTime? dueAt);

  PayInfoDto instructions(List<String> instructions);

  PayInfoDto gatewayEnabled(bool gatewayEnabled);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PayInfoDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PayInfoDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PayInfoDto call({
    String? qrUrl,
    String catchUpAmountBs,
    String unlockAmountBs,
    String totalBalanceBs,
    String? paymentReference,
    DateTime? dueAt,
    List<String> instructions,
    bool gatewayEnabled,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPayInfoDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPayInfoDto.copyWith.fieldName(...)`
class _$PayInfoDtoCWProxyImpl implements _$PayInfoDtoCWProxy {
  const _$PayInfoDtoCWProxyImpl(this._value);

  final PayInfoDto _value;

  @override
  PayInfoDto qrUrl(String? qrUrl) => this(qrUrl: qrUrl);

  @override
  PayInfoDto catchUpAmountBs(String catchUpAmountBs) =>
      this(catchUpAmountBs: catchUpAmountBs);

  @override
  PayInfoDto unlockAmountBs(String unlockAmountBs) =>
      this(unlockAmountBs: unlockAmountBs);

  @override
  PayInfoDto totalBalanceBs(String totalBalanceBs) =>
      this(totalBalanceBs: totalBalanceBs);

  @override
  PayInfoDto paymentReference(String? paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  PayInfoDto dueAt(DateTime? dueAt) => this(dueAt: dueAt);

  @override
  PayInfoDto instructions(List<String> instructions) =>
      this(instructions: instructions);

  @override
  PayInfoDto gatewayEnabled(bool gatewayEnabled) =>
      this(gatewayEnabled: gatewayEnabled);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PayInfoDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PayInfoDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PayInfoDto call({
    Object? qrUrl = const $CopyWithPlaceholder(),
    Object? catchUpAmountBs = const $CopyWithPlaceholder(),
    Object? unlockAmountBs = const $CopyWithPlaceholder(),
    Object? totalBalanceBs = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
    Object? dueAt = const $CopyWithPlaceholder(),
    Object? instructions = const $CopyWithPlaceholder(),
    Object? gatewayEnabled = const $CopyWithPlaceholder(),
  }) {
    return PayInfoDto(
      qrUrl: qrUrl == const $CopyWithPlaceholder()
          ? _value.qrUrl
          // ignore: cast_nullable_to_non_nullable
          : qrUrl as String?,
      catchUpAmountBs: catchUpAmountBs == const $CopyWithPlaceholder()
          ? _value.catchUpAmountBs
          // ignore: cast_nullable_to_non_nullable
          : catchUpAmountBs as String,
      unlockAmountBs: unlockAmountBs == const $CopyWithPlaceholder()
          ? _value.unlockAmountBs
          // ignore: cast_nullable_to_non_nullable
          : unlockAmountBs as String,
      totalBalanceBs: totalBalanceBs == const $CopyWithPlaceholder()
          ? _value.totalBalanceBs
          // ignore: cast_nullable_to_non_nullable
          : totalBalanceBs as String,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String?,
      dueAt: dueAt == const $CopyWithPlaceholder()
          ? _value.dueAt
          // ignore: cast_nullable_to_non_nullable
          : dueAt as DateTime?,
      instructions: instructions == const $CopyWithPlaceholder()
          ? _value.instructions
          // ignore: cast_nullable_to_non_nullable
          : instructions as List<String>,
      gatewayEnabled: gatewayEnabled == const $CopyWithPlaceholder()
          ? _value.gatewayEnabled
          // ignore: cast_nullable_to_non_nullable
          : gatewayEnabled as bool,
    );
  }
}

extension $PayInfoDtoCopyWith on PayInfoDto {
  /// Returns a callable class that can be used as follows: `instanceOfPayInfoDto.copyWith(...)` or like so:`instanceOfPayInfoDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PayInfoDtoCWProxy get copyWith => _$PayInfoDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayInfoDto _$PayInfoDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PayInfoDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'qrUrl',
          'catchUpAmountBs',
          'unlockAmountBs',
          'totalBalanceBs',
          'paymentReference',
          'dueAt',
          'instructions',
          'gatewayEnabled',
        ],
      );
      final val = PayInfoDto(
        qrUrl: $checkedConvert('qrUrl', (v) => v as String?),
        catchUpAmountBs: $checkedConvert('catchUpAmountBs', (v) => v as String),
        unlockAmountBs: $checkedConvert('unlockAmountBs', (v) => v as String),
        totalBalanceBs: $checkedConvert('totalBalanceBs', (v) => v as String),
        paymentReference: $checkedConvert(
          'paymentReference',
          (v) => v as String?,
        ),
        dueAt: $checkedConvert(
          'dueAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        instructions: $checkedConvert(
          'instructions',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        gatewayEnabled: $checkedConvert('gatewayEnabled', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$PayInfoDtoToJson(PayInfoDto instance) =>
    <String, dynamic>{
      'qrUrl': instance.qrUrl,
      'catchUpAmountBs': instance.catchUpAmountBs,
      'unlockAmountBs': instance.unlockAmountBs,
      'totalBalanceBs': instance.totalBalanceBs,
      'paymentReference': instance.paymentReference,
      'dueAt': instance.dueAt?.toIso8601String(),
      'instructions': instance.instructions,
      'gatewayEnabled': instance.gatewayEnabled,
    };
