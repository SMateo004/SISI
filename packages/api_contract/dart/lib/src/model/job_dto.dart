//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/job_timeline_dto.dart';
import 'package:sisi_api/src/model/job_cancellation_dto.dart';
import 'package:sisi_api/src/model/job_reviews_dto.dart';
import 'package:sisi_api/src/model/job_category_dto.dart';
import 'package:sisi_api/src/model/job_counterpart_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobDto {
  /// Returns a new [JobDto] instance.
  JobDto({

    required  this.id,

    required  this.requestId,

    required  this.status,

    required  this.myRole,

    required  this.category,

    required  this.description,

    required  this.counterpart,

    required  this.finalPriceBs,

    required  this.commissionBs,

    required  this.netBs,

    required  this.timeline,

    required  this.autoConfirmed,

    required  this.autoConfirmAt,

    required  this.cancellation,

    required  this.reviews,

    required  this.allowedActions,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'requestId',
    required: true,
    includeIfNull: false,
  )


  final String requestId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final JobDtoStatusEnum status;



      /// Mi rol en este trabajo
  @JsonKey(
    
    name: r'myRole',
    required: true,
    includeIfNull: false,
  )


  final JobDtoMyRoleEnum myRole;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final JobCategoryDto category;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: false,
  )


  final String description;



  @JsonKey(
    
    name: r'counterpart',
    required: true,
    includeIfNull: false,
  )


  final JobCounterpartDto counterpart;



  @JsonKey(
    
    name: r'finalPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String finalPriceBs;



      /// Comisión (R6.3, R8.3). Solo para el trabajador y con el trabajo terminado.
  @JsonKey(
    
    name: r'commissionBs',
    required: true,
    includeIfNull: true,
  )


  final String? commissionBs;



      /// Lo que recibe el trabajador: precio final − comisión. Solo para el trabajador.
  @JsonKey(
    
    name: r'netBs',
    required: true,
    includeIfNull: true,
  )


  final String? netBs;



  @JsonKey(
    
    name: r'timeline',
    required: true,
    includeIfNull: false,
  )


  final JobTimelineDto timeline;



      /// Se confirmó solo, pasado el plazo sin respuesta del empleador
  @JsonKey(
    
    name: r'autoConfirmed',
    required: true,
    includeIfNull: false,
  )


  final bool autoConfirmed;



      /// Cuándo se confirmará solo, si el empleador no responde
  @JsonKey(
    
    name: r'autoConfirmAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? autoConfirmAt;



  @JsonKey(
    
    name: r'cancellation',
    required: true,
    includeIfNull: true,
  )


  final JobCancellationDto? cancellation;



      /// Calificaciones (ciegas hasta publicarse)
  @JsonKey(
    
    name: r'reviews',
    required: true,
    includeIfNull: false,
  )


  final JobReviewsDto reviews;



      /// Lo que puedo hacer ahora (para mostrar los botones)
  @JsonKey(
    
    name: r'allowedActions',
    required: true,
    includeIfNull: false,
  )


  final List<JobDtoAllowedActionsEnum> allowedActions;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobDto &&
      other.id == id &&
      other.requestId == requestId &&
      other.status == status &&
      other.myRole == myRole &&
      other.category == category &&
      other.description == description &&
      other.counterpart == counterpart &&
      other.finalPriceBs == finalPriceBs &&
      other.commissionBs == commissionBs &&
      other.netBs == netBs &&
      other.timeline == timeline &&
      other.autoConfirmed == autoConfirmed &&
      other.autoConfirmAt == autoConfirmAt &&
      other.cancellation == cancellation &&
      other.reviews == reviews &&
      other.allowedActions == allowedActions;

    @override
    int get hashCode =>
        id.hashCode +
        requestId.hashCode +
        status.hashCode +
        myRole.hashCode +
        category.hashCode +
        description.hashCode +
        counterpart.hashCode +
        finalPriceBs.hashCode +
        (commissionBs == null ? 0 : commissionBs.hashCode) +
        (netBs == null ? 0 : netBs.hashCode) +
        timeline.hashCode +
        autoConfirmed.hashCode +
        (autoConfirmAt == null ? 0 : autoConfirmAt.hashCode) +
        (cancellation == null ? 0 : cancellation.hashCode) +
        reviews.hashCode +
        allowedActions.hashCode;

  factory JobDto.fromJson(Map<String, dynamic> json) => _$JobDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum JobDtoStatusEnum {
@JsonValue(r'asignado')
asignado(r'asignado'),
@JsonValue(r'en_camino')
enCamino(r'en_camino'),
@JsonValue(r'en_curso')
enCurso(r'en_curso'),
@JsonValue(r'terminado')
terminado(r'terminado'),
@JsonValue(r'cancelado')
cancelado(r'cancelado');

const JobDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


/// Mi rol en este trabajo
enum JobDtoMyRoleEnum {
@JsonValue(r'worker')
worker(r'worker'),
@JsonValue(r'employer')
employer(r'employer');

const JobDtoMyRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum JobDtoAllowedActionsEnum {
@JsonValue(r'START_TRIP')
START_TRIP(r'START_TRIP'),
@JsonValue(r'START_WORK')
START_WORK(r'START_WORK'),
@JsonValue(r'FINISH')
FINISH(r'FINISH'),
@JsonValue(r'CONFIRM')
CONFIRM(r'CONFIRM'),
@JsonValue(r'AUTO_CONFIRM')
AUTO_CONFIRM(r'AUTO_CONFIRM'),
@JsonValue(r'DISPUTE')
DISPUTE(r'DISPUTE'),
@JsonValue(r'RESOLVE_CONFIRM')
RESOLVE_CONFIRM(r'RESOLVE_CONFIRM'),
@JsonValue(r'RESOLVE_CANCEL')
RESOLVE_CANCEL(r'RESOLVE_CANCEL'),
@JsonValue(r'CANCEL')
CANCEL(r'CANCEL');

const JobDtoAllowedActionsEnum(this.value);

final String value;

@override
String toString() => value;
}


