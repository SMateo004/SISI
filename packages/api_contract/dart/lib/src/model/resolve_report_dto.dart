//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resolve_report_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResolveReportDto {
  /// Returns a new [ResolveReportDto] instance.
  ResolveReportDto({

    required  this.valid,

    required  this.resolution,
  });

      /// true = válido (cuenta para la suspensión); false = descartado
  @JsonKey(
    
    name: r'valid',
    required: true,
    includeIfNull: false,
  )


  final bool valid;



  @JsonKey(
    
    name: r'resolution',
    required: true,
    includeIfNull: false,
  )


  final String resolution;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ResolveReportDto &&
      other.valid == valid &&
      other.resolution == resolution;

    @override
    int get hashCode =>
        valid.hashCode +
        resolution.hashCode;

  factory ResolveReportDto.fromJson(Map<String, dynamic> json) => _$ResolveReportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResolveReportDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

