import 'package:blog_app/core/index.dart';
import 'package:blog_app/ui/blogs/screens/blogs_page.dart';
import 'package:blog_app/ui/blogs/screens/create_blog_page.dart';
import 'package:blog_app/ui/home/screens/home_page.dart';
import 'package:blog_app/ui/login/screen/login_page.dart';
import 'package:blog_app/ui/profile/bloc/profile.dart';
import 'package:blog_app/ui/profile/screen/search_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late ProfileBloc _profileBloc;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> _screenTitles = [
    Strings.screenTitle.kHome,
    Strings.screenTitle.kSearch,
    Strings.screenTitle.kProfile,
  ];

  List<Widget> _screens = [
    BlogsPage(),
    SearchProfilePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    SharedPreferenceHelper.getToken().then((uid) {
      _profileBloc = BlocProvider.of<ProfileBloc>(context);

      _profileBloc.add(GetProfile(uid: uid!));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_screenTitles[_selectedIndex]),
        ),
        body: _screens[_selectedIndex],
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: _navigateToCreateBlogScreen, child: Icon(Icons.add))
            : Container(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.article_rounded),
              label: 'Blogs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: _onItemTapped,
        ),
      );

  void _navigateToCreateBlogScreen() {
    Navigator.pushNamed(context, CreateBlogPage.tag);
  }
}
