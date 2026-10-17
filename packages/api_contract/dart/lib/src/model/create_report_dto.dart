//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_report_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateReportDto {
  /// Returns a new [CreateReportDto] instance.
  CreateReportDto({

    required  this.targetType,

    required  this.targetId,

    required  this.reason,

     this.note,
  });

  @JsonKey(
    
    name: r'targetType',
    required: true,
    includeIfNull: false,
  )


  final CreateReportDtoTargetTypeEnum targetType;



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


  final CreateReportDtoReasonEnum reason;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateReportDto &&
      other.targetType == targetType &&
      other.targetId == targetId &&
      other.reason == reason &&
      other.note == note;

    @override
    int get hashCode =>
        targetType.hashCode +
        targetId.hashCode +
        reason.hashCode +
        note.hashCode;

  factory CreateReportDto.fromJson(Map<String, dynamic> json) => _$CreateReportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReportDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CreateReportDtoTargetTypeEnum {
@JsonValue(r'request')
request(r'request'),
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'chat_message')
chatMessage(r'chat_message'),
@JsonValue(r'job')
job(r'job');

const CreateReportDtoTargetTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum CreateReportDtoReasonEnum {
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

const CreateReportDtoReasonEnum(this.value);

final String value;

@override
String toString() => value;
}


