class AppState {
  final String? string;

  AppState({
    required this.string});

  static AppState initialState() =>
      AppState(
          string: null
      );

  AppState copyWith({String? string}) {
    return AppState(
        string: string ?? this.string);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              string == other.string;

  @override
  int get hashCode =>
      string.hashCode;

  @override
  String toString() {
    return 'AppState{string: $string}';
  }
}
