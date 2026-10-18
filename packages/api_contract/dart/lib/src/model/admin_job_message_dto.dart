//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_job_message_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminJobMessageDto {
  /// Returns a new [AdminJobMessageDto] instance.
  AdminJobMessageDto({

    required  this.id,

    required  this.from,

    required  this.body,

    required  this.status,

    required  this.at,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'from',
    required: true,
    includeIfNull: false,
  )


  final AdminJobMessageDtoFromEnum from;



  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



      /// Retenido o descartado: no le llegó a la contraparte
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final AdminJobMessageDtoStatusEnum status;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminJobMessageDto &&
      other.id == id &&
      other.from == from &&
      other.body == body &&
      other.status == status &&
      other.at == at;

    @override
    int get hashCode =>
        id.hashCode +
        from.hashCode +
        body.hashCode +
        status.hashCode +
        at.hashCode;

  factory AdminJobMessageDto.fromJson(Map<String, dynamic> json) => _$AdminJobMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminJobMessageDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminJobMessageDtoFromEnum {
@JsonValue(r'worker')
worker(r'worker'),
@JsonValue(r'employer')
employer(r'employer');

const AdminJobMessageDtoFromEnum(this.value);

final String value;

@override
String toString() => value;
}


/// Retenido o descartado: no le llegó a la contraparte
enum AdminJobMessageDtoStatusEnum {
@JsonValue(r'entregado')
entregado(r'entregado'),
@JsonValue(r'retenido')
retenido(r'retenido'),
@JsonValue(r'descartado')
descartado(r'descartado');

const AdminJobMessageDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


