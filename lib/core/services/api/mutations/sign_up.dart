class SignUp {
  static String get mutation => r'''
    mutation signUp(
      $email: String!
      $password: String!
    ) {
      signUp(
        input: {
          userFields: {
            email: $email
            username: $email
            password: $password
          }
        }
      ) {
        viewer {
          sessionToken
          user {
            objectId
            email
          }
        }
      }
    }
  ''';
}
