import 'package:refresco/core/models/user.dart';

class UpdateUser {
  static String get mutation => r'''
    mutation updateUser(
      $id: ID!
      $email: String!
      $fullName: String!
      $cpf: String!
      $phone: String!
    ) {
      updateUser(
        input: {
          id: $id
          fields: {
            email: $email
            fullName: $fullName
            cpf: $cpf
            phone: $phone
          }
        }
      ) {
        clientMutationId
      }
    }
''';

  static Map<String, dynamic> builder(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'fullName': user.fullName,
      'cpf': user.cpf,
      'phone': user.phone,
    };
  }
}
