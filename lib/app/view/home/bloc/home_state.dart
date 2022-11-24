part of 'home_cubit.dart';

class HomeState {
  final bool isLoading;
  final AppConfig appConfig;
  final bool storeUpdate;

  const HomeState({
    required this.isLoading,
    required this.appConfig,
    required this.storeUpdate,
  });

  factory HomeState.initial() => HomeState(
        isLoading: false,
        appConfig: AppConfig(),
        storeUpdate: false,
      );

  HomeState copyWith({
    bool? isLoading,
    AppConfig? appConfig,
    bool? storeUpdate,
  }) =>
      HomeState(
        isLoading: isLoading ?? this.isLoading,
        appConfig: appConfig ?? this.appConfig,
        storeUpdate: storeUpdate ?? this.storeUpdate,
      );
}
