import 'package:corderos_app/presentation/!presentation.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const LoadingScreen(),
  ),
  GoRoute(
    path: '/main',
    builder: (context, state) => const MainScreen(),
  ),
]);
