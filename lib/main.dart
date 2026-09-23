import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '极简多级导航',
      debugShowCheckedModeBanner: false,
      locale: const Locale('zh', 'CN'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FirstLevelListPage(tabTitle: '首页', prefix: '热门内容'),
    FirstLevelListPage(tabTitle: '消息', prefix: '系统消息'),
    FirstLevelListPage(tabTitle: '发现', prefix: '探索发现'),
    FirstLevelListPage(tabTitle: '我的', prefix: '个人设置'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['首页', '消息', '发现', '我的'][_currentIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                '导航菜单',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('个人资料'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('系统设置'),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('关于应用'),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

// 一级列表页面（包含10个列表项）
class FirstLevelListPage extends StatelessWidget {
  final String tabTitle;
  final String prefix;

  const FirstLevelListPage({
    super.key,
    required this.tabTitle,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(10, (index) => '$prefix - 一级选项 ${index + 1}');

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(items[index]),
          subtitle: Text('点击进入 $tabTitle 的二级详情页面'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondLevelListPage(parentTitle: items[index]),
              ),
            );
          },
        );
      },
    );
  }
}

// 二级列表页面（同样包含10个列表项）
class SecondLevelListPage extends StatelessWidget {
  final String parentTitle;

  const SecondLevelListPage({super.key, required this.parentTitle});

  @override
  Widget build(BuildContext context) {
    final List<String> subItems = List.generate(10, (index) => '$parentTitle - 二级子项 ${index + 1}');

    return Scaffold(
      appBar: AppBar(
        title: Text(parentTitle),
      ),
      body: ListView.builder(
        itemCount: subItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.subdirectory_arrow_right, color: Colors.blue),
            title: Text(subItems[index]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('点击了：${subItems[index]}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}