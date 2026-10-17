# sisi_api.model.RegisterAdjustmentDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**workerId** | **String** |  | 
**amountBs** | **String** | Con signo: positivo aumenta la deuda; negativo la reduce (ADR-0034) | 
**reason** | **String** |  | 
**correctsEntryId** | **String** | Id del movimiento que corrige | [optional] 
**periodId** | **String** | Periodo (por defecto, el del movimiento corregido o el actual) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


