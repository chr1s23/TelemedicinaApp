class UserResponse {
  String publicId;
  String nombreUsuario;
  String nombre;
  String token;
  String? dispositivo;

  UserResponse(this.publicId, this.nombreUsuario, this.nombre, this.token, this.dispositivo);

  factory UserResponse.fromJsonMap(Map<String, dynamic> json) =>
      UserResponse(json["publicId"], json["nombreUsuario"], json["nombre"], json["token"], json["dispositivo"]);
}
