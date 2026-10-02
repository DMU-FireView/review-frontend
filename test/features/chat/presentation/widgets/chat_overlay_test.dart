import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:re_view_front/app/router/app_router.dart';
import 'package:re_view_front/app/router/route_paths.dart';
import 'package:re_view_front/core/error/failure.dart';
import 'package:re_view_front/core/providers/core_providers.dart';
import 'package:re_view_front/core/result/result.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_reply.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_session.dart';
import 'package:re_view_front/features/chat/domain/entities/chat_message.dart';
import 'package:re_view_front/features/chat/domain/repositories/chat_repository.dart';
import 'package:re_view_front/features/chat/presentation/providers/chat_providers.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_overlay.dart';
import 'package:re_view_front/features/chat/presentation/widgets/chat_panel.dart';
import 'package:re_view_front/features/chat/presentation/widgets/popup_route_tracker.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('retries failed history and loads the next page', (tester) async {
    final repository = _FakeChatRepository()
      ..sessions = const FailureResult(Failure(message: '목록 오류'));
    await _pumpOverlay(
      tester,
      path: RoutePaths.home,
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.chatPreviousConversations));
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatHistoryLoadError), findsOneWidget);
    repository.sessions = const Success(
      ChatSessionPage(
        items: [ChatSession(id: 12, title: '첫 대화')],
        page: 0,
        isLast: false,
      ),
    );
    await tester.tap(find.text(l10n.chatRetry));
    await tester.pumpAndSettle();
    expect(find.text('첫 대화'), findsOneWidget);
    expect(find.text(l10n.chatHistoryLoadError), findsNothing);
    repository.sessions = const Success(
      ChatSessionPage(
        items: [ChatSession(id: 13, title: '두 번째 대화')],
        page: 1,
        isLast: true,
      ),
    );
    await tester.tap(find.text(l10n.chatHistoryLoadMore));
    await tester.pumpAndSettle();
    expect(find.text('첫 대화'), findsOneWidget);
    expect(find.text('두 번째 대화'), findsOneWidget);
    expect(find.text(l10n.chatHistoryLoadMore), findsNothing);
    expect(repository.pages, [0, 0, 1]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('history fits a narrow mobile panel', (tester) async {
    await _pumpOverlay(tester, path: RoutePaths.home, isLoggedIn: true);
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.chatPreviousConversations));
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatHistoryEmpty), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('browses history, restores a conversation and resumes sending', (
    tester,
  ) async {
    final repository = _FakeChatRepository()
      ..sessions = const Success(
        ChatSessionPage(
          items: [ChatSession(id: 12, title: '이전 상품 대화', productId: '2')],
          page: 0,
          isLast: true,
        ),
      )
      ..messages = const Success([
        ChatMessage(role: ChatRole.user, content: '예전 질문'),
        ChatMessage(role: ChatRole.assistant, content: '예전 답변'),
      ]);
    final subject = await _pumpOverlay(
      tester,
      path: '/product/1',
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.chatPreviousConversations));
    await tester.pumpAndSettle();
    expect(find.text('이전 상품 대화'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(repository.pages, [0]);
    await tester.tap(find.text('이전 상품 대화'));
    await tester.pumpAndSettle();
    expect(find.text('예전 질문'), findsOneWidget);
    expect(find.text('예전 답변'), findsOneWidget);
    expect(find.text(l10n.chatOtherProductNotice), findsOneWidget);
    expect(subject.container.read(chatViewModelProvider).sessionId, 12);
    await tester.enterText(find.byType(TextField), '이어 질문');
    await tester.pump();
    await tester.tap(find.byTooltip(l10n.chatSend));
    await tester.pumpAndSettle();
    expect(repository.requests.single, (
      question: '이어 질문',
      sessionId: 12,
      productId: null,
    ));
    expect(find.text('리뷰 분석 답변'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows empty history and returns to the conversation', (
    tester,
  ) async {
    await _pumpOverlay(tester, path: RoutePaths.home, isLoggedIn: true);
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.chatPreviousConversations));
    await tester.pumpAndSettle();
    expect(find.text(l10n.chatHistoryEmpty), findsOneWidget);
    await tester.tap(find.byTooltip(l10n.chatBackToConversation));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final path in [
    RoutePaths.landing,
    RoutePaths.login,
    RoutePaths.admin,
    RoutePaths.resetPassword,
    RoutePaths.passwordReset,
  ]) {
    testWidgets('hides the launcher on $path', (tester) async {
      await _pumpOverlay(tester, path: path);

      final l10n = _localizations(tester);
      expect(find.byTooltip(l10n.chatLauncherTooltip), findsNothing);
      expect(find.byType(ChatPanel), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  for (final path in [RoutePaths.home, '/product/1']) {
    testWidgets('shows the launcher on $path', (tester) async {
      await _pumpOverlay(tester, path: path);

      final l10n = _localizations(tester);
      expect(
        find.byTooltip(l10n.chatLauncherTooltip).hitTestable(),
        findsOneWidget,
      );
      expect(find.byType(ChatPanel), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('hides the launcher while a dialog is open', (tester) async {
    final subject = await _pumpOverlay(tester, path: RoutePaths.home);
    final l10n = _localizations(tester);
    final launcher = find.byTooltip(l10n.chatLauncherTooltip);
    expect(launcher, findsOneWidget);

    unawaited(
      showDialog<void>(
        context: subject.router.routerDelegate.navigatorKey.currentContext!,
        builder: (_) => const AlertDialog(content: Text('dialog')),
      ),
    );
    await tester.pumpAndSettle();
    expect(launcher, findsNothing);

    subject.router.routerDelegate.navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(launcher, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a login prompt when opened while logged out', (
    tester,
  ) async {
    final subject = await _pumpOverlay(tester, path: RoutePaths.home);
    final l10n = _localizations(tester);

    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.chatLoginTitle), findsOneWidget);
    expect(find.text(l10n.chatLoginBody), findsOneWidget);
    expect(find.text(l10n.chatLoginButton), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(subject.repository.requests, isEmpty);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text(l10n.chatLoginButton));
    await tester.pumpAndSettle();
    expect(
      subject.router.routeInformationProvider.value.uri.path,
      RoutePaths.login,
    );
    expect(subject.container.read(chatViewModelProvider).isOpen, isFalse);
    expect(find.byType(ChatPanel), findsNothing);
  });

  testWidgets('shows product question chips when logged in on a product page', (
    tester,
  ) async {
    final subject = await _pumpOverlay(
      tester,
      path: '/product/1',
      isLoggedIn: true,
    );
    final l10n = _localizations(tester);

    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    expect(find.text(l10n.chatProductContext), findsOneWidget);
    expect(
      find.widgetWithText(ActionChip, l10n.chatSuggestProduct1),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ActionChip, l10n.chatSuggestProduct2),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ActionChip, l10n.chatSuggestProduct3),
      findsOneWidget,
    );
    expect(find.text(l10n.chatSuggestGeneral1), findsNothing);
    expect(find.text(l10n.chatLoginTitle), findsNothing);
    expect(subject.repository.requests, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sends a product chip question and displays the reply', (
    tester,
  ) async {
    final pending = Completer<Result<ChatReply>>();
    final repository = _FakeChatRepository()..pending = pending;
    final subject = await _pumpOverlay(
      tester,
      path: '/product/1',
      isLoggedIn: true,
      repository: repository,
    );
    final l10n = _localizations(tester);
    await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ActionChip, l10n.chatSuggestProduct1));
    await tester.pump();

    expect(repository.requests.single, (
      question: l10n.chatSuggestProduct1,
      sessionId: null,
      productId: 1,
    ));
    expect(subject.container.read(chatViewModelProvider).isSending, isTrue);
    expect(find.text(l10n.chatThinking), findsOneWidget);
    expect(find.text(l10n.chatSuggestProduct1), findsOneWidget);

    pending.complete(_reply);
    await tester.pumpAndSettle();

    expect(find.text('리뷰 분석 답변'), findsOneWidget);
    expect(find.text(l10n.chatThinking), findsNothing);
    expect(subject.container.read(chatViewModelProvider).sessionId, 7);
    expect(subject.container.read(chatViewModelProvider).isSending, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'shows a notice when navigating to another product in a session',
    (tester) async {
      final subject = await _pumpOverlay(
        tester,
        path: '/product/1',
        isLoggedIn: true,
      );
      final l10n = _localizations(tester);
      await tester.tap(find.byTooltip(l10n.chatLauncherTooltip));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(ActionChip, l10n.chatSuggestProduct1),
      );
      await tester.pumpAndSettle();

      subject.router.go('/product/2');
      await tester.pumpAndSettle();

      expect(find.text(l10n.chatOtherProductNotice), findsOneWidget);
      expect(find.text(l10n.chatStartWithThisProduct), findsOneWidget);
      expect(find.text('리뷰 분석 답변'), findsOneWidget);
      expect(subject.container.read(chatViewModelProvider).sessionProductId, 1);
      expect(subject.repository.requests, hasLength(1));
      expect(tester.takeException(), isNull);

      await tester.tap(find.text(l10n.chatStartWithThisProduct));
      await tester.pumpAndSettle();
      expect(find.text(l10n.chatOtherProductNotice), findsNothing);
      expect(find.text(l10n.chatProductContext), findsOneWidget);
      expect(subject.container.read(chatViewModelProvider).messages, isEmpty);
      expect(subject.container.read(chatViewModelProvider).sessionProductId, 2);
      await tester.tap(
        find.widgetWithText(ActionChip, l10n.chatSuggestProduct1),
      );
      await tester.pumpAndSettle();
      expect(subject.repository.requests.last.productId, 2);
      expect(subject.repository.requests.last.sessionId, isNull);
    },
  );
}

AppLocalizations _localizations(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(ChatOverlay)));
}

Future<
  ({
    ProviderContainer container,
    GoRouter router,
    _FakeChatRepository repository,
  })
>
_pumpOverlay(
  WidgetTester tester, {
  required String path,
  bool isLoggedIn = false,
  _FakeChatRepository? repository,
}) async {
  tester.view.physicalSize = const Size(1280, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: path,
    observers: [popupRouteTracker],
    routes: [
      for (final route in [
        RoutePaths.home,
        RoutePaths.landing,
        RoutePaths.login,
        RoutePaths.admin,
        RoutePaths.resetPassword,
        RoutePaths.passwordReset,
        RoutePaths.productDetail,
      ])
        GoRoute(
          path: route,
          builder: (context, state) => const Scaffold(body: Text('route page')),
        ),
    ],
  );
  final fake = repository ?? _FakeChatRepository();
  final container = ProviderContainer(
    overrides: [
      appRouterProvider.overrideWithValue(router),
      isLoggedInProvider.overrideWithValue(isLoggedIn),
      chatRepositoryProvider.overrideWithValue(fake),
      apiClientProvider.overrideWith((ref) {
        throw StateError('Unexpected API access in chat overlay test');
      }),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(router.dispose);

  final app = localizedApp(router: router) as MaterialApp;
  await pumpApp(
    tester,
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: app.theme,
        locale: app.locale,
        supportedLocales: app.supportedLocales,
        localizationsDelegates: app.localizationsDelegates,
        routerConfig: router,
        builder: (context, child) => ChatOverlay(child: child!),
      ),
    ),
  );
  return (container: container, router: router, repository: fake);
}

const _reply = Success(
  ChatReply(sessionId: 7, answer: '리뷰 분석 답변', blocked: false),
);

class _FakeChatRepository implements ChatRepository {
  Result<ChatSessionPage> sessions = const Success(
    ChatSessionPage(items: [], page: 0, isLast: true),
  );
  Result<List<ChatMessage>> messages = const Success([]);
  Completer<Result<ChatSessionPage>>? pendingSessions;
  Completer<Result<List<ChatMessage>>>? pendingMessages;
  final List<int> pages = [];
  final List<int> messageRequests = [];

  @override
  Future<Result<ChatSessionPage>> getSessions({
    required int page,
    required int size,
  }) async {
    pages.add(page);
    return pendingSessions == null ? sessions : await pendingSessions!.future;
  }

  @override
  Future<Result<List<ChatMessage>>> getSessionMessages(int sessionId) async {
    messageRequests.add(sessionId);
    return pendingMessages == null ? messages : await pendingMessages!.future;
  }

  Completer<Result<ChatReply>>? pending;
  final List<({String question, int? sessionId, int? productId})> requests = [];

  @override
  Future<Result<ChatReply>> ask({
    required String question,
    int? sessionId,
    int? productId,
  }) async {
    requests.add((
      question: question,
      sessionId: sessionId,
      productId: productId,
    ));
    return pending == null ? _reply : await pending!.future;
  }
}
