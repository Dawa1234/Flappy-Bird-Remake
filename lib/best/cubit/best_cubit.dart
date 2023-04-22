import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'best_state.dart';

class BestCubit extends HydratedCubit<BestState> {
  BestCubit() : super(BestInitial(best: 0));

  void increment() => emit(IncreamentState(best: state.best + 1));

  @override
  BestState? fromJson(Map<String, dynamic> json) {
    return BestState(best: json['best']);
  }

  @override
  Map<String, dynamic>? toJson(BestState state) {
    return {'best': state.best};
  }
}
