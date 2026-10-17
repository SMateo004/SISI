# sisi_api.api.CalificacionesApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**reviewsControllerForJob**](CalificacionesApi.md#reviewscontrollerforjob) | **GET** /jobs/{id}/reviews | Calificaciones del trabajo (la mía y, si ya es visible, la recibida)
[**reviewsControllerForUser**](CalificacionesApi.md#reviewscontrollerforuser) | **GET** /users/{id}/reviews | Calificaciones publicadas de un usuario
[**reviewsControllerSubmit**](CalificacionesApi.md#reviewscontrollersubmit) | **POST** /jobs/{id}/review | Calificar a la contraparte (1 a 5 estrellas y comentario opcional)


# **reviewsControllerForJob**
> JobReviewsDto reviewsControllerForJob(id)

Calificaciones del trabajo (la mía y, si ya es visible, la recibida)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getCalificacionesApi();
final String id = id_example; // String | 

try {
    final response = api.reviewsControllerForJob(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CalificacionesApi->reviewsControllerForJob: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**JobReviewsDto**](JobReviewsDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewsControllerForUser**
> UserReviewsDto reviewsControllerForUser(id, role, cursor)

Calificaciones publicadas de un usuario

Como trabajador o como empleador, con su promedio.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getCalificacionesApi();
final String id = id_example; // String | 
final String role = role_example; // String | Como trabajador o como empleador
final String cursor = cursor_example; // String | 

try {
    final response = api.reviewsControllerForUser(id, role, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CalificacionesApi->reviewsControllerForUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **role** | **String**| Como trabajador o como empleador | 
 **cursor** | **String**|  | [optional] 

### Return type

[**UserReviewsDto**](UserReviewsDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewsControllerSubmit**
> JobReviewsDto reviewsControllerSubmit(id, createReviewDto)

Calificar a la contraparte (1 a 5 estrellas y comentario opcional)

Una vez por trabajo, solo terminado y dentro de los 7 días. Es ciega: la contraparte la ve cuando califiquen los dos o venza el plazo. El comentario se modera.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getCalificacionesApi();
final String id = id_example; // String | 
final CreateReviewDto createReviewDto = ; // CreateReviewDto | 

try {
    final response = api.reviewsControllerSubmit(id, createReviewDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CalificacionesApi->reviewsControllerSubmit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **createReviewDto** | [**CreateReviewDto**](CreateReviewDto.md)|  | 

### Return type

[**JobReviewsDto**](JobReviewsDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

