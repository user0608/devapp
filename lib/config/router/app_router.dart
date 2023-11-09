import 'package:devapp/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: HomePage.path,
  routes: [
    GoRoute(
      path: HomePage.path,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
