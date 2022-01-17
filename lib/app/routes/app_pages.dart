import 'package:digitalconstruction/Users/UserLoginBinding.dart';
import 'package:digitalconstruction/Users/all_contractors.dart';
import 'package:digitalconstruction/Users/login_page.dart';
import 'package:digitalconstruction/Users/main_screen.dart';
import 'package:digitalconstruction/Users/signup_user.dart';
import 'package:digitalconstruction/Users/wagers.dart';
import 'package:digitalconstruction/app/modules/constructors/dashboard_screen.dart';
import 'package:digitalconstruction/daily_wagers/dashboard_wager.dart';
import 'package:digitalconstruction/daily_wagers/WagerHomeBinding.dart';
import 'package:digitalconstruction/daily_wagers/WagerLoginBinding.dart';
import 'package:digitalconstruction/daily_wagers/login_wager.dart';
import 'package:get/get.dart';
import '../../after_splash.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
part 'app_routes.dart';
class AppPages {
  static const INITIAL = Routes.AfterSplash;

  static final routes = [
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.AfterSplash,
      page: () => HomePage(),
    ),
    GetPage(
      name: _Paths.AllUsersContractors,
      page: () => AllContractors(longitude: 0, latitude: 0,),
    ),
    GetPage(
      name: _Paths.WagerList,
      page: () => const AllWagers(longitude: 0,latitude: 0,),
    ),
    GetPage(
      name: _Paths.LOGINWager,
      page: () => LoginWager(),
      binding: WagerLoginBinding(),
    ),
    GetPage(
      name: _Paths.WagerHome,
      page: () => const DashboardWager(),
      binding: WagerHomeBinding(),
    ),
    GetPage(
      name: _Paths.UserSignup,
      page: () => SignupUser(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => Dashboard(),
    ),
    GetPage(
      name: _Paths.userLogin,
      page: () => LoginPage(),
      binding: UserLoginBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.UserMainScreen,
      page: () => MainScreen(),
      // binding: (),
    ),

  ];
}
