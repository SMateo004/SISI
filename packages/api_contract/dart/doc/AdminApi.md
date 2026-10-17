# sisi_api.api.AdminApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminBillingControllerQrUploadUrl**](AdminApi.md#adminbillingcontrollerqruploadurl) | **POST** /admin/billing/qr/upload-url | URL para subir la imagen del QR de cobro de la empresa
[**adminBillingControllerReceiptUploadUrl**](AdminApi.md#adminbillingcontrollerreceiptuploadurl) | **POST** /admin/billing/receipts/upload-url | URL para subir el comprobante de un pago (receipts/, privado)
[**adminBillingControllerRegisterAdjustment**](AdminApi.md#adminbillingcontrollerregisteradjustment) | **POST** /admin/billing/adjustments | Registrar un ajuste (R7.9)
[**adminBillingControllerRegisterPayment**](AdminApi.md#adminbillingcontrollerregisterpayment) | **POST** /admin/billing/payments | Registrar un pago (R7.4)
[**adminBillingControllerRejectSubmission**](AdminApi.md#adminbillingcontrollerrejectsubmission) | **POST** /admin/billing/submissions/{id}/reject | Rechazar un comprobante
[**adminBillingControllerSetQr**](AdminApi.md#adminbillingcontrollersetqr) | **PUT** /admin/billing/qr | Configurar el QR de cobro (R7.4)
[**adminBillingControllerSubmissions**](AdminApi.md#adminbillingcontrollersubmissions) | **GET** /admin/billing/submissions | Comprobantes enviados por los trabajadores (por defecto, pendientes)
[**adminBillingControllerWorker**](AdminApi.md#adminbillingcontrollerworker) | **GET** /admin/billing/workers/{id} | Saldo, periodos y movimientos de un trabajador
[**adminCategoriesControllerList**](AdminApi.md#admincategoriescontrollerlist) | **GET** /admin/categories | Todas las categorías con sus valores por ciudad
[**adminCategoriesControllerUpdate**](AdminApi.md#admincategoriescontrollerupdate) | **PATCH** /admin/categories/{id} | Edita los valores base de una categoría
[**adminCategoriesControllerUpsertCity**](AdminApi.md#admincategoriescontrollerupsertcity) | **PUT** /admin/categories/{id}/cities/{cityId} | Activa o ajusta una categoría en una ciudad
[**adminChatControllerHeld**](AdminApi.md#adminchatcontrollerheld) | **GET** /admin/chat/held | Mensajes de chat retenidos (los 100 más recientes)
[**adminJobsControllerDisputed**](AdminApi.md#adminjobscontrollerdisputed) | **GET** /admin/jobs/disputed | Trabajos con un problema reportado, sin resolver
[**adminJobsControllerResolve**](AdminApi.md#adminjobscontrollerresolve) | **POST** /admin/jobs/{id}/resolve | Resolver una disputa
[**adminReportsControllerList**](AdminApi.md#adminreportscontrollerlist) | **GET** /admin/reports | Reportes por estado (por defecto, pendientes)
[**adminReportsControllerResolve**](AdminApi.md#adminreportscontrollerresolve) | **POST** /admin/reports/{id}/resolve | Marcar un reporte como válido o descartado
[**adminRequestsControllerList**](AdminApi.md#adminrequestscontrollerlist) | **GET** /admin/requests | Solicitudes por estado (por defecto, las retenidas por moderación)
[**adminRequestsControllerReject**](AdminApi.md#adminrequestscontrollerreject) | **POST** /admin/requests/{id}/reject | Rechaza una solicitud retenida
[**adminRequestsControllerRelease**](AdminApi.md#adminrequestscontrollerrelease) | **POST** /admin/requests/{id}/release | Libera una solicitud retenida: pasa a \&quot;buscando\&quot;
[**adminWorkersControllerDocumentUrl**](AdminApi.md#adminworkerscontrollerdocumenturl) | **GET** /admin/workers/{userId}/documents/{documentId}/url | Enlace temporal a un documento de identidad (R9.5)
[**featureFlagsControllerList**](AdminApi.md#featureflagscontrollerlist) | **GET** /admin/feature-flags | Feature flags (globales y por ciudad)
[**featureFlagsControllerSet**](AdminApi.md#featureflagscontrollerset) | **PUT** /admin/feature-flags/{key} | Enciende o apaga un flag
[**moderationTermsControllerCreate**](AdminApi.md#moderationtermscontrollercreate) | **POST** /admin/moderation-terms | Agrega un término o patrón
[**moderationTermsControllerList**](AdminApi.md#moderationtermscontrollerlist) | **GET** /admin/moderation-terms | Términos del filtro de moderación
[**moderationTermsControllerRemove**](AdminApi.md#moderationtermscontrollerremove) | **DELETE** /admin/moderation-terms/{id} | Desactiva un término (baja lógica)
[**moderationTermsControllerUpdate**](AdminApi.md#moderationtermscontrollerupdate) | **PATCH** /admin/moderation-terms/{id} | Cambia la categoría, la nota o reactiva un término


# **adminBillingControllerQrUploadUrl**
> PresignedUploadDto adminBillingControllerQrUploadUrl(fileUploadDto)

URL para subir la imagen del QR de cobro de la empresa

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final FileUploadDto fileUploadDto = ; // FileUploadDto | 

try {
    final response = api.adminBillingControllerQrUploadUrl(fileUploadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerQrUploadUrl: $e\n');
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

# **adminBillingControllerReceiptUploadUrl**
> PresignedUploadDto adminBillingControllerReceiptUploadUrl(receiptUploadDto)

URL para subir el comprobante de un pago (receipts/, privado)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final ReceiptUploadDto receiptUploadDto = ; // ReceiptUploadDto | 

try {
    final response = api.adminBillingControllerReceiptUploadUrl(receiptUploadDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerReceiptUploadUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **receiptUploadDto** | [**ReceiptUploadDto**](ReceiptUploadDto.md)|  | 

### Return type

[**PresignedUploadDto**](PresignedUploadDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerRegisterAdjustment**
> AdjustmentResultDto adminBillingControllerRegisterAdjustment(idempotencyKey, registerAdjustmentDto)

Registrar un ajuste (R7.9)

Monto con signo y motivo obligatorio. Nunca se edita un movimiento: se agrega uno nuevo.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String idempotencyKey = idempotencyKey_example; // String | Obligatorio (8 a 100 caracteres). Un reintento con la misma clave devuelve el resultado original.
final RegisterAdjustmentDto registerAdjustmentDto = ; // RegisterAdjustmentDto | 

try {
    final response = api.adminBillingControllerRegisterAdjustment(idempotencyKey, registerAdjustmentDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerRegisterAdjustment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Obligatorio (8 a 100 caracteres). Un reintento con la misma clave devuelve el resultado original. | 
 **registerAdjustmentDto** | [**RegisterAdjustmentDto**](RegisterAdjustmentDto.md)|  | 

### Return type

[**AdjustmentResultDto**](AdjustmentResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerRegisterPayment**
> PaymentResultDto adminBillingControllerRegisterPayment(idempotencyKey, registerPaymentDto)

Registrar un pago (R7.4)

Se aplica a los periodos más antiguos primero; lo que sobra queda como adelanto o saldo a favor en el periodo actual. Desbloquea si ya no queda deuda vencida.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String idempotencyKey = idempotencyKey_example; // String | Obligatorio (8 a 100 caracteres). Un reintento con la misma clave devuelve el resultado original.
final RegisterPaymentDto registerPaymentDto = ; // RegisterPaymentDto | 

try {
    final response = api.adminBillingControllerRegisterPayment(idempotencyKey, registerPaymentDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerRegisterPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Obligatorio (8 a 100 caracteres). Un reintento con la misma clave devuelve el resultado original. | 
 **registerPaymentDto** | [**RegisterPaymentDto**](RegisterPaymentDto.md)|  | 

### Return type

[**PaymentResultDto**](PaymentResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerRejectSubmission**
> PaymentSubmissionDto adminBillingControllerRejectSubmission(id, rejectSubmissionDto)

Rechazar un comprobante

Para aceptarlo se registra el pago con submissionId.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final RejectSubmissionDto rejectSubmissionDto = ; // RejectSubmissionDto | 

try {
    final response = api.adminBillingControllerRejectSubmission(id, rejectSubmissionDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerRejectSubmission: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **rejectSubmissionDto** | [**RejectSubmissionDto**](RejectSubmissionDto.md)|  | 

### Return type

[**PaymentSubmissionDto**](PaymentSubmissionDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerSetQr**
> QrResultDto adminBillingControllerSetQr(setQrDto)

Configurar el QR de cobro (R7.4)

Después del PUT a la URL de subida. Los trabajadores lo ven en \"Pagar comisión\".

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final SetQrDto setQrDto = ; // SetQrDto | 

try {
    final response = api.adminBillingControllerSetQr(setQrDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerSetQr: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setQrDto** | [**SetQrDto**](SetQrDto.md)|  | 

### Return type

[**QrResultDto**](QrResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerSubmissions**
> List<PaymentSubmissionDto> adminBillingControllerSubmissions(status)

Comprobantes enviados por los trabajadores (por defecto, pendientes)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String status = status_example; // String | 

try {
    final response = api.adminBillingControllerSubmissions(status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerSubmissions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'pendiente']

### Return type

[**List&lt;PaymentSubmissionDto&gt;**](PaymentSubmissionDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerWorker**
> AdminWorkerBillingDto adminBillingControllerWorker(id)

Saldo, periodos y movimientos de un trabajador

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 

try {
    final response = api.adminBillingControllerWorker(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerWorker: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminWorkerBillingDto**](AdminWorkerBillingDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCategoriesControllerList**
> List<AdminCategoryDto> adminCategoriesControllerList()

Todas las categorías con sus valores por ciudad

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.adminCategoriesControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCategoriesControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;AdminCategoryDto&gt;**](AdminCategoryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCategoriesControllerUpdate**
> AdminCategoryDto adminCategoriesControllerUpdate(id, updateCategoryDto)

Edita los valores base de una categoría

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final UpdateCategoryDto updateCategoryDto = ; // UpdateCategoryDto | 

try {
    final response = api.adminCategoriesControllerUpdate(id, updateCategoryDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCategoriesControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateCategoryDto** | [**UpdateCategoryDto**](UpdateCategoryDto.md)|  | 

### Return type

[**AdminCategoryDto**](AdminCategoryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCategoriesControllerUpsertCity**
> AdminCategoryDto adminCategoriesControllerUpsertCity(id, cityId, upsertCategoryCityDto)

Activa o ajusta una categoría en una ciudad

Los valores null heredan los de la categoría base.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final String cityId = cityId_example; // String | 
final UpsertCategoryCityDto upsertCategoryCityDto = ; // UpsertCategoryCityDto | 

try {
    final response = api.adminCategoriesControllerUpsertCity(id, cityId, upsertCategoryCityDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCategoriesControllerUpsertCity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cityId** | **String**|  | 
 **upsertCategoryCityDto** | [**UpsertCategoryCityDto**](UpsertCategoryCityDto.md)|  | 

### Return type

[**AdminCategoryDto**](AdminCategoryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminChatControllerHeld**
> List<AdminHeldMessageDto> adminChatControllerHeld()

Mensajes de chat retenidos (los 100 más recientes)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.adminChatControllerHeld();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminChatControllerHeld: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;AdminHeldMessageDto&gt;**](AdminHeldMessageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminJobsControllerDisputed**
> List<AdminDisputedJobDto> adminJobsControllerDisputed()

Trabajos con un problema reportado, sin resolver

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.adminJobsControllerDisputed();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminJobsControllerDisputed: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;AdminDisputedJobDto&gt;**](AdminDisputedJobDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminJobsControllerResolve**
> AdminJobsControllerResolve200Response adminJobsControllerResolve(id, resolveDisputeDto)

Resolver una disputa

confirm → terminado con comisión (job.completed); cancel → cancelado sin comisión. La nota queda en el historial.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final ResolveDisputeDto resolveDisputeDto = ; // ResolveDisputeDto | 

try {
    final response = api.adminJobsControllerResolve(id, resolveDisputeDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminJobsControllerResolve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **resolveDisputeDto** | [**ResolveDisputeDto**](ResolveDisputeDto.md)|  | 

### Return type

[**AdminJobsControllerResolve200Response**](AdminJobsControllerResolve200Response.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReportsControllerList**
> List<AdminReportDto> adminReportsControllerList(status)

Reportes por estado (por defecto, pendientes)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String status = status_example; // String | 

try {
    final response = api.adminReportsControllerList(status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminReportsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'pendiente']

### Return type

[**List&lt;AdminReportDto&gt;**](AdminReportDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReportsControllerResolve**
> ResolveReportResultDto adminReportsControllerResolve(id, resolveReportDto)

Marcar un reporte como válido o descartado

Con 3 reportes válidos de personas distintas, el trabajador queda suspendido (R9.3) o, si solo es empleador, marcado para revisión.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final ResolveReportDto resolveReportDto = ; // ResolveReportDto | 

try {
    final response = api.adminReportsControllerResolve(id, resolveReportDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminReportsControllerResolve: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **resolveReportDto** | [**ResolveReportDto**](ResolveReportDto.md)|  | 

### Return type

[**ResolveReportResultDto**](ResolveReportResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequestsControllerList**
> List<AdminHeldRequestDto> adminRequestsControllerList(status)

Solicitudes por estado (por defecto, las retenidas por moderación)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String status = status_example; // String | 

try {
    final response = api.adminRequestsControllerList(status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequestsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 

### Return type

[**List&lt;AdminHeldRequestDto&gt;**](AdminHeldRequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequestsControllerReject**
> RequestDto adminRequestsControllerReject(id, rejectRequestDto)

Rechaza una solicitud retenida

Queda \"cancelada\" con motivo de moderación (sin estados nuevos en R3.4).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final RejectRequestDto rejectRequestDto = ; // RejectRequestDto | 

try {
    final response = api.adminRequestsControllerReject(id, rejectRequestDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequestsControllerReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **rejectRequestDto** | [**RejectRequestDto**](RejectRequestDto.md)|  | 

### Return type

[**RequestDto**](RequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequestsControllerRelease**
> RequestDto adminRequestsControllerRelease(id)

Libera una solicitud retenida: pasa a \"buscando\"

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 

try {
    final response = api.adminRequestsControllerRelease(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequestsControllerRelease: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RequestDto**](RequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminWorkersControllerDocumentUrl**
> DocumentUrlDto adminWorkersControllerDocumentUrl(userId, documentId)

Enlace temporal a un documento de identidad (R9.5)

Válido 5 minutos. Solo administradores.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String userId = userId_example; // String | 
final String documentId = documentId_example; // String | 

try {
    final response = api.adminWorkersControllerDocumentUrl(userId, documentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminWorkersControllerDocumentUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **documentId** | **String**|  | 

### Return type

[**DocumentUrlDto**](DocumentUrlDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **featureFlagsControllerList**
> List<FeatureFlagDto> featureFlagsControllerList()

Feature flags (globales y por ciudad)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.featureFlagsControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->featureFlagsControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;FeatureFlagDto&gt;**](FeatureFlagDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **featureFlagsControllerSet**
> FeatureFlagDto featureFlagsControllerSet(key, setFeatureFlagDto)

Enciende o apaga un flag

Con cityId solo afecta a esa ciudad; sin cityId es el valor global (R10.2).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String key = key_example; // String | 
final SetFeatureFlagDto setFeatureFlagDto = ; // SetFeatureFlagDto | 

try {
    final response = api.featureFlagsControllerSet(key, setFeatureFlagDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->featureFlagsControllerSet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  | 
 **setFeatureFlagDto** | [**SetFeatureFlagDto**](SetFeatureFlagDto.md)|  | 

### Return type

[**FeatureFlagDto**](FeatureFlagDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **moderationTermsControllerCreate**
> ModerationTermDto moderationTermsControllerCreate(createModerationTermDto)

Agrega un término o patrón

Los regex se validan: máx. 100 caracteres, sin referencias, lookaround ni cuantificadores anidados, y se prueban contra entradas lentas (ADR-0018).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final CreateModerationTermDto createModerationTermDto = ; // CreateModerationTermDto | 

try {
    final response = api.moderationTermsControllerCreate(createModerationTermDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->moderationTermsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createModerationTermDto** | [**CreateModerationTermDto**](CreateModerationTermDto.md)|  | 

### Return type

[**ModerationTermDto**](ModerationTermDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **moderationTermsControllerList**
> List<ModerationTermDto> moderationTermsControllerList(incluirInactivos)

Términos del filtro de moderación

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final bool incluirInactivos = true; // bool | 

try {
    final response = api.moderationTermsControllerList(incluirInactivos);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->moderationTermsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **incluirInactivos** | **bool**|  | [optional] 

### Return type

[**List&lt;ModerationTermDto&gt;**](ModerationTermDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **moderationTermsControllerRemove**
> moderationTermsControllerRemove(id)

Desactiva un término (baja lógica)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 

try {
    api.moderationTermsControllerRemove(id);
} on DioException catch (e) {
    print('Exception when calling AdminApi->moderationTermsControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **moderationTermsControllerUpdate**
> ModerationTermDto moderationTermsControllerUpdate(id, updateModerationTermDto)

Cambia la categoría, la nota o reactiva un término

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final UpdateModerationTermDto updateModerationTermDto = ; // UpdateModerationTermDto | 

try {
    final response = api.moderationTermsControllerUpdate(id, updateModerationTermDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->moderationTermsControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateModerationTermDto** | [**UpdateModerationTermDto**](UpdateModerationTermDto.md)|  | 

### Return type

[**ModerationTermDto**](ModerationTermDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

