import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/onboarding/presentation/screens/who_are_we_styling_screen.dart';
import '../../features/onboarding/presentation/screens/style_swipe_screen.dart';
import '../../features/onboarding/presentation/screens/preferences_screen.dart';
import '../../features/onboarding/presentation/screens/fit_size_screen.dart';
import '../../features/onboarding/presentation/screens/style_dna_screen.dart';
import '../../features/onboarding/presentation/screens/add_first_items_screen.dart';
import '../../features/onboarding/presentation/screens/all_set_screen.dart';
import '../../features/onboarding/presentation/screens/explore_gardirop_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import 'main_shell.dart';
import '../../features/closet/presentation/screens/closet_screen.dart';
import '../../features/closet/presentation/screens/quick_add_screen.dart';
import '../../features/closet/presentation/screens/review_item_screen.dart';
import '../../features/closet/domain/item_draft.dart';
import '../../features/closet/presentation/screens/item_added_success_screen.dart';
import '../../features/closet/presentation/screens/item_detail_screen.dart';
import '../../features/closet/domain/wardrobe_item.dart';
import '../../features/closet/presentation/screens/ai_scan_result_screen.dart';
import '../../features/closet/presentation/screens/ai_scan_camera_screen.dart';
import '../../features/style/presentation/screens/style_screen.dart';
import '../../features/style/presentation/screens/style_this_item_screen.dart';
import '../../features/style/presentation/screens/select_outfit_items_screen.dart';
import '../../features/style/presentation/screens/outfit_builder_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/onboarding/who-are-we-styling',
      builder: (context, state) => const WhoAreWeStylingScreen(),
    ),
    GoRoute(
      path: '/onboarding/style-swipe',
      builder: (context, state) => const StyleSwipeScreen(),
    ),
    GoRoute(
      path: '/onboarding/preferences',
      builder: (context, state) => const PreferencesScreen(),
    ),
    GoRoute(
      path: '/onboarding/fit-size',
      builder: (context, state) => const FitSizeScreen(),
    ),
    GoRoute(
      path: '/onboarding/style-dna',
      builder: (context, state) => const StyleDnaScreen(),
    ),
    GoRoute(
      path: '/onboarding/add-first-items',
      builder: (context, state) => const AddFirstItemsScreen(),
    ),
    GoRoute(
      path: '/onboarding/all-set',
      builder: (context, state) {
        final hasItems =
            state.uri.queryParameters['hasItems'] == 'true';

        return AllSetScreen(
          hasItems: hasItems,
        );
      },
    ),
    GoRoute(
      path: '/onboarding/explore',
      builder: (context, state) => const ExploreGardiropScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/closet',
          builder: (context, state) => const ClosetScreen(),
        ),
        GoRoute(
          path: '/style',
          builder: (context, state) => const StyleScreen(),
        ),
        GoRoute(
          path: '/closet/quick-add',
          builder: (context, state) => const QuickAddScreen(),
        ),
        GoRoute(
          path: '/closet/ai-result',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;

            return AiScanResultScreen(
              draft: data['draft'] as ItemDraft,
              analysis: Map<String, dynamic>.from(
                data['analysis'] as Map,
              ),
            );
          },
        ),
        GoRoute(
          path: '/closet/item-added/:itemId',
          builder: (context, state) {
            final itemId = state.pathParameters['itemId']!;

            return ItemAddedSuccessScreen(
              itemId: itemId,
            );
          },
        ),
        GoRoute(
          path: '/closet/item-detail',
          builder: (context, state) {
            final item = state.extra as WardrobeItem;

            return ItemDetailScreen(
              item: item,
            );
          },
        ),
        GoRoute(
          path: '/closet/edit-item',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;

            return ReviewItemScreen(
              itemId: data['itemId'] as String,
              draft: data['draft'] as ItemDraft,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/style/item',
      builder: (context, state) {
        final item = state.extra as WardrobeItem;

        return StyleThisItemScreen(
          item: item,
        );
      },
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/closet/review-item',
      builder: (context, state) {
        final draft = state.extra as ItemDraft;

        return ReviewItemScreen(
          draft: draft,
        );
      },
    ),
    GoRoute(
      path: '/closet/ai-scan-camera',
      builder: (context, state) {
        return const AiScanCameraScreen();
      },
    ),
    GoRoute(
      path: '/style/select-items',
      builder: (context, state) => const SelectOutfitItemsScreen(),
    ),
    GoRoute(
      path: '/style/outfit-builder',
      builder: (context, state) {
        final items = state.extra as List<WardrobeItem>;

        return OutfitBuilderScreen(
          items: items,
        );
      },
    ),
  ],
);