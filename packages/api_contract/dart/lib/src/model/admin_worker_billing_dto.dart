//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/admin_period_dto.dart';
import 'package:sisi_api/src/model/admin_ledger_entry_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_worker_billing_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminWorkerBillingDto {
  /// Returns a new [AdminWorkerBillingDto] instance.
  AdminWorkerBillingDto({

    required  this.workerId,

    required  this.balanceBs,

    required  this.periods,

    required  this.entries,
  });

  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



      /// Saldo total = suma del ledger
  @JsonKey(
    
    name: r'balanceBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBs;



  @JsonKey(
    
    name: r'periods',
    required: true,
    includeIfNull: false,
  )


  final List<AdminPeriodDto> periods;



      /// Últimos 100 movimientos
  @JsonKey(
    
    name: r'entries',
    required: true,
    includeIfNull: false,
  )


  final List<AdminLedgerEntryDto> entries;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminWorkerBillingDto &&
      other.workerId == workerId &&
      other.balanceBs == balanceBs &&
      other.periods == periods &&
      other.entries == entries;

    @override
    int get hashCode =>
        workerId.hashCode +
        balanceBs.hashCode +
        periods.hashCode +
        entries.hashCode;

  factory AdminWorkerBillingDto.fromJson(Map<String, dynamic> json) => _$AdminWorkerBillingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminWorkerBillingDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

