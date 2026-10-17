// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PaymentPageDtoCWProxy {
  PaymentPageDto items(List<MyPaymentDto> items);

  PaymentPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentPageDto call({List<MyPaymentDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPaymentPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPaymentPageDto.copyWith.fieldName(...)`
class _$PaymentPageDtoCWProxyImpl implements _$PaymentPageDtoCWProxy {
  const _$PaymentPageDtoCWProxyImpl(this._value);

  final PaymentPageDto _value;

  @override
  PaymentPageDto items(List<MyPaymentDto> items) => this(items: items);

  @override
  PaymentPageDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return PaymentPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<MyPaymentDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $PaymentPageDtoCopyWith on PaymentPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfPaymentPageDto.copyWith(...)` or like so:`instanceOfPaymentPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PaymentPageDtoCWProxy get copyWith => _$PaymentPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentPageDto _$PaymentPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PaymentPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = PaymentPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => MyPaymentDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PaymentPageDtoToJson(PaymentPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };
