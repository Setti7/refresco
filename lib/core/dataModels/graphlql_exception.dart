class GraphQlException implements Exception {
  String errorMessage;
  String errorTitle;
  Exception exception;

  GraphQlException({this.errorTitle, this.errorMessage, this.exception});
}
