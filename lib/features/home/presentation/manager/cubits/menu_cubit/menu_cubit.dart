import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit() : super(MenuInitial());
}
