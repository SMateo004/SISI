# sisi_api.model.CurrentPeriodDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | null si todavía no hay trabajos esta semana | 
**startAt** | [**DateTime**](DateTime.md) |  | 
**endAt** | [**DateTime**](DateTime.md) |  | 
**dueAt** | [**DateTime**](DateTime.md) | Vencimiento de este periodo (miércoles 23:59 siguiente) | 
**grossBs** | **String** | Ganado en el periodo (bruto, R8.1). Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**commissionBs** | **String** | Comisión del periodo. Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**netBs** | **String** | Neto del periodo: bruto − comisión. Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**paymentReference** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


