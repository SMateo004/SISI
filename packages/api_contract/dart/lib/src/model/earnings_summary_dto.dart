//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/current_period_dto.dart';
import 'package:sisi_api/src/model/debt_cap_state_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'earnings_summary_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EarningsSummaryDto {
  /// Returns a new [EarningsSummaryDto] instance.
  EarningsSummaryDto({

    required  this.currentPeriod,

    required  this.balanceBs,

    required  this.overdueOrPendingBs,

    required  this.nextDueAt,

    required  this.overdue,

    required  this.blocked,

    required  this.debtCap,
  });

  @JsonKey(
    
    name: r'currentPeriod',
    required: true,
    includeIfNull: false,
  )


  final CurrentPeriodDto currentPeriod;



      /// Saldo pendiente total = suma del ledger, periodo abierto incluido. Negativo = saldo a favor. Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'balanceBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBs;



      /// Periodos cerrados impagos (\"para ponerte al día\"). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'overdueOrPendingBs',
    required: true,
    includeIfNull: false,
  )


  final String overdueOrPendingBs;



      /// Próxima fecha límite con deuda
  @JsonKey(
    
    name: r'nextDueAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? nextDueAt;



      /// Tiene algún periodo vencido
  @JsonKey(
    
    name: r'overdue',
    required: true,
    includeIfNull: false,
  )


  final bool overdue;



      /// Modo trabajador bloqueado por deuda (R7.7)
  @JsonKey(
    
    name: r'blocked',
    required: true,
    includeIfNull: false,
  )


  final bool blocked;



  @JsonKey(
    
    name: r'debtCap',
    required: true,
    includeIfNull: false,
  )


  final DebtCapStateDto debtCap;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EarningsSummaryDto &&
      other.currentPeriod == currentPeriod &&
      other.balanceBs == balanceBs &&
      other.overdueOrPendingBs == overdueOrPendingBs &&
      other.nextDueAt == nextDueAt &&
      other.overdue == overdue &&
      other.blocked == blocked &&
      other.debtCap == debtCap;

    @override
    int get hashCode =>
        currentPeriod.hashCode +
        balanceBs.hashCode +
        overdueOrPendingBs.hashCode +
        (nextDueAt == null ? 0 : nextDueAt.hashCode) +
        overdue.hashCode +
        blocked.hashCode +
        debtCap.hashCode;

  factory EarningsSummaryDto.fromJson(Map<String, dynamic> json) => _$EarningsSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EarningsSummaryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

