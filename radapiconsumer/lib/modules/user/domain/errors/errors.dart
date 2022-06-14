class Failure implements Exception {}

class InvalidSearchText extends Failure {}

class EmptyList extends Failure {}

class ErrorSearch extends Failure {}

class DatasourceResultNull extends Failure {}

class DatasourceError extends Failure {}

class ErrorEmptyPassword extends Failure {}

class ErrorEmptyEmail extends Failure {}

class ErrorApiError extends Failure {}

class ErrorApi404 extends Failure {}

class ErrorApi403 extends Failure {}

class ErrorApi303 extends Failure {}

class ErrorApi500 extends Failure {}
