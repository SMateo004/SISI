# sisi_api.api.AdminApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminWorkersControllerDocumentUrl**](AdminApi.md#adminworkerscontrollerdocumenturl) | **GET** /admin/workers/{userId}/documents/{documentId}/url | Enlace temporal a un documento de identidad (R9.5)


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

