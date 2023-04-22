part of 'best_cubit.dart';

class BestState extends Equatable {
  int best;
  BestState({required this.best});

  @override
  List<Object> get props => [best];
}

class IncreamentState extends BestState {
  IncreamentState({required int best}) : super(best: best);
}

class BestInitial extends BestState {
  BestInitial({required super.best});
}
