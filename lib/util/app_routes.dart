
import '../ui/home/home_page.dart';
import '../ui/login/login_page.dart';

var appRoutes = {

  KeyUtil.homePage: (context) => HomePage(),
  KeyUtil.loginPage: (context) => LoginPage(),


};

class KeyUtil {

  static const String homePage = '/HomePage';
  static const String loginPage = '/LoginPage';




}
