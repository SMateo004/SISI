# sisi_api.model.PayInfoDto

## Load the model package
```dart
import 'package:sisi_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**qrUrl** | **String** | URL temporal del QR de la empresa (null si no está cargado) | 
**catchUpAmountBs** | **String** | \"Para ponerte al día\": periodos cerrados impagos. Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**unlockAmountBs** | **String** | \"Para volver a recibir solicitudes\": lo que deja el saldo en el tope (0 si no está sobre el tope). Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**totalBalanceBs** | **String** | Saldo total, periodo abierto incluido (pago anticipado). Monto en Bs como texto con 2 decimales (nunca número de punto flotante). | 
**paymentReference** | **String** | Para la glosa: la del periodo más antiguo con deuda | 
**dueAt** | [**DateTime**](DateTime.md) |  | 
**instructions** | **List&lt;String&gt;** | Pasos en español | 
**gatewayEnabled** | **bool** | Pago en línea (pasarela) disponible; hoy siempre false | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


