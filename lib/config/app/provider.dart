import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_media/features/profile/profile_provider.dart';
import '../../features/add_post/create_post_provider.dart';
import '../../features/feeds/feeds_screen_provider.dart';
import '../../features/follow_unfollow/follow_unfollow_provider.dart';
import '../../features/login/login_provider.dart';
import '../../features/signup/signup_provider.dart';



//To define all the providers used
class Providers {
  static List<SingleChildWidget> getAllProviders() {
    List<SingleChildWidget> _providers = [
      ChangeNotifierProvider(create: (context) => LoginProvider()),
      ChangeNotifierProvider(create: (context) => SignUpProvider()),
      ChangeNotifierProvider(create: (context) => FollowUnFollowProvider()),
      ChangeNotifierProvider(create: (context) => CreatePostProvider()),
      ChangeNotifierProvider(create: (context) => FeedsScreenProvider()),
      ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ];
    return _providers;
  }
}
