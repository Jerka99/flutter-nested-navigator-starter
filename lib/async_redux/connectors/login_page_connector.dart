import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/pages/login_page.dart';
import '../../../app_state.dart';

class Factory extends VmFactory<AppState, LoginPageConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    string: store.state.string,
    onPressed: () {
      dispatch(NavigateAction.pushNamed("/page2"));
    },
  );
}

class LoginPageConnector extends StatelessWidget {
  const LoginPageConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return LoginPage(string: vm.string, onPressed: vm.onPressed);
      },
    );
  }
}

class ViewModel extends Vm {
  final String? string;
  final Function onPressed;

  ViewModel({required this.string, required this.onPressed});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is ViewModel && string == other.string;

  @override
  int get hashCode => super.hashCode ^ string.hashCode;

  @override
  String toString() {
    return 'ViewModel{string: $string}';
  }
}
