# sisi_api.api.AdminApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminCategoriesControllerList**](AdminApi.md#admincategoriescontrollerlist) | **GET** /admin/categories | Todas las categorías con sus valores por ciudad
[**adminCategoriesControllerUpdate**](AdminApi.md#admincategoriescontrollerupdate) | **PATCH** /admin/categories/{id} | Edita los valores base de una categoría
[**adminCategoriesControllerUpsertCity**](AdminApi.md#admincategoriescontrollerupsertcity) | **PUT** /admin/categories/{id}/cities/{cityId} | Activa o ajusta una categoría en una ciudad
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

