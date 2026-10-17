//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/admin_report_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resolve_report_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResolveReportResultDto {
  /// Returns a new [ResolveReportResultDto] instance.
  ResolveReportResultDto({

    required  this.report,

    required  this.outcome,
  });

  @JsonKey(
    
    name: r'report',
    required: true,
    includeIfNull: false,
  )


  final AdminReportDto report;



      /// suspend = el trabajador quedó suspendido; flag = marcado para revisión
  @JsonKey(
    
    name: r'outcome',
    required: true,
    includeIfNull: false,
  )


  final ResolveReportResultDtoOutcomeEnum outcome;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ResolveReportResultDto &&
      other.report == report &&
      other.outcome == outcome;

    @override
    int get hashCode =>
        report.hashCode +
        outcome.hashCode;

  factory ResolveReportResultDto.fromJson(Map<String, dynamic> json) => _$ResolveReportResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResolveReportResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// suspend = el trabajador quedó suspendido; flag = marcado para revisión
enum ResolveReportResultDtoOutcomeEnum {
@JsonValue(r'suspend')
suspend(r'suspend'),
@JsonValue(r'flag')
flag(r'flag'),
@JsonValue(r'none')
none(r'none');

const ResolveReportResultDtoOutcomeEnum(this.value);

final String value;

@override
String toString() => value;
}


