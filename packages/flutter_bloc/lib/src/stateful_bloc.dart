import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

abstract class StatefulBloc<A, B> extends Bloc<A, B> {
  @mustCallSuper
  void initState(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
  }

  @mustCallSuper
  void didChangeDependencies(BuildContext context) {}

  @mustCallSuper
  void deactivate() {}
}

typedef S BlocCreator<S>();

class StatefulBlocProvider<T extends StatefulBloc<dynamic, dynamic>>
    extends StatefulWidget {
  const StatefulBlocProvider({
    Key key,
    this.bloc,
    this.blocCreator,
    @required this.child,
  })  : assert(
            (bloc == null && blocCreator != null) ||
                (bloc != null && blocCreator == null),
            'Please supply either a bloc or a bloc creator function, but not both.'),
        assert(child != null),
        super(key: key);

  final Widget child;

  /// The Bloc which is to be made available throughout the subtree
  final T bloc;

  /// A Bloc creating function: [() => new T]
  /// replace T with the actual class name.
  /// This workaround allows to instantiate T
  /// (Dart does not allow instantiation of generic types.
  final BlocCreator<T> blocCreator;

  @override
  BlocProviderState createState() => BlocProviderState<T>(blocCreator);

  /// Method that allows widgets to access the bloc as long as their `BuildContext`
  /// contains a `StatefulBlocProvider` instance.
  static B of<B extends StatefulBloc<dynamic, dynamic>>(BuildContext context) {
    BlocProviderState<B> provider =
        context.ancestorStateOfType(TypeMatcher<StatefulBlocProvider<B>>());
    return provider.bloc;
  }
}

class BlocProviderState<T extends StatefulBloc<dynamic, dynamic>>
    extends State<StatefulBlocProvider<T>> {
  BlocCreator<T> creator;
  BlocProviderState(BlocCreator<T> this.creator);
  @override
  void initState() {
    super.initState();
    if (widget.bloc != null)
      bloc = widget.bloc;
    else
      bloc = creator();
    bloc.initState(context);
  }

  T bloc;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.didChangeDependencies(context);
  }

  @override
  void deactivate() {
    bloc.deactivate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
