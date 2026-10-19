# sisi_api.api.AdminApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminAuditControllerList**](AdminApi.md#adminauditcontrollerlist) | **GET** /admin/audit | Auditoría del panel (ADR-0041)
[**adminBillingControllerCurrentQr**](AdminApi.md#adminbillingcontrollercurrentqr) | **GET** /admin/billing/qr | QR de cobro actual (URL temporal), o null si no hay
[**adminBillingControllerExportLedger**](AdminApi.md#adminbillingcontrollerexportledger) | **GET** /admin/billing/export/ledger.csv | CSV del ledger por rango de fechas [desde, hasta), para el contador
[**adminBillingControllerExportPayments**](AdminApi.md#adminbillingcontrollerexportpayments) | **GET** /admin/billing/export/payments.csv | CSV de pagos por fecha de pago [desde, hasta), para el contador
[**adminBillingControllerLedger**](AdminApi.md#adminbillingcontrollerledger) | **GET** /admin/billing/workers/{id}/ledger | Ledger completo de un trabajador con saldo acumulado
[**adminBillingControllerOverdue**](AdminApi.md#adminbillingcontrolleroverdue) | **GET** /admin/billing/overdue | Periodos vencidos con monto y días de atraso (R7.7)
[**adminBillingControllerPeriods**](AdminApi.md#adminbillingcontrollerperiods) | **GET** /admin/billing/periods | Periodos de cobro con filtros por estado, semana y ciudad
[**adminBillingControllerPreviewAdjustment**](AdminApi.md#adminbillingcontrollerpreviewadjustment) | **POST** /admin/billing/adjustments/preview | Efecto de un ajuste antes de registrarlo (no guarda nada)
[**adminBillingControllerPreviewPayment**](AdminApi.md#adminbillingcontrollerpreviewpayment) | **POST** /admin/billing/payments/preview | Efecto de un pago antes de registrarlo
[**adminBillingControllerQrUploadUrl**](AdminApi.md#adminbillingcontrollerqruploadurl) | **POST** /admin/billing/qr/upload-url | URL para subir la imagen del QR de cobro de la empresa
[**adminBillingControllerReceiptUploadUrl**](AdminApi.md#adminbillingcontrollerreceiptuploadurl) | **POST** /admin/billing/receipts/upload-url | URL para subir el comprobante de un pago (receipts/, privado)
[**adminBillingControllerRegisterAdjustment**](AdminApi.md#adminbillingcontrollerregisteradjustment) | **POST** /admin/billing/adjustments | Registrar un ajuste (R7.9)
[**adminBillingControllerRegisterPayment**](AdminApi.md#adminbillingcontrollerregisterpayment) | **POST** /admin/billing/payments | Registrar un pago (R7.4)
[**adminBillingControllerRejectSubmission**](AdminApi.md#adminbillingcontrollerrejectsubmission) | **POST** /admin/billing/submissions/{id}/reject | Rechazar un comprobante
[**adminBillingControllerSetQr**](AdminApi.md#adminbillingcontrollersetqr) | **PUT** /admin/billing/qr | Configurar el QR de cobro (R7.4)
[**adminBillingControllerSubmissions**](AdminApi.md#adminbillingcontrollersubmissions) | **GET** /admin/billing/submissions | Comprobantes enviados por los trabajadores (por defecto, pendientes)
[**adminBillingControllerWorker**](AdminApi.md#adminbillingcontrollerworker) | **GET** /admin/billing/workers/{id} | Saldo, periodos y movimientos de un trabajador
[**adminCategoriesControllerCreate**](AdminApi.md#admincategoriescontrollercreate) | **POST** /admin/categories | Crea una categoría (R2.2)
[**adminCategoriesControllerList**](AdminApi.md#admincategoriescontrollerlist) | **GET** /admin/categories | Todas las categorías con sus valores por ciudad
[**adminCategoriesControllerUpdate**](AdminApi.md#admincategoriescontrollerupdate) | **PATCH** /admin/categories/{id} | Edita los valores base de una categoría
[**adminCategoriesControllerUpsertCity**](AdminApi.md#admincategoriescontrollerupsertcity) | **PUT** /admin/categories/{id}/cities/{cityId} | Activa o ajusta una categoría en una ciudad
[**adminChatControllerDiscard**](AdminApi.md#adminchatcontrollerdiscard) | **POST** /admin/chat/{messageId}/discard | Descartar un mensaje retenido: no se entrega nunca
[**adminChatControllerHeld**](AdminApi.md#adminchatcontrollerheld) | **GET** /admin/chat/held | Mensajes de chat retenidos, del más antiguo al más nuevo
[**adminChatControllerRelease**](AdminApi.md#adminchatcontrollerrelease) | **POST** /admin/chat/{messageId}/release | Liberar un mensaje retenido: se entrega al destinatario
[**adminCitiesControllerList**](AdminApi.md#admincitiescontrollerlist) | **GET** /admin/cities | Ciudades
[**adminCityAreaControllerGet**](AdminApi.md#admincityareacontrollerget) | **GET** /admin/cities/{id}/service-area | Zona de servicio de la ciudad: polígono GeoJSON o radio (ADR-0052)
[**adminCityAreaControllerSet**](AdminApi.md#admincityareacontrollerset) | **PUT** /admin/cities/{id}/service-area | Cambiar la zona (polígono o radio), con motivo
[**adminCityAreaControllerTest**](AdminApi.md#admincityareacontrollertest) | **POST** /admin/cities/{id}/service-area/test | Probar si un punto está dentro de la zona (sin guardar nada)
[**adminJobsControllerDetail**](AdminApi.md#adminjobscontrollerdetail) | **GET** /admin/jobs/{id} | Detalle de un trabajo para revisar una disputa
[**adminJobsControllerDisputed**](AdminApi.md#adminjobscontrollerdisputed) | **GET** /admin/jobs/disputed | Trabajos con un problema reportado, sin resolver
[**adminJobsControllerResolve**](AdminApi.md#adminjobscontrollerresolve) | **POST** /admin/jobs/{id}/resolve | Resolver una disputa
[**adminOtpCodesControllerList**](AdminApi.md#adminotpcodescontrollerlist) | **GET** /admin/otp-codes | Códigos de ingreso vigentes (solo sin SMS y fuera de producción)
[**adminPilotControllerAdd**](AdminApi.md#adminpilotcontrolleradd) | **POST** /admin/pilot/allowlist | Habilitar números (se pueden pegar varios), con motivo
[**adminPilotControllerInterest**](AdminApi.md#adminpilotcontrollerinterest) | **GET** /admin/pilot/interest | Interés registrado (\&quot;Pronto en tu zona\&quot;), lo más nuevo primero
[**adminPilotControllerInterestCsv**](AdminApi.md#adminpilotcontrollerinterestcsv) | **GET** /admin/pilot/interest.csv | Interés en CSV (para medir la demanda)
[**adminPilotControllerOverview**](AdminApi.md#adminpilotcontrolleroverview) | **GET** /admin/pilot | Piloto cerrado: flag, lista de números e interés (ADR-0052)
[**adminPilotControllerRemove**](AdminApi.md#adminpilotcontrollerremove) | **DELETE** /admin/pilot/allowlist/{id} | Quitar un número de la lista (su cuenta, si ya la creó, sigue)
[**adminReportsControllerList**](AdminApi.md#adminreportscontrollerlist) | **GET** /admin/reports | Reportes por estado (por defecto, pendientes)
[**adminReportsControllerResolve**](AdminApi.md#adminreportscontrollerresolve) | **POST** /admin/reports/{id}/resolve | Marcar un reporte como válido o descartado
[**adminRequestsControllerList**](AdminApi.md#adminrequestscontrollerlist) | **GET** /admin/requests | Solicitudes por estado (por defecto, las retenidas por moderación)
[**adminRequestsControllerReject**](AdminApi.md#adminrequestscontrollerreject) | **POST** /admin/requests/{id}/reject | Rechaza una solicitud retenida
[**adminRequestsControllerRelease**](AdminApi.md#adminrequestscontrollerrelease) | **POST** /admin/requests/{id}/release | Libera una solicitud retenida: pasa a \&quot;buscando\&quot;
[**adminSettingsControllerList**](AdminApi.md#adminsettingscontrollerlist) | **GET** /admin/settings | Parámetros de negocio editables (ADR-0043)
[**adminSettingsControllerReset**](AdminApi.md#adminsettingscontrollerreset) | **POST** /admin/settings/{key}/reset | Volver al valor por defecto (variable de entorno)
[**adminSettingsControllerSet**](AdminApi.md#adminsettingscontrollerset) | **PUT** /admin/settings/{key} | Cambiar un parámetro, con motivo
[**adminUsersControllerClearFlag**](AdminApi.md#adminuserscontrollerclearflag) | **POST** /admin/users/{id}/clear-flag | Quitar la marca \&quot;revisar\&quot; de un empleador reportado
[**adminUsersControllerProfile**](AdminApi.md#adminuserscontrollerprofile) | **GET** /admin/users/{id} | Ficha de un usuario
[**adminUsersControllerReactivate**](AdminApi.md#adminuserscontrollerreactivate) | **POST** /admin/workers/{id}/reactivate | Levantar la suspensión
[**adminUsersControllerSearch**](AdminApi.md#adminuserscontrollersearch) | **GET** /admin/users | Buscar usuarios por teléfono o nombre
[**adminUsersControllerSuspend**](AdminApi.md#adminuserscontrollersuspend) | **POST** /admin/workers/{id}/suspend | Suspender el perfil de trabajador
[**dashboardControllerCounters**](AdminApi.md#dashboardcontrollercounters) | **GET** /admin/counters | Colas pendientes para el menú del panel
[**dashboardControllerGet**](AdminApi.md#dashboardcontrollerget) | **GET** /admin/dashboard | Dashboard del día o de la semana (hora local de la ciudad)
[**dashboardControllerPilot**](AdminApi.md#dashboardcontrollerpilot) | **GET** /admin/dashboard/pilot | Métricas del piloto (ADR-0052)
[**featureFlagsControllerList**](AdminApi.md#featureflagscontrollerlist) | **GET** /admin/feature-flags | Feature flags (globales y por ciudad)
[**featureFlagsControllerSet**](AdminApi.md#featureflagscontrollerset) | **PUT** /admin/feature-flags/{key} | Enciende o apaga un flag
[**moderationTermsControllerCreate**](AdminApi.md#moderationtermscontrollercreate) | **POST** /admin/moderation-terms | Agrega un término o patrón
[**moderationTermsControllerList**](AdminApi.md#moderationtermscontrollerlist) | **GET** /admin/moderation-terms | Términos del filtro de moderación
[**moderationTermsControllerRemove**](AdminApi.md#moderationtermscontrollerremove) | **DELETE** /admin/moderation-terms/{id} | Desactiva un término (baja lógica)
[**moderationTermsControllerTest**](AdminApi.md#moderationtermscontrollertest) | **POST** /admin/moderation-terms/test | Probador: qué términos vigentes coinciden con un texto
[**moderationTermsControllerUpdate**](AdminApi.md#moderationtermscontrollerupdate) | **PATCH** /admin/moderation-terms/{id} | Cambia la categoría, la nota o reactiva un término
[**verificationsControllerApprove**](AdminApi.md#verificationscontrollerapprove) | **POST** /admin/verifications/{userId}/approve | Aprobar: el perfil pasa a aprobado y se le avisa (push)
[**verificationsControllerDetail**](AdminApi.md#verificationscontrollerdetail) | **GET** /admin/verifications/{userId} | Detalle de una solicitud de trabajador
[**verificationsControllerDocumentUrl**](AdminApi.md#verificationscontrollerdocumenturl) | **GET** /admin/workers/{userId}/documents/{documentId}/url | Enlace temporal a un documento de identidad (R9.5)
[**verificationsControllerQueue**](AdminApi.md#verificationscontrollerqueue) | **GET** /admin/verifications | Cola de verificaciones (pendiente_revision)
[**verificationsControllerReject**](AdminApi.md#verificationscontrollerreject) | **POST** /admin/verifications/{userId}/reject | Rechazar con motivo de la lista y nota


# **adminAuditControllerList**
> AuditPageDto adminAuditControllerList(adminId, action, targetType, targetId, from, to, cursor)

Auditoría del panel (ADR-0041)

De la más nueva a la más vieja, 50 por página. Filtros combinables.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String adminId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String action = billing.; // String | Acción o prefijo (p. ej. \"billing.\" trae todas las de cobros)
final String targetType = worker; // String | 
final String targetId = targetId_example; // String | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | Desde (incluido)
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | Hasta (excluido)
final String cursor = cursor_example; // String | nextCursor de la página anterior

try {
    final response = api.adminAuditControllerList(adminId, action, targetType, targetId, from, to, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminAuditControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminId** | **String**|  | [optional] 
 **action** | **String**| Acción o prefijo (p. ej. \"billing.\" trae todas las de cobros) | [optional] 
 **targetType** | **String**|  | [optional] 
 **targetId** | **String**|  | [optional] 
 **from** | **DateTime**| Desde (incluido) | [optional] 
 **to** | **DateTime**| Hasta (excluido) | [optional] 
 **cursor** | **String**| nextCursor de la página anterior | [optional] 

### Return type

[**AuditPageDto**](AuditPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerCurrentQr**
> CurrentQrDto adminBillingControllerCurrentQr()

QR de cobro actual (URL temporal), o null si no hay

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.adminBillingControllerCurrentQr();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerCurrentQr: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CurrentQrDto**](CurrentQrDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerExportLedger**
> adminBillingControllerExportLedger(from, to)

CSV del ledger por rango de fechas [desde, hasta), para el contador

UTF-8 con BOM, separador coma, montos con punto decimal y fechas en la hora local de la ciudad. Queda auditado.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final DateTime from = 2026-10-01T04:00Z; // DateTime | 
final DateTime to = 2026-11-01T04:00Z; // DateTime | 

try {
    api.adminBillingControllerExportLedger(from, to);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerExportLedger: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | 
 **to** | **DateTime**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerExportPayments**
> adminBillingControllerExportPayments(from, to)

CSV de pagos por fecha de pago [desde, hasta), para el contador

Mismo formato que el del ledger. Queda auditado.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final DateTime from = 2026-10-01T04:00Z; // DateTime | 
final DateTime to = 2026-11-01T04:00Z; // DateTime | 

try {
    api.adminBillingControllerExportPayments(from, to);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerExportPayments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | 
 **to** | **DateTime**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerLedger**
> LedgerPageDto adminBillingControllerLedger(id, cursor)

Ledger completo de un trabajador con saldo acumulado

Del más nuevo al más viejo, 50 por página.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final String cursor = 40; // String | nextCursor de la página anterior

try {
    final response = api.adminBillingControllerLedger(id, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerLedger: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cursor** | **String**| nextCursor de la página anterior | [optional] 

### Return type

[**LedgerPageDto**](LedgerPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerOverdue**
> OverdueListDto adminBillingControllerOverdue()

Periodos vencidos con monto y días de atraso (R7.7)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.adminBillingControllerOverdue();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerOverdue: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OverdueListDto**](OverdueListDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerPeriods**
> PanelPeriodPageDto adminBillingControllerPeriods(status, week, cityId, cursor)

Periodos de cobro con filtros por estado, semana y ciudad

Más nuevos primero, 25 por página. El saldo es la suma del ledger.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String status = status_example; // String | 
final String week = 2026-W42; // String | Semana ISO del inicio del periodo
final String cityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | nextCursor de la página anterior

try {
    final response = api.adminBillingControllerPeriods(status, week, cityId, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerPeriods: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **week** | **String**| Semana ISO del inicio del periodo | [optional] 
 **cityId** | **String**|  | [optional] 
 **cursor** | **String**| nextCursor de la página anterior | [optional] 

### Return type

[**PanelPeriodPageDto**](PanelPeriodPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerPreviewAdjustment**
> BalancePreviewDto adminBillingControllerPreviewAdjustment(adjustmentPreviewDto)

Efecto de un ajuste antes de registrarlo (no guarda nada)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final AdjustmentPreviewDto adjustmentPreviewDto = ; // AdjustmentPreviewDto | 

try {
    final response = api.adminBillingControllerPreviewAdjustment(adjustmentPreviewDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerPreviewAdjustment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adjustmentPreviewDto** | [**AdjustmentPreviewDto**](AdjustmentPreviewDto.md)|  | 

### Return type

[**BalancePreviewDto**](BalancePreviewDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminBillingControllerPreviewPayment**
> BalancePreviewDto adminBillingControllerPreviewPayment(paymentPreviewDto)

Efecto de un pago antes de registrarlo

Saldo antes y después, periodos que cubre y si desbloquea. No guarda nada.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final PaymentPreviewDto paymentPreviewDto = ; // PaymentPreviewDto | 

try {
    final response = api.adminBillingControllerPreviewPayment(paymentPreviewDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminBillingControllerPreviewPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentPreviewDto** | [**PaymentPreviewDto**](PaymentPreviewDto.md)|  | 

### Return type

[**BalancePreviewDto**](BalancePreviewDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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
> List<AdminPaymentSubmissionDto> adminBillingControllerSubmissions(status)

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

[**List&lt;AdminPaymentSubmissionDto&gt;**](AdminPaymentSubmissionDto.md)

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

# **adminCategoriesControllerCreate**
> AdminCategoryDto adminCategoriesControllerCreate(createCategoryDto)

Crea una categoría (R2.2)

Con rango, comisión (13 % por defecto), requisitos extra y las ciudades donde queda activa.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final CreateCategoryDto createCategoryDto = ; // CreateCategoryDto | 

try {
    final response = api.adminCategoriesControllerCreate(createCategoryDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCategoriesControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createCategoryDto** | [**CreateCategoryDto**](CreateCategoryDto.md)|  | 

### Return type

[**AdminCategoryDto**](AdminCategoryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
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

Si cambia la comisión, `notice` avisa que solo afecta a los trabajos asignados desde ahora.

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

# **adminChatControllerDiscard**
> AdminHeldMessageDto adminChatControllerDiscard(messageId, moderationDecisionDto)

Descartar un mensaje retenido: no se entrega nunca

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String messageId = messageId_example; // String | 
final ModerationDecisionDto moderationDecisionDto = ; // ModerationDecisionDto | 

try {
    final response = api.adminChatControllerDiscard(messageId, moderationDecisionDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminChatControllerDiscard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messageId** | **String**|  | 
 **moderationDecisionDto** | [**ModerationDecisionDto**](ModerationDecisionDto.md)|  | 

### Return type

[**AdminHeldMessageDto**](AdminHeldMessageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminChatControllerHeld**
> AdminHeldMessagePageDto adminChatControllerHeld(cursor)

Mensajes de chat retenidos, del más antiguo al más nuevo

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String cursor = cursor_example; // String | nextCursor de la página anterior

try {
    final response = api.adminChatControllerHeld(cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminChatControllerHeld: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| nextCursor de la página anterior | [optional] 

### Return type

[**AdminHeldMessagePageDto**](AdminHeldMessagePageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminChatControllerRelease**
> AdminHeldMessageDto adminChatControllerRelease(messageId, moderationDecisionDto)

Liberar un mensaje retenido: se entrega al destinatario

Con motivo; queda en la auditoría.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String messageId = messageId_example; // String | 
final ModerationDecisionDto moderationDecisionDto = ; // ModerationDecisionDto | 

try {
    final response = api.adminChatControllerRelease(messageId, moderationDecisionDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminChatControllerRelease: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **messageId** | **String**|  | 
 **moderationDecisionDto** | [**ModerationDecisionDto**](ModerationDecisionDto.md)|  | 

### Return type

[**AdminHeldMessageDto**](AdminHeldMessageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCitiesControllerList**
> List<AdminCityDto> adminCitiesControllerList()

Ciudades

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.adminCitiesControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCitiesControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;AdminCityDto&gt;**](AdminCityDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCityAreaControllerGet**
> CityAreaDto adminCityAreaControllerGet(id)

Zona de servicio de la ciudad: polígono GeoJSON o radio (ADR-0052)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 

try {
    final response = api.adminCityAreaControllerGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCityAreaControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**CityAreaDto**](CityAreaDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCityAreaControllerSet**
> CityAreaDto adminCityAreaControllerSet(id, setCityAreaDto)

Cambiar la zona (polígono o radio), con motivo

Se valida el GeoJSON (un contorno cerrado dentro de Bolivia, válido en PostGIS y con el centro adentro). Vale para las solicitudes nuevas.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final SetCityAreaDto setCityAreaDto = ; // SetCityAreaDto | 

try {
    final response = api.adminCityAreaControllerSet(id, setCityAreaDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCityAreaControllerSet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **setCityAreaDto** | [**SetCityAreaDto**](SetCityAreaDto.md)|  | 

### Return type

[**CityAreaDto**](CityAreaDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCityAreaControllerTest**
> TestPointResultDto adminCityAreaControllerTest(id, testPointDto)

Probar si un punto está dentro de la zona (sin guardar nada)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final TestPointDto testPointDto = ; // TestPointDto | 

try {
    final response = api.adminCityAreaControllerTest(id, testPointDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminCityAreaControllerTest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **testPointDto** | [**TestPointDto**](TestPointDto.md)|  | 

### Return type

[**TestPointResultDto**](TestPointResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminJobsControllerDetail**
> AdminJobDetailDto adminJobsControllerDetail(id)

Detalle de un trabajo para revisar una disputa

Partes, solicitud, montos, línea de tiempo (job_events), todo el chat (incluido lo retenido) y las ofertas con su historial (offer_events).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 

try {
    final response = api.adminJobsControllerDetail(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminJobsControllerDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminJobDetailDto**](AdminJobDetailDto.md)

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

confirm → terminado con comisión (job.completed); cancel → cancelado sin comisión. La nota queda en el historial y en la auditoría.

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

# **adminOtpCodesControllerList**
> OtpCodesDto adminOtpCodesControllerList()

Códigos de ingreso vigentes (solo sin SMS y fuera de producción)

El más reciente primero; cada código queda hasta que vence y se marca al usarse.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.adminOtpCodesControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminOtpCodesControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OtpCodesDto**](OtpCodesDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPilotControllerAdd**
> AddPilotPhonesResultDto adminPilotControllerAdd(addPilotPhonesDto)

Habilitar números (se pueden pegar varios), con motivo

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final AddPilotPhonesDto addPilotPhonesDto = ; // AddPilotPhonesDto | 

try {
    final response = api.adminPilotControllerAdd(addPilotPhonesDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPilotControllerAdd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addPilotPhonesDto** | [**AddPilotPhonesDto**](AddPilotPhonesDto.md)|  | 

### Return type

[**AddPilotPhonesResultDto**](AddPilotPhonesResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPilotControllerInterest**
> List<PilotInterestRowDto> adminPilotControllerInterest(cityId)

Interés registrado (\"Pronto en tu zona\"), lo más nuevo primero

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String cityId = cityId_example; // String | 

try {
    final response = api.adminPilotControllerInterest(cityId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPilotControllerInterest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cityId** | **String**|  | [optional] 

### Return type

[**List&lt;PilotInterestRowDto&gt;**](PilotInterestRowDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPilotControllerInterestCsv**
> adminPilotControllerInterestCsv(cityId)

Interés en CSV (para medir la demanda)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String cityId = cityId_example; // String | 

try {
    api.adminPilotControllerInterestCsv(cityId);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPilotControllerInterestCsv: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cityId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPilotControllerOverview**
> PilotOverviewDto adminPilotControllerOverview(cityId)

Piloto cerrado: flag, lista de números e interés (ADR-0052)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String cityId = cityId_example; // String | 

try {
    final response = api.adminPilotControllerOverview(cityId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPilotControllerOverview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cityId** | **String**|  | [optional] 

### Return type

[**PilotOverviewDto**](PilotOverviewDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPilotControllerRemove**
> adminPilotControllerRemove(id, removePilotPhoneDto)

Quitar un número de la lista (su cuenta, si ya la creó, sigue)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final RemovePilotPhoneDto removePilotPhoneDto = ; // RemovePilotPhoneDto | 

try {
    api.adminPilotControllerRemove(id, removePilotPhoneDto);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminPilotControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **removePilotPhoneDto** | [**RemovePilotPhoneDto**](RemovePilotPhoneDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminReportsControllerList**
> AdminReportPageDto adminReportsControllerList(status, cursor)

Reportes por estado (por defecto, pendientes)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String status = status_example; // String | 
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | nextCursor de la página anterior

try {
    final response = api.adminReportsControllerList(status, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminReportsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'pendiente']
 **cursor** | **String**| nextCursor de la página anterior | [optional] 

### Return type

[**AdminReportPageDto**](AdminReportPageDto.md)

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
> AdminRequestPageDto adminRequestsControllerList(status, cursor)

Solicitudes por estado (por defecto, las retenidas por moderación)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String status = status_example; // String | 
final String cursor = cursor_example; // String | nextCursor de la página anterior

try {
    final response = api.adminRequestsControllerList(status, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequestsControllerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **cursor** | **String**| nextCursor de la página anterior | [optional] 

### Return type

[**AdminRequestPageDto**](AdminRequestPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequestsControllerReject**
> RequestDto adminRequestsControllerReject(id, moderationDecisionDto)

Rechaza una solicitud retenida

Queda \"cancelada\" con motivo de moderación (sin estados nuevos en R3.4).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final ModerationDecisionDto moderationDecisionDto = ; // ModerationDecisionDto | 

try {
    final response = api.adminRequestsControllerReject(id, moderationDecisionDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequestsControllerReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **moderationDecisionDto** | [**ModerationDecisionDto**](ModerationDecisionDto.md)|  | 

### Return type

[**RequestDto**](RequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRequestsControllerRelease**
> RequestDto adminRequestsControllerRelease(id, moderationDecisionDto)

Libera una solicitud retenida: pasa a \"buscando\"

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final ModerationDecisionDto moderationDecisionDto = ; // ModerationDecisionDto | 

try {
    final response = api.adminRequestsControllerRelease(id, moderationDecisionDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminRequestsControllerRelease: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **moderationDecisionDto** | [**ModerationDecisionDto**](ModerationDecisionDto.md)|  | 

### Return type

[**RequestDto**](RequestDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSettingsControllerList**
> List<SettingDto> adminSettingsControllerList()

Parámetros de negocio editables (ADR-0043)

Valor vigente, valor por defecto (entorno), rango y unidad.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.adminSettingsControllerList();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSettingsControllerList: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List&lt;SettingDto&gt;**](SettingDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSettingsControllerReset**
> SettingDto adminSettingsControllerReset(key, resetSettingDto)

Volver al valor por defecto (variable de entorno)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String key = key_example; // String | 
final ResetSettingDto resetSettingDto = ; // ResetSettingDto | 

try {
    final response = api.adminSettingsControllerReset(key, resetSettingDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSettingsControllerReset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  | 
 **resetSettingDto** | [**ResetSettingDto**](ResetSettingDto.md)|  | 

### Return type

[**SettingDto**](SettingDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminSettingsControllerSet**
> SettingDto adminSettingsControllerSet(key, setSettingDto)

Cambiar un parámetro, con motivo

Se valida el rango. API, worker y cron lo toman en segundos, sin redeploy.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String key = key_example; // String | 
final SetSettingDto setSettingDto = ; // SetSettingDto | 

try {
    final response = api.adminSettingsControllerSet(key, setSettingDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminSettingsControllerSet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  | 
 **setSettingDto** | [**SetSettingDto**](SetSettingDto.md)|  | 

### Return type

[**SettingDto**](SettingDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUsersControllerClearFlag**
> UserRowDto adminUsersControllerClearFlag(id, reasonDto)

Quitar la marca \"revisar\" de un empleador reportado

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final ReasonDto reasonDto = ; // ReasonDto | 

try {
    final response = api.adminUsersControllerClearFlag(id, reasonDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminUsersControllerClearFlag: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **reasonDto** | [**ReasonDto**](ReasonDto.md)|  | 

### Return type

[**UserRowDto**](UserRowDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUsersControllerProfile**
> UserProfileDto adminUsersControllerProfile(id)

Ficha de un usuario

Estado, modo, ciudad, calificaciones, cancelaciones, reportes recibidos, trabajos, saldo y periodos.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 

try {
    final response = api.adminUsersControllerProfile(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminUsersControllerProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**UserProfileDto**](UserProfileDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUsersControllerReactivate**
> WorkerStatusResultDto adminUsersControllerReactivate(id, reasonDto)

Levantar la suspensión

Vuelve a aprobado, o a bloqueado_deuda si tiene un periodo vencido.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final ReasonDto reasonDto = ; // ReasonDto | 

try {
    final response = api.adminUsersControllerReactivate(id, reasonDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminUsersControllerReactivate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **reasonDto** | [**ReasonDto**](ReasonDto.md)|  | 

### Return type

[**WorkerStatusResultDto**](WorkerStatusResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUsersControllerSearch**
> UserPageDto adminUsersControllerSearch(q, cursor)

Buscar usuarios por teléfono o nombre

25 por página.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String q = 7001; // String | Teléfono (dígitos, con o sin +591) o parte del nombre. Vacío: los más nuevos.
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | nextCursor de la página anterior

try {
    final response = api.adminUsersControllerSearch(q, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminUsersControllerSearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| Teléfono (dígitos, con o sin +591) o parte del nombre. Vacío: los más nuevos. | [optional] 
 **cursor** | **String**| nextCursor de la página anterior | [optional] 

### Return type

[**UserPageDto**](UserPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUsersControllerSuspend**
> WorkerStatusResultDto adminUsersControllerSuspend(id, reasonDto)

Suspender el perfil de trabajador

Pasa a suspendido_moderacion y a modo empleador (R1.6). Solo trabajadores.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String id = id_example; // String | 
final ReasonDto reasonDto = ; // ReasonDto | 

try {
    final response = api.adminUsersControllerSuspend(id, reasonDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->adminUsersControllerSuspend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **reasonDto** | [**ReasonDto**](ReasonDto.md)|  | 

### Return type

[**WorkerStatusResultDto**](WorkerStatusResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dashboardControllerCounters**
> CountersDto dashboardControllerCounters()

Colas pendientes para el menú del panel

También llegan en vivo por el evento admin:counters (ADR-0044).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();

try {
    final response = api.dashboardControllerCounters();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->dashboardControllerCounters: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CountersDto**](CountersDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dashboardControllerGet**
> DashboardDto dashboardControllerGet(range, cityId)

Dashboard del día o de la semana (hora local de la ciudad)

Solicitudes, asignación, expiración, tiempo a la primera oferta, trabajos, cancelaciones, comisión, deuda vencida, disponibles ahora y colas.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String range = range_example; // String | 
final String cityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Por defecto, la ciudad principal

try {
    final response = api.dashboardControllerGet(range, cityId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->dashboardControllerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **range** | **String**|  | [optional] [default to 'day']
 **cityId** | **String**| Por defecto, la ciudad principal | [optional] 

### Return type

[**DashboardDto**](DashboardDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dashboardControllerPilot**
> PilotMetricsDto dashboardControllerPilot(range, cityId)

Métricas del piloto (ADR-0052)

Embudo (creada → con oferta → asignada → terminada → comisión cobrada), primera oferta, expiración, tasa de cobro y retención semanal de trabajadores y empleadores, desde el inicio del piloto.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String range = range_example; // String | 
final String cityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Por defecto, la ciudad principal

try {
    final response = api.dashboardControllerPilot(range, cityId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->dashboardControllerPilot: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **range** | **String**|  | [optional] [default to 'day']
 **cityId** | **String**| Por defecto, la ciudad principal | [optional] 

### Return type

[**PilotMetricsDto**](PilotMetricsDto.md)

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

# **moderationTermsControllerTest**
> ModerationTestResultDto moderationTermsControllerTest(testModerationDto)

Probador: qué términos vigentes coinciden con un texto

Mismo filtro y presupuesto de tiempo que las solicitudes y el chat. No guarda nada.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final TestModerationDto testModerationDto = ; // TestModerationDto | 

try {
    final response = api.moderationTermsControllerTest(testModerationDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->moderationTermsControllerTest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **testModerationDto** | [**TestModerationDto**](TestModerationDto.md)|  | 

### Return type

[**ModerationTestResultDto**](ModerationTestResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
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

# **verificationsControllerApprove**
> VerificationResultDto verificationsControllerApprove(userId, approveVerificationDto)

Aprobar: el perfil pasa a aprobado y se le avisa (push)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String userId = userId_example; // String | 
final ApproveVerificationDto approveVerificationDto = ; // ApproveVerificationDto | 

try {
    final response = api.verificationsControllerApprove(userId, approveVerificationDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->verificationsControllerApprove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **approveVerificationDto** | [**ApproveVerificationDto**](ApproveVerificationDto.md)|  | 

### Return type

[**VerificationResultDto**](VerificationResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verificationsControllerDetail**
> VerificationDetailDto verificationsControllerDetail(userId)

Detalle de una solicitud de trabajador

Datos, edad, categorías con sus requisitos extra y documentos por URL temporal de 5 minutos (R9.5). Queda auditado.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String userId = userId_example; // String | 

try {
    final response = api.verificationsControllerDetail(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->verificationsControllerDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**VerificationDetailDto**](VerificationDetailDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verificationsControllerDocumentUrl**
> DocumentUrlDto verificationsControllerDocumentUrl(userId, documentId)

Enlace temporal a un documento de identidad (R9.5)

Válido 5 minutos, sin caché. Queda auditado.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String userId = userId_example; // String | 
final String documentId = documentId_example; // String | 

try {
    final response = api.verificationsControllerDocumentUrl(userId, documentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->verificationsControllerDocumentUrl: $e\n');
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

# **verificationsControllerQueue**
> VerificationPageDto verificationsControllerQueue(cursor)

Cola de verificaciones (pendiente_revision)

De la más antigua a la más nueva, 25 por página.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | nextCursor de la página anterior

try {
    final response = api.verificationsControllerQueue(cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->verificationsControllerQueue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| nextCursor de la página anterior | [optional] 

### Return type

[**VerificationPageDto**](VerificationPageDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verificationsControllerReject**
> VerificationResultDto verificationsControllerReject(userId, rejectVerificationDto)

Rechazar con motivo de la lista y nota

El trabajador ve el motivo y la nota, y puede corregir y volver a enviar.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAdminApi();
final String userId = userId_example; // String | 
final RejectVerificationDto rejectVerificationDto = ; // RejectVerificationDto | 

try {
    final response = api.verificationsControllerReject(userId, rejectVerificationDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->verificationsControllerReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **rejectVerificationDto** | [**RejectVerificationDto**](RejectVerificationDto.md)|  | 

### Return type

[**VerificationResultDto**](VerificationResultDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

