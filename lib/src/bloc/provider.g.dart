// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case PlayBloc:
        {
          return BlocCache.getBlocInstance(
              'PlayBloc', () => PlayBloc.instance()) as T;
        }
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case PlayBloc:
        {
          BlocCache.dispose('PlayBloc');
          break;
        }
    }
  }
}
