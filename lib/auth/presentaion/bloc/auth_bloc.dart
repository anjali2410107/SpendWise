import 'package:bloc/bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthState()) {
    on<SignUpEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final uid = await repository.signUp(event.email, event.password);
        emit(state.copyWith(userId: uid, isLoading: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final uid = await repository.login(event.email, event.password);
        emit(state.copyWith(userId: uid, isLoading: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });
    on<GoogleSignInEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        final uid = await repository.signInWithGoogle();
        emit(state.copyWith(userId: uid, isLoading: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });
    on<LogoutEvent>((event, emit) async {
      await repository.logout();
      emit(AuthState());
    });
  }
}
