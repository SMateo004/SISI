# sisi_api.model.EarningsSummaryDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**currentPeriod** | [**CurrentPeriodDto**](CurrentPeriodDto.md) |  | 
**balanceBs** | **String** | Saldo pendiente total = suma del ledger, periodo abierto incluido. Negativo = saldo a favor. Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**overdueOrPendingBs** | **String** | Periodos cerrados impagos (\"para ponerte al día\"). Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**nextDueAt** | [**DateTime**](DateTime.md) | Próxima fecha límite con deuda | 
**overdue** | **bool** | Tiene algún periodo vencido | 
**blocked** | **bool** | Modo trabajador bloqueado por deuda (R7.7) | 
**debtCap** | [**DebtCapStateDto**](DebtCapStateDto.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


