import 'package:flutter/cupertino.dart';
import 'package:learn_flutter_bloc/bloc/home_bloc.dart';

class InheritedHomeBloc extends InheritedWidget {
  final HomeBloc hb;

  const InheritedHomeBloc({Key? key, required this.hb, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedHomeBloc oldWidget) {
    return oldWidget.hb != hb;
  }

  static InheritedHomeBloc? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedHomeBloc>();
  }

  static InheritedHomeBloc of(BuildContext context) {
    final InheritedHomeBloc? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }
}
