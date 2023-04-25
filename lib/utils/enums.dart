enum ErrorType {
  NO_SUPPORT_PLATFORM,
  NO_NETWORK,
  BIND,
  CONNECT,
  SEND,
  RECEIVE,
}

enum OperatorType {
  SEARCH('search'),
  GETINT('getint'),
  GETSTRING('getstring');

  final String msg;
  const OperatorType(this.msg);
}