enum ErrorType {
  NO_SUPPORT_PLATFORM,
  NO_NETWORK,
  BIND,
  CONNECT,
  SEND,
}

enum OperatorType {
  SEARCH('search'),
  CONNECT('connet');

  final String msg;
  const OperatorType(this.msg);
}