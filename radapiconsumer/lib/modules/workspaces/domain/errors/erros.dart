class Failure implements Exception {}

class InvalidSearchText extends Failure {}

class EmptyList extends Failure {}

class ErrorSearch extends Failure {}

class ErrorLoginFail extends Failure {}

class ErrorLoginNotFound extends Failure {}

class DatasourceResultNull extends Failure {}

class DatasourceError extends Failure {}
