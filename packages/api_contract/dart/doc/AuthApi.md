# sisi_api.api.AuthApi

## Load the API package
```dart
import 'package:sisi_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authControllerLogout**](AuthApi.md#authcontrollerlogout) | **POST** /auth/logout | Cierra la sesión (revoca la familia del refresh token)
[**authControllerRefresh**](AuthApi.md#authcontrollerrefresh) | **POST** /auth/refresh | Renueva la sesión (rota el refresh token)
[**authControllerRequestOtp**](AuthApi.md#authcontrollerrequestotp) | **POST** /auth/otp/request | Envía un código de 6 dígitos al celular
[**authControllerVerifyOtp**](AuthApi.md#authcontrollerverifyotp) | **POST** /auth/otp/verify | Valida el código e inicia sesión


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

