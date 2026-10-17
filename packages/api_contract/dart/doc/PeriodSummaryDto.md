# sisi_api.model.PeriodSummaryDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**startAt** | [**DateTime**](DateTime.md) |  | 
**endAt** | [**DateTime**](DateTime.md) |  | 
**dueAt** | [**DateTime**](DateTime.md) |  | 
**status** | **String** |  | 
**grossBs** | **String** | Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**commissionBs** | **String** | Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**netBs** | **String** | Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**balanceBs** | **String** | Lo que queda por pagar de este periodo (negativo = a favor). Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**paymentReference** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


