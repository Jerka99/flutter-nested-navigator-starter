class NavigationService {
  late void Function(String route) _pushFunction;
  late void Function(String route) _pushReplacementFunction;

  void initialize(void Function(String route) pushReplacementMethod, void Function(String route) pushMethod) {
    _pushReplacementFunction = pushReplacementMethod;
    _pushFunction = pushMethod;
  }

  void pushReplacement(String route) {
    _pushReplacementFunction(route);
  }

  void push(String route) {
    _pushFunction(route);
  }
}