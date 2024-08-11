import 'package:flutter/material.dart';
import 'package:sportifind/features/stadium/presentations/bloc/owner_stadium_bloc.dart';
import 'package:sportifind/features/stadium/presentations/screens/stadium_search_screen.dart';


class OwnerStadiumScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const OwnerStadiumScreen());

  const OwnerStadiumScreen({super.key});

  @override
  State<OwnerStadiumScreen> createState() => _OwnerStadiumScreenState();
}

class _OwnerStadiumScreenState extends State<OwnerStadiumScreen> {
  late OwnerStadiumBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = OwnerStadiumBloc(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OwnerStadiumState>(
      stream: _bloc.stateStream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? _bloc.currentState;

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage.isNotEmpty) {
          return Center(child: Text(state.errorMessage));
        }

        if (state.user == null) {
          return const Center(child: Text('User data not available'));
        }

        return RefreshIndicator(
          onRefresh: _bloc.refreshStadiums,
          child: StadiumSearchScreen(
            userLocation: state.user!.location,
            stadiums: state.stadiums,
            owners: [state.user!],
            isStadiumOwnerUser: true,
          ),
        );
      },
    );
  }
}