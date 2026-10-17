# sisi_api.model.DebtCapStateDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**capBs** | **String** | Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**reached** | **bool** | El saldo supera el tope: no recibe solicitudes nuevas (R7.5) | 
**amountToUnlockBs** | **String** | Lo que hay que pagar para volver a recibir solicitudes (0 si no está sobre el tope). Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


