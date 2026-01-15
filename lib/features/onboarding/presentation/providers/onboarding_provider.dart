import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OnboardingStatus { isOnboarded, isNotOnboarded, loading }

class OnboardingState {
  final OnboardingStatus status;
  final bool? isOnboardingComplete;

  const OnboardingState({required this.status, this.isOnboardingComplete});

  OnboardingState copyWith({
    OnboardingStatus? status,
    bool? isOnboardingComplete,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    Future.microtask(() => checkOnboardingStatus());
    return const OnboardingState(status: OnboardingStatus.loading);
  }

  Logger logger = Logger();

  Future<void> checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingComplete = prefs.getBool('isOnboardingComplete');

    logger.log(Level.info, isOnboardingComplete);

    if (isOnboardingComplete != null) {
      state = state.copyWith(
        status: OnboardingStatus.isOnboarded,
        isOnboardingComplete: isOnboardingComplete,
      );
    } else {
      state = state.copyWith(status: OnboardingStatus.isNotOnboarded);
    }
  }

  Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
    state = state.copyWith(
      status: OnboardingStatus.isOnboarded,
      isOnboardingComplete: true,
    );
  }

  Future<void> resetOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isOnboardingComplete');
    state = state.copyWith(
      status: OnboardingStatus.isNotOnboarded,
      isOnboardingComplete: false,
    );
  }
}

final onboardingStateProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(() {
      return OnboardingNotifier();
    });
