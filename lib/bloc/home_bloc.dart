import 'dart:async';

import 'package:bloc/bloc.dart';

enum HomeBlocEvent { add, subtract }

class HomeBloc {
  late CounterCubit _counterCubit;
  late CounterInteractionCubit _counterInteractionCubit;
  late StreamSubscription<int> streamCounter;

  HomeBloc() {
    _counterCubit = CounterCubit(state: 0);
    _counterInteractionCubit = CounterInteractionCubit(state: 0);
    // listenToCounter();
  }

  // void listenToCounter() {
  //   streamCounter = _counterCubit.stream.listen((event) {
  //     _counterInteractionCubit.add();
  //   });
  // }
  //
  // void cancelListenToCounter() {
  //   streamCounter.cancel();
  // }

  CounterInteractionCubit get counterInteractionCubit =>
      _counterInteractionCubit;

  CounterCubit get counterCubit => _counterCubit;
}

class CounterCubit extends Cubit<int> {
  CounterCubit({required this.state}) : super(state);

  int state;

  void add() {
    emit(state += 1);
  }

  void subtract() {
    emit(state -= 1);
  }

  void reset() {
    emit(state = 0);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(error, stackTrace);
    // print("error : $error");
  }

  @override
  void onChange(Change<int> change) {
    // TODO: implement onChange
    super.onChange(change);
    // print('change : $change');
  }
}

class CounterInteractionCubit extends Cubit<int> {
  CounterInteractionCubit({required this.state}) : super(state);

  int state;

  void add() {
    emit(state += 1);
  }

  void reset() {
    emit(state = 0);
  }
}
