import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

/// A Flutter widget which provides a bloc to its children via `BlocProvider.of(context)`.
/// It is used as a DI widget so that a single instance of a bloc can be provided
/// to multiple widgets within a subtree.
class BlocProvider<T extends Bloc<dynamic, dynamic>> extends StatelessWidget {
  const BlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
  })  : assert(bloc != null),
        super(key: key);

  /// The Bloc which is to be made available throughout the subtree
  final T bloc;

  final Widget child;

  /// Method that allows widgets to access the bloc as long as their `BuildContext`
  /// contains a `BlocProvider` instance.
  static B of<B extends Bloc<dynamic, dynamic>>(BuildContext context) {
    Type typeOf<B>() => B;
    BlocProvider<B> provider =
        context.ancestorWidgetOfExactType(typeOf<BlocProvider<B>>());
    return provider.bloc;
  }

  @override
  Widget build(BuildContext context) => child;
}

class StatefulBlocProvider<T extends StatefulBloc<dynamic, dynamic>> extends StatefulWidget {
  const StatefulBlocProvider({
    Key key,
    @required this.bloc,
    @required this.child,
  })
      : assert(bloc != null),
        super(key: key);

  final Widget child;

  /// The Bloc which is to be made available throughout the subtree
  final T bloc;

  @override
  BlocProviderState createState() => BlocProviderState<T>();

  /// Method that allows widgets to access the bloc as long as their `BuildContext`
  /// contains a `StatefulBlocProvider` instance.
  static B of<B extends StatefulBloc<dynamic, dynamic>>(BuildContext context) {
    Type typeOf<B>() => B;
    StatefulBlocProvider<B> provider =
    context.ancestorWidgetOfExactType(typeOf<StatefulBlocProvider<B>>());
    return provider.bloc;
  }
}

class BlocProviderState<T extends StatefulBloc<dynamic, dynamic>>
    extends State<StatefulBlocProvider<T>> {



  @override
  @mustCallSuper
  void initState() {
    super.initState();
    widget.bloc.initState(context);
  }


  @override
  @mustCallSuper
  void dispose() {
    widget.bloc.dispose(context);
    super.dispose();
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.bloc.didChangeDependencies(context);
  }

  @override
  @mustCallSuper
  void deactivate() {
    widget.bloc.deactivate(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

abstract class StatefulBloc<A, B> extends Bloc<A, B>{
  void initState(BuildContext context){}
  void dispose(BuildContext context){}
  void didChangeDependencies(BuildContext context){}
  void deactivate(BuildContext context){}
}



