T? castOrNull<T>(Object? value) => value is T ? value : null;

T castOr<T>(Object? value, T fallback) => value is T ? value : fallback;
