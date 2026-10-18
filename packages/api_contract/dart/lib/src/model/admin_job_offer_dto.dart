//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/admin_job_party_dto.dart';
import 'package:sisi_api/src/model/admin_offer_event_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_job_offer_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminJobOfferDto {
  /// Returns a new [AdminJobOfferDto] instance.
  AdminJobOfferDto({

    required  this.id,

    required  this.worker,

    required  this.status,

    required  this.chosen,

    required  this.history,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'worker',
    required: true,
    includeIfNull: false,
  )


  final AdminJobPartyDto worker;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



      /// La que eligió el empleador
  @JsonKey(
    
    name: r'chosen',
    required: true,
    includeIfNull: false,
  )


  final bool chosen;



      /// Historial (ADR-0042)
  @JsonKey(
    
    name: r'history',
    required: true,
    includeIfNull: false,
  )


  final List<AdminOfferEventDto> history;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminJobOfferDto &&
      other.id == id &&
      other.worker == worker &&
      other.status == status &&
      other.chosen == chosen &&
      other.history == history;

    @override
    int get hashCode =>
        id.hashCode +
        worker.hashCode +
        status.hashCode +
        chosen.hashCode +
        history.hashCode;

  factory AdminJobOfferDto.fromJson(Map<String, dynamic> json) => _$AdminJobOfferDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminJobOfferDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

