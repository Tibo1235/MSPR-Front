import 'package:flutter/material.dart';
import 'package:lodim_mspr/pages/contact_page_chat.dart';
import 'package:provider/provider.dart';
import '/utility/providerUser.dart';
import '/pages/research_page.dart';
import '/pages/account_page.dart';
import '/pages/post_creation.dart';
import 'adminChoice.dart';
import 'botanistChoice.dart';
import 'botaniste_creation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late List<GlobalKey> _navKeys;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _navKeys = List.generate(5, (index) => GlobalKey());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<UserProvider>(context).user?.role == 'ADMIN';
    bool isBotaniste = Provider.of<UserProvider>(context).user?.role == 'BOTANISTE';

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SearchPage(),
          ContactPage(),
          if (isAdmin || isBotaniste) ViewChoiceBotanist() else BotanistChoicePage(),
          SearchPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 1.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAnimatedNavItem(Icons.grid_view, 0),
                _buildAnimatedNavItem(Icons.tips_and_updates, 1),
                _buildAnimatedNavItem(Icons.add_circle_outline, 2),
                _buildAnimatedNavItem(Icons.search, 3),
                _buildAnimatedNavItem(Icons.person_outline, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNavItem(IconData icon, int index) {
    return Container(
      key: _navKeys[index],
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
          _playAnimation();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_currentIndex == index)
              TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300),
                builder: (context, double value, child) {
                  return Container(
                    width: 50 * value,
                    height: 50 * value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1B4B1D).withOpacity(0.3),
                    ),
                  );
                },
              ),
            Container(
              padding: EdgeInsets.all(12),
              child: Icon(
                icon,
                size: 28,
                color: _currentIndex == index ? Color(0xFFFFFFFF) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playAnimation() {
    _controller.reset();
    _controller.forward();
  }
}

// Extension pour l'animation du cercle
class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}