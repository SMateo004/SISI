# sisi_api.model.MyPaymentDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**amountBs** | **String** | Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**paidAt** | [**DateTime**](DateTime.md) |  | 
**method** | **String** |  | 
**status** | **String** | Un pago del historial ya está registrado; los comprobantes en revisión están en /me/billing/submissions | 
**reference** | **String** |  | 
**periods** | [**List&lt;PaymentAllocationDto&gt;**](PaymentAllocationDto.md) | Periodos que cubrió | 
**receiptUrl** | **String** | Enlace temporal al comprobante (R8.2) | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


