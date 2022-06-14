class Failure implements Exception {}

class InvalidSearchText extends Failure {}

class EmptyList extends Failure {}

class ErrorSearch extends Failure {}

class ErrorDelete extends Failure {}

class DatasourceResultNull extends Failure {}

class DatasourceError extends Failure {}
