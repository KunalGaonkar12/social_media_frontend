
import 'package:go_router/go_router.dart';
import 'package:social_media/features/home/home_screen.dart';
import 'package:social_media/features/signup/signup_screen.dart';
import '../../features/feeds/feeds_screen.dart';
import '../../features/login/login_screen.dart';



//Used for routing
class Routers{

  static GoRouter getRoutes(){
    final GoRouter router = GoRouter(
      initialLocation: "/Home",
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) =>  LoginScreen(),
        ),GoRoute(
          path: "/Home",
          builder: (context, state) =>  HomeScreen(),
        ),GoRoute(
          path: "/Signup",
          builder: (context, state) =>  SignUpScreen(),
        ),GoRoute(
          path: "/FeedScreen",
          builder: (context, state) =>  FeedsScreen(),
        )
      ],
    );

    return router;

  }



}