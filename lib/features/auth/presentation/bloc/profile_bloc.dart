import 'package:a_and_w/features/auth/domain/entities/profile.dart';
import 'package:a_and_w/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  ProfileBloc({required this.getProfileUsecase, required this.updateProfileUsecase, required this.getCurrentUserUseCase}) : super(ProfileInitial()) {
    on<OnGetProfile>((event, emit) async {
      emit(ProfileLoading());
      final currentUser = getCurrentUserUseCase();
      final uid = currentUser?.uid ?? "";
      
      await emit.forEach<Profile?>(
        getProfileUsecase(uid).asyncMap((either) => either.fold(
          (failure) => null,
          (profile) => profile,
        )),
        onData: (profile) {
          if (profile != null) {
            return ProfileLoaded(profile);
          } else {
            return ProfileError();
          }
        },
        onError: (error, stackTrace) {
          return ProfileError();
        },
      );
    });

    on<OnUpdateProfile>((event, emit) async{
      emit(ProfileLoading());
      final either = await updateProfileUsecase(event.profile);
      either.fold(
        (failure) => emit(ProfileError()),
        (_) => emit(ProfileLoaded(event.profile)),
      );
    },);
  }
}
