// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_verification_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RejectVerificationDtoCWProxy {
  RejectVerificationDto reason(RejectVerificationDtoReasonEnum reason);

  RejectVerificationDto note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RejectVerificationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RejectVerificationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RejectVerificationDto call({
    RejectVerificationDtoReasonEnum reason,
    String note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRejectVerificationDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRejectVerificationDto.copyWith.fieldName(...)`
class _$RejectVerificationDtoCWProxyImpl
    implements _$RejectVerificationDtoCWProxy {
  const _$RejectVerificationDtoCWProxyImpl(this._value);

  final RejectVerificationDto _value;

  @override
  RejectVerificationDto reason(RejectVerificationDtoReasonEnum reason) =>
      this(reason: reason);

  @override
  RejectVerificationDto note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RejectVerificationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RejectVerificationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RejectVerificationDto call({
    Object? reason = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return RejectVerificationDto(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as RejectVerificationDtoReasonEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $RejectVerificationDtoCopyWith on RejectVerificationDto {
  /// Returns a callable class that can be used as follows: `instanceOfRejectVerificationDto.copyWith(...)` or like so:`instanceOfRejectVerificationDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RejectVerificationDtoCWProxy get copyWith =>
      _$RejectVerificationDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectVerificationDto _$RejectVerificationDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RejectVerificationDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['reason', 'note']);
  final val = RejectVerificationDto(
    reason: $checkedConvert(
      'reason',
      (v) => $enumDecode(_$RejectVerificationDtoReasonEnumEnumMap, v),
    ),
    note: $checkedConvert('note', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$RejectVerificationDtoToJson(
  RejectVerificationDto instance,
) => <String, dynamic>{
  'reason': _$RejectVerificationDtoReasonEnumEnumMap[instance.reason]!,
  'note': instance.note,
};

const _$RejectVerificationDtoReasonEnumEnumMap = {
  RejectVerificationDtoReasonEnum.documentoIlegible: 'documento_ilegible',
  RejectVerificationDtoReasonEnum.documentoNoCoincide: 'documento_no_coincide',
  RejectVerificationDtoReasonEnum.selfieNoCoincide: 'selfie_no_coincide',
  RejectVerificationDtoReasonEnum.menorDeEdad: 'menor_de_edad',
  RejectVerificationDtoReasonEnum.documentoVencido: 'documento_vencido',
  RejectVerificationDtoReasonEnum.requisitosDeCategoria:
      'requisitos_de_categoria',
  RejectVerificationDtoReasonEnum.datosIncompletos: 'datos_incompletos',
  RejectVerificationDtoReasonEnum.otro: 'otro',
};
