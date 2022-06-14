class NetworkInfo {
  bool _isConnected = true;
  bool _isLocalFirst = false;

  get isConnected => _isConnected;
  get isLocalFirst => _isLocalFirst;

  NetworkInfo({
    bool isConnected = true,
    bool isLocalFirst = true,
  }) {
    this._isConnected = isConnected;
    this._isLocalFirst = isLocalFirst;
  }
}
