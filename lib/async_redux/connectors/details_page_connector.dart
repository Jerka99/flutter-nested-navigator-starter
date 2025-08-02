import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/pages/details_page.dart';
import '../../../app_state.dart';

class Factory extends VmFactory<AppState, DetailsPageConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    onPressed: () async {
      navigationService.pushReplacement("/");
      // appRoutes.nestedNavigatorKeys[0].currentState
      //     ?.pushNamed('/details'); // or pushReplacement if needed

      // AppRoutes.instance.nestedNavigatorKeys[2].currentState
      //     ?.pushNamed('/profile/details');
    // CustomNavigateAction.jumpToPageAndPushNamed("home/details");
// // 2. Delay the page switch just a bit
//       Future.delayed(Duration(milliseconds: 50), () {
//         appRoutes.pageController.jumpToPage(0);
//       });
      // appRoutes.nestedNavigatorKeys[2].currentState?.pushNamed('/home/details');
      //   _,
      // ) async {
      //   await Future.delayed(Duration(milliseconds: 100));
      //   dispatch(CustomNavigateAction.pushNamed("/home/details"));
      // });
    },
  );
}

class DetailsPageConnector extends StatelessWidget {
  const DetailsPageConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return DetailsPage(onPressed: vm.onPressed);
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
