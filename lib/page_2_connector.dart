import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import '../app_state.dart';

class Factory extends VmFactory<AppState, Page2Connector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(string: store.state.string);
}

class Page2Connector extends StatelessWidget {
  const Page2Connector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return Page2();
      },
    );
  }
}

class ViewModel extends Vm {
  final String? string;

  ViewModel({required this.string});

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
