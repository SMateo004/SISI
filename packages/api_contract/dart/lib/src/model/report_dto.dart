//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReportDto {
  /// Returns a new [ReportDto] instance.
  ReportDto({

    required  this.id,

    required  this.targetType,

    required  this.targetId,

    required  this.reason,

    required  this.status,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'targetType',
    required: true,
    includeIfNull: false,
  )


  final ReportDtoTargetTypeEnum targetType;



  @JsonKey(
    
    name: r'targetId',
    required: true,
    includeIfNull: false,
  )


  final String targetId;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final ReportDtoReasonEnum reason;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final ReportDtoStatusEnum status;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReportDto &&
      other.id == id &&
      other.targetType == targetType &&
      other.targetId == targetId &&
      other.reason == reason &&
      other.status == status &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        targetType.hashCode +
        targetId.hashCode +
        reason.hashCode +
        status.hashCode +
        createdAt.hashCode;

  factory ReportDto.fromJson(Map<String, dynamic> json) => _$ReportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ReportDtoTargetTypeEnum {
@JsonValue(r'request')
request(r'request'),
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'chat_message')
chatMessage(r'chat_message'),
@JsonValue(r'job')
job(r'job');

const ReportDtoTargetTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum ReportDtoReasonEnum {
@JsonValue(r'servicios_sexuales')
serviciosSexuales(r'servicios_sexuales'),
@JsonValue(r'drogas')
drogas(r'drogas'),
@JsonValue(r'armas')
armas(r'armas'),
@JsonValue(r'ilegal')
ilegal(r'ilegal'),
@JsonValue(r'inmoral')
inmoral(r'inmoral'),
@JsonValue(r'venta_productos')
ventaProductos(r'venta_productos'),
@JsonValue(r'acoso')
acoso(r'acoso'),
@JsonValue(r'fraude')
fraude(r'fraude'),
@JsonValue(r'no_se_presento')
noSePresento(r'no_se_presento'),
@JsonValue(r'suplantacion')
suplantacion(r'suplantacion'),
@JsonValue(r'otro')
otro(r'otro');

const ReportDtoReasonEnum(this.value);

final String value;

@override
String toString() => value;
}


enum ReportDtoStatusEnum {
@JsonValue(r'pendiente')
pendiente(r'pendiente'),
@JsonValue(r'valido')
valido(r'valido'),
@JsonValue(r'descartado')
descartado(r'descartado');

const ReportDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


