import 'package:gorouter_persisted_bottomnavbar/screens/error_screen.dart';
import 'package:gorouter_persisted_bottomnavbar/screens/login_screen.dart';
import 'package:gorouter_persisted_bottomnavbar/screens/number_screen.dart';
import 'package:gorouter_persisted_bottomnavbar/screens/overlay_navigation.dart';
import 'package:gorouter_persisted_bottomnavbar/screens/simple_navigation.dart';
import 'package:gorouter_persisted_bottomnavbar/screens/tab_bar_navigation.dart';
import 'package:gorouter_persisted_bottomnavbar/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// GoRouterクラスはRiverpodで依存注入
final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: '/simple',
    routes: <GoRoute>[
      GoRoute(
        name: 'simple',
        path: '/simple',
        // BottomNavigationBarでの画面遷移に見える様、遷移時のアニメーションを調整
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SimpleNavigationScreen(),
            transitionDuration: Duration.zero,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child),
        routes: [
          // サブルートへの画面遷移のサンプル
          GoRoute(
            name: 'login',
            path: 'login',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const LoginScreen(),
            ),
          ),
          // 引数を渡す画面遷移のサンプル
          GoRoute(
            name: 'number',
            path: 'number/:id',
            builder: (context, state) {
              final id = state.params['id']!;
              return NumberScreen(number: id);
            },
          ),
        ],
      ),
      GoRoute(
        name: 'overlay',
        path: '/overlay',
        // BottomNavigationBarでの画面遷移に見える様、遷移時のアニメーションを調整
        pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OverlayNavigationScreen(),
            transitionDuration: Duration.zero,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child),
      ),
      GoRoute(
        name: 'tab_bar',
        path: '/tab_bar',
        routes: [
          GoRoute(
            name: 'pageA',
            path: 'page_a',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: PageA(key: state.pageKey),
            ),
          ),
          GoRoute(
            name: 'pageB',
            path: 'page_b',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: PageB(key: state.pageKey),
            ),
          ),
          GoRoute(
            name: 'pageC',
            path: 'page_c',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: PageC(key: state.pageKey),
            ),
          ),
        ],
        // BottomNavigationBarでの画面遷移に見える様、遷移時のアニメーションを調整
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const TabBarNavigationScreen(),
          transitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              child,
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorScreen(
        exception: state.error,
      ),
    ),
    navigatorBuilder: (context, state, child) {
      // GoRouterクラスの上に常に重なるNavigatorクラスを定義。
      // このNavigatorクラスにBottomNavigatioBarを渡す事で永続化を実現。
      return Navigator(
        onPopPage: (route, dynamic __) => false,
        pages: [
          MaterialPage<Widget>(
            child: BottomNav(
              child: child,
            ),
          ),
        ],
      );
    },
  ),
);
