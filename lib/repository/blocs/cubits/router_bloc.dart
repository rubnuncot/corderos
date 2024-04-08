import 'package:bloc/bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/!helpers.dart';

class RouterBloc extends Cubit<GoRouter> {
  RouterBloc() : super(appRouter);

  String actualRoute = '/';

  void goBack() {
    switch (actualRoute) {
      case '/':
        break;
    }
  }

  void goTowards(String location) {
    state.push(location);
    actualRoute = location;
  }

  void goHome() {
    state.push('/');
  }

  void goMain() {
    state.push('/main');
    actualRoute = '/main';
  }

  void redirectCurrentRoute() {
    goTowards(actualRoute);
  }

  String getActualRoute() => actualRoute;
}
