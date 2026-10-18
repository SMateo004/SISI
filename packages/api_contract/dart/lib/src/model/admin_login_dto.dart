//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_login_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminLoginDto {
  /// Returns a new [AdminLoginDto] instance.
  AdminLoginDto({

    required  this.username,

    required  this.code,
  });

  @JsonKey(
    
    name: r'username',
    required: true,
    includeIfNull: false,
  )


  final String username;



      /// Código de 6 dígitos de la app autenticadora
  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminLoginDto &&
      other.username == username &&
      other.code == code;

    @override
    int get hashCode =>
        username.hashCode +
        code.hashCode;

  factory AdminLoginDto.fromJson(Map<String, dynamic> json) => _$AdminLoginDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminLoginDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

