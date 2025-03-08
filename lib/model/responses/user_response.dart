class UserResponse {
  String publicId;
  String nombreUsuario;
  String token;

  UserResponse(this.publicId, this.nombreUsuario, this.token);

  factory UserResponse.fromJsonMap(Map<String, dynamic> json) =>
      UserResponse(json["publicId"], json["nombreUsuario"], json["token"]);
}
