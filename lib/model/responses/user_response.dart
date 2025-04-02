class UserResponse {
  String publicId;
  String nombreUsuario;
  String nombre;
  String token;

  UserResponse(this.publicId, this.nombreUsuario, this.nombre, this.token);

  factory UserResponse.fromJsonMap(Map<String, dynamic> json) =>
      UserResponse(json["publicId"], json["nombreUsuario"], json["nombre"], json["token"]);
}
