class AuthProps {
  String statusCode;
  String mensagem;

  AuthProps(
    this.statusCode,
    this.mensagem,
  );

  factory AuthProps.fromJson(dynamic json) {
    return AuthProps(json['statusCode'] as String, json['mensagem'] as String);
  }
  @override
  String toString() {
    return '{ $statusCode, $mensagem }';
  }
}
