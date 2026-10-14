enum ActiveMode {
  employer('employer', 'Empleador'),
  worker('worker', 'Trabajador');

  const ActiveMode(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static ActiveMode fromApi(String? value) =>
      value == 'worker' ? worker : employer;
}

/// Cuenta del usuario (GET /me).
class AppUser {
  const AppUser({
    required this.id,
    required this.phone,
    required this.activeMode,
    this.name,
    this.photoUrl,
    this.isAdmin = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    phone: json['phone'] as String,
    name: json['name'] as String?,
    photoUrl: json['photoUrl'] as String?,
    isAdmin: json['role'] == 'admin',
    activeMode: ActiveMode.fromApi(json['activeMode'] as String?),
  );

  final String id;
  final String phone;
  final String? name;
  final String? photoUrl;
  final bool isAdmin;
  final ActiveMode activeMode;

  String get displayName => (name == null || name!.isEmpty) ? phone : name!;

  AppUser copyWith({ActiveMode? activeMode}) => AppUser(
    id: id,
    phone: phone,
    name: name,
    photoUrl: photoUrl,
    isAdmin: isAdmin,
    activeMode: activeMode ?? this.activeMode,
  );
}
