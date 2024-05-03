import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/!repository.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final navigator = context.read<RouterBloc>();
    final themeBloc = context.read<ThemeBloc>();
    final dropDownBloc = context.read<DropDownBloc>();

    Future<void> load() async {
      await themeBloc.preferencesTheme();
      await dropDownBloc.getData();
    }

    return FutureBuilder(
      future: load(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done && context.mounted) {
          Future.microtask(() => navigator.goMain());
        }
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}
