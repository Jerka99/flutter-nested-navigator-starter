import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import '../../../app_state.dart';
import '../../app_routes.dart';
import '../../pages/profile_page.dart';
import '../navigation_helper.dart';

class Factory extends VmFactory<AppState, ProfileWidgetConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    onPressed: () {
      // NavigateAction.setNavigatorKey(navigatorKey);
      // dispatch(NavigateAction.pushNamed("/details"));
      dispatch(CustomNavigateAction.pushNamed("/profile/details", AppRoutes.nestedNavigatorKeys[2]));
      // navigatorKeys[0].currentState!.pushNamed("/details");
    },
  );
}

class ProfileWidgetConnector extends StatelessWidget {
  const ProfileWidgetConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return ProfileWidget(onPressed: vm.onPressed);
      },
    );
  }
}

class ViewModel extends Vm {
  final Function() onPressed;

  ViewModel({required this.onPressed});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is ViewModel;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return 'ViewModel{}';
  }
}
