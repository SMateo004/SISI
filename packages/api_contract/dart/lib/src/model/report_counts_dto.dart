//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_counts_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReportCountsDto {
  /// Returns a new [ReportCountsDto] instance.
  ReportCountsDto({

    required  this.pendiente,

    required  this.valido,

    required  this.descartado,
  });

  @JsonKey(
    
    name: r'pendiente',
    required: true,
    includeIfNull: false,
  )


  final num pendiente;



  @JsonKey(
    
    name: r'valido',
    required: true,
    includeIfNull: false,
  )


  final num valido;



  @JsonKey(
    
    name: r'descartado',
    required: true,
    includeIfNull: false,
  )


  final num descartado;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReportCountsDto &&
      other.pendiente == pendiente &&
      other.valido == valido &&
      other.descartado == descartado;

    @override
    int get hashCode =>
        pendiente.hashCode +
        valido.hashCode +
        descartado.hashCode;

  factory ReportCountsDto.fromJson(Map<String, dynamic> json) => _$ReportCountsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportCountsDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

