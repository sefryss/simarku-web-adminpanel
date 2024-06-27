import 'package:ebookadminpanel/ui/chat/widgets/detail_chat_screen.dart';

import '../ui/home/home_page.dart';
import '../ui/login/login_page.dart';

var appRoutes = {
  KeyUtil.homePage: (context) => HomePage(),
  KeyUtil.loginPage: (context) => LoginPage(),
  // KeyUtil.chatPage: (context) => DetailChatScreen(),
};

class KeyUtil {
  static const String homePage = '/HomePage';
  static const String loginPage = '/LoginPage';
  // static const String chatPage = '/ChatPage';
}
