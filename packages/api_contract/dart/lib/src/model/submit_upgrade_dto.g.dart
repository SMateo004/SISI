// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_upgrade_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SubmitUpgradeDtoCWProxy {
  SubmitUpgradeDto birthDate(String birthDate);

  SubmitUpgradeDto categoryIds(List<String> categoryIds);

  SubmitUpgradeDto transport(SubmitUpgradeDtoTransportEnum transport);

  SubmitUpgradeDto maxRadiusKm(num maxRadiusKm);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SubmitUpgradeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SubmitUpgradeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SubmitUpgradeDto call({
    String birthDate,
    List<String> categoryIds,
    SubmitUpgradeDtoTransportEnum transport,
    num maxRadiusKm,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSubmitUpgradeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSubmitUpgradeDto.copyWith.fieldName(...)`
class _$SubmitUpgradeDtoCWProxyImpl implements _$SubmitUpgradeDtoCWProxy {
  const _$SubmitUpgradeDtoCWProxyImpl(this._value);

  final SubmitUpgradeDto _value;

  @override
  SubmitUpgradeDto birthDate(String birthDate) => this(birthDate: birthDate);

  @override
  SubmitUpgradeDto categoryIds(List<String> categoryIds) =>
      this(categoryIds: categoryIds);

  @override
  SubmitUpgradeDto transport(SubmitUpgradeDtoTransportEnum transport) =>
      this(transport: transport);

  @override
  SubmitUpgradeDto maxRadiusKm(num maxRadiusKm) =>
      this(maxRadiusKm: maxRadiusKm);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SubmitUpgradeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SubmitUpgradeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SubmitUpgradeDto call({
    Object? birthDate = const $CopyWithPlaceholder(),
    Object? categoryIds = const $CopyWithPlaceholder(),
    Object? transport = const $CopyWithPlaceholder(),
    Object? maxRadiusKm = const $CopyWithPlaceholder(),
  }) {
    return SubmitUpgradeDto(
      birthDate: birthDate == const $CopyWithPlaceholder()
          ? _value.birthDate
          // ignore: cast_nullable_to_non_nullable
          : birthDate as String,
      categoryIds: categoryIds == const $CopyWithPlaceholder()
          ? _value.categoryIds
          // ignore: cast_nullable_to_non_nullable
          : categoryIds as List<String>,
      transport: transport == const $CopyWithPlaceholder()
          ? _value.transport
          // ignore: cast_nullable_to_non_nullable
          : transport as SubmitUpgradeDtoTransportEnum,
      maxRadiusKm: maxRadiusKm == const $CopyWithPlaceholder()
          ? _value.maxRadiusKm
          // ignore: cast_nullable_to_non_nullable
          : maxRadiusKm as num,
    );
  }
}

extension $SubmitUpgradeDtoCopyWith on SubmitUpgradeDto {
  /// Returns a callable class that can be used as follows: `instanceOfSubmitUpgradeDto.copyWith(...)` or like so:`instanceOfSubmitUpgradeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SubmitUpgradeDtoCWProxy get copyWith => _$SubmitUpgradeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitUpgradeDto _$SubmitUpgradeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SubmitUpgradeDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'birthDate',
          'categoryIds',
          'transport',
          'maxRadiusKm',
        ],
      );
      final val = SubmitUpgradeDto(
        birthDate: $checkedConvert('birthDate', (v) => v as String),
        categoryIds: $checkedConvert(
          'categoryIds',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        transport: $checkedConvert(
          'transport',
          (v) => $enumDecode(_$SubmitUpgradeDtoTransportEnumEnumMap, v),
        ),
        maxRadiusKm: $checkedConvert('maxRadiusKm', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$SubmitUpgradeDtoToJson(SubmitUpgradeDto instance) =>
    <String, dynamic>{
      'birthDate': instance.birthDate,
      'categoryIds': instance.categoryIds,
      'transport': _$SubmitUpgradeDtoTransportEnumEnumMap[instance.transport]!,
      'maxRadiusKm': instance.maxRadiusKm,
    };

const _$SubmitUpgradeDtoTransportEnumEnumMap = {
  SubmitUpgradeDtoTransportEnum.aPie: 'a_pie',
  SubmitUpgradeDtoTransportEnum.bicicleta: 'bicicleta',
  SubmitUpgradeDtoTransportEnum.moto: 'moto',
  SubmitUpgradeDtoTransportEnum.auto: 'auto',
  SubmitUpgradeDtoTransportEnum.transportePublico: 'transporte_publico',
};
