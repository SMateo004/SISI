# sisi_api.model.RegisterPaymentDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**workerId** | **String** |  | 
**amountBs** | **String** | Monto pagado en Bs (texto, 2 decimales) | 
**method** | **String** |  | 
**paidAt** | [**DateTime**](DateTime.md) | Cuándo pagó (no futuro) | 
**reference** | **String** |  | [optional] 
**receiptKey** | **String** | Clave del comprobante subido (receipts/{worker}/…) | [optional] 
**submissionId** | **String** | Comprobante enviado por el trabajador que se está registrando | [optional] 
**invoiceNumber** | **String** | Número de factura (sin uso hasta la revisión tributaria) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


