# sisi_api.api.GananciasApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**billingMeControllerSubmissionUploadUrl**](GananciasApi.md#billingmecontrollersubmissionuploadurl) | **POST** /me/billing/submissions/upload-url | URL para subir la foto de mi comprobante de pago
[**billingMeControllerSubmissions**](GananciasApi.md#billingmecontrollersubmissions) | **GET** /me/billing/submissions | Mis comprobantes enviados y su estado
[**billingMeControllerSubmit**](GananciasApi.md#billingmecontrollersubmit) | **POST** /me/billing/submissions | Enviar mi comprobante de pago (propuesta)
[**earningsControllerPayInfo**](GananciasApi.md#earningscontrollerpayinfo) | **GET** /me/billing/pay-info | Datos para pagar la comisión (R7.4)
[**earningsControllerPayments**](GananciasApi.md#earningscontrollerpayments) | **GET** /me/payments | Historial de pagos (R8.2)
[**earningsControllerPeriods**](GananciasApi.md#earningscontrollerperiods) | **GET** /me/earnings/periods | Historial de periodos (cortes semanales)
[**earningsControllerSummary**](GananciasApi.md#earningscontrollersummary) | **GET** /me/earnings/summary | Resumen de ganancias (R8.1)


# **billingMeControllerSubmissionUploadUrl**
> PresignedUploadDto billingMeControllerSubmissionUploadUrl(fileUploadDto)

URL para subir la foto de mi comprobante de pago

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getGananciasApi();
final FileUploadDto fileUploadDto = ; // FileUploadDto | 

try {
    final response = api.billingMeControllerSubmissionUploadUrl(fileUploadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GananciasApi->billingMeControllerSubmissionUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileUploadDto** | [**FileUploadDto**](FileUploadDto.md)|  | 

### Return type

[**PresignedUploadDto**](PresignedUploadDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **billingMeControllerSubmissions**
> List<PaymentSubmissionDto> billingMeControllerSubmissions()

Mis comprobantes enviados y su estado

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getGananciasApi();

try {
    final response = api.billingMeControllerSubmissions();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GananciasApi->billingMeControllerSubmissions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;PaymentSubmissionDto&gt;**](PaymentSubmissionDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **billingMeControllerSubmit**
> PaymentSubmissionDto billingMeControllerSubmit(createSubmissionDto)

Enviar mi comprobante de pago (propuesta)

Queda \"enviado, pendiente de verificación\". No cambia la deuda hasta que SISI registra el pago.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getGananciasApi();
final CreateSubmissionDto createSubmissionDto = ; // CreateSubmissionDto | 

try {
    final response = api.billingMeControllerSubmit(createSubmissionDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GananciasApi->billingMeControllerSubmit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSubmissionDto** | [**CreateSubmissionDto**](CreateSubmissionDto.md)|  | 

### Return type

[**PaymentSubmissionDto**](PaymentSubmissionDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **earningsControllerPayInfo**
> PayInfoDto earningsControllerPayInfo()

Datos para pagar la comisión (R7.4)

QR de la empresa, monto para ponerte al día, monto para volver a recibir solicitudes (si el tope está alcanzado), referencia para la glosa e instrucciones.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getGananciasApi();

try {
    final response = api.earningsControllerPayInfo();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GananciasApi->earningsControllerPayInfo: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PayInfoDto**](PayInfoDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **earningsControllerPayments**
> PaymentPageDto earningsControllerPayments(cursor)

Historial de pagos (R8.2)

Periodos cubiertos, monto, fecha, estado y enlace temporal al comprobante.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getGananciasApi();
final String cursor = cursor_example; // String | 

try {
    final response = api.earningsControllerPayments(cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GananciasApi->earningsControllerPayments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 

### Return type

[**PaymentPageDto**](PaymentPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **earningsControllerPeriods**
> PeriodPageDto earningsControllerPeriods(cursor)

Historial de periodos (cortes semanales)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getGananciasApi();
final String cursor = cursor_example; // String | 

try {
    final response = api.earningsControllerPeriods(cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GananciasApi->earningsControllerPeriods: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 

### Return type

[**PeriodPageDto**](PeriodPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **earningsControllerSummary**
> EarningsSummaryDto earningsControllerSummary()

Resumen de ganancias (R8.1)

Periodo actual (bruto, comisión, neto), saldo pendiente total, próxima fecha límite y estado del tope.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getGananciasApi();

try {
    final response = api.earningsControllerSummary();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GananciasApi->earningsControllerSummary: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**EarningsSummaryDto**](EarningsSummaryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

