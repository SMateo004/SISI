//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/pilot_phone_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pilot_overview_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PilotOverviewDto {
  /// Returns a new [PilotOverviewDto] instance.
  PilotOverviewDto({

    required  this.cityId,

    required  this.cityName,

    required  this.closed,

    required  this.allowlist,

    required  this.interestCount,
  });

  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: false,
  )


  final String cityId;



  @JsonKey(
    
    name: r'cityName',
    required: true,
    includeIfNull: false,
  )


  final String cityName;



      /// Flag pilot.closed de la ciudad (se cambia en Feature flags)
  @JsonKey(
    
    name: r'closed',
    required: true,
    includeIfNull: false,
  )


  final bool closed;



  @JsonKey(
    
    name: r'allowlist',
    required: true,
    includeIfNull: false,
  )


  final List<PilotPhoneDto> allowlist;



  @JsonKey(
    
    name: r'interestCount',
    required: true,
    includeIfNull: false,
  )


  final num interestCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PilotOverviewDto &&
      other.cityId == cityId &&
      other.cityName == cityName &&
      other.closed == closed &&
      other.allowlist == allowlist &&
      other.interestCount == interestCount;

    @override
    int get hashCode =>
        cityId.hashCode +
        cityName.hashCode +
        closed.hashCode +
        allowlist.hashCode +
        interestCount.hashCode;

  factory PilotOverviewDto.fromJson(Map<String, dynamic> json) => _$PilotOverviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PilotOverviewDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

