# sisi_api.api.AuthApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminAuthControllerLogout**](AuthApi.md#adminauthcontrollerlogout) | **POST** /auth/admin/logout | Cierra la sesión del panel (revoca el refresh y borra la cookie)
[**adminAuthControllerRefresh**](AuthApi.md#adminauthcontrollerrefresh) | **POST** /auth/admin/refresh | Renueva el token de acceso del panel con la cookie
[**adminAuthControllerVerify**](AuthApi.md#adminauthcontrollerverify) | **POST** /auth/admin/otp/verify | Valida el código e inicia sesión en el panel
[**authControllerLogout**](AuthApi.md#authcontrollerlogout) | **POST** /auth/logout | Cierra la sesión (revoca la familia del refresh token)
[**authControllerRefresh**](AuthApi.md#authcontrollerrefresh) | **POST** /auth/refresh | Renueva la sesión (rota el refresh token)
[**authControllerRequestOtp**](AuthApi.md#authcontrollerrequestotp) | **POST** /auth/otp/request | Envía un código de 6 dígitos al celular
[**authControllerVerifyOtp**](AuthApi.md#authcontrollerverifyotp) | **POST** /auth/otp/verify | Valida el código e inicia sesión


# **adminAuthControllerLogout**
> adminAuthControllerLogout(xSISIAdmin)

Cierra la sesión del panel (revoca el refresh y borra la cookie)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAuthApi();
final String xSISIAdmin = xSISIAdmin_example; // String | Siempre \"1\" (CSRF)

try {
    api.adminAuthControllerLogout(xSISIAdmin);
} on DioException catch (e) {
    print('Exception when calling AuthApi->adminAuthControllerLogout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xSISIAdmin** | **String**| Siempre \"1\" (CSRF) | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuthControllerRefresh**
> AdminSessionDto adminAuthControllerRefresh(xSISIAdmin)

Renueva el token de acceso del panel con la cookie

Rota el refresh. La sesión no se extiende más allá de 8 h desde el login.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAuthApi();
final String xSISIAdmin = xSISIAdmin_example; // String | Siempre \"1\" (CSRF)

try {
    final response = api.adminAuthControllerRefresh(xSISIAdmin);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->adminAuthControllerRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xSISIAdmin** | **String**| Siempre \"1\" (CSRF) | 

### Return type

[**AdminSessionDto**](AdminSessionDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminAuthControllerVerify**
> AdminSessionDto adminAuthControllerVerify(verifyOtpDto)

Valida el código e inicia sesión en el panel

Solo cuentas con rol admin; no crea cuentas. El refresh queda en la cookie httpOnly `sisi_admin_rt`.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAuthApi();
final VerifyOtpDto verifyOtpDto = ; // VerifyOtpDto | 

try {
    final response = api.adminAuthControllerVerify(verifyOtpDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->adminAuthControllerVerify: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyOtpDto** | [**VerifyOtpDto**](VerifyOtpDto.md)|  | 

### Return type

[**AdminSessionDto**](AdminSessionDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLogout**
> authControllerLogout(refreshTokenDto)

Cierra la sesión (revoca la familia del refresh token)

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAuthApi();
final RefreshTokenDto refreshTokenDto = ; // RefreshTokenDto | 

try {
    api.authControllerLogout(refreshTokenDto);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerLogout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokenDto** | [**RefreshTokenDto**](RefreshTokenDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRefresh**
> TokensDto authControllerRefresh(refreshTokenDto)

Renueva la sesión (rota el refresh token)

Cada refresh se usa una sola vez. Reutilizar uno ya usado revoca todas las sesiones de esa familia.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAuthApi();
final RefreshTokenDto refreshTokenDto = ; // RefreshTokenDto | 

try {
    final response = api.authControllerRefresh(refreshTokenDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokenDto** | [**RefreshTokenDto**](RefreshTokenDto.md)|  | 

### Return type

[**TokensDto**](TokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRequestOtp**
> OtpRequestedDto authControllerRequestOtp(requestOtpDto)

Envía un código de 6 dígitos al celular

La respuesta es la misma tenga o no cuenta el número. Límites: 1 código cada 60 s, 5 por hora y 10 por día por número; 20 por hora por IP.

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAuthApi();
final RequestOtpDto requestOtpDto = ; // RequestOtpDto | 

try {
    final response = api.authControllerRequestOtp(requestOtpDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerRequestOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestOtpDto** | [**RequestOtpDto**](RequestOtpDto.md)|  | 

### Return type

[**OtpRequestedDto**](OtpRequestedDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerVerifyOtp**
> LoginResponseDto authControllerVerifyOtp(verifyOtpDto)

Valida el código e inicia sesión

Crea la cuenta si el número no tenía una (modo employer, R1.2).

### Example
```dart
import 'package:sisi_api/api.dart';

final api = SisiApi().getAuthApi();
final VerifyOtpDto verifyOtpDto = ; // VerifyOtpDto | 

try {
    final response = api.authControllerVerifyOtp(verifyOtpDto);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->authControllerVerifyOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verifyOtpDto** | [**VerifyOtpDto**](VerifyOtpDto.md)|  | 

### Return type

[**LoginResponseDto**](LoginResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

