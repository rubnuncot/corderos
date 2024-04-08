import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/presentation/screens/main_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const MainScreen(),
  ),
]);
