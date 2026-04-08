import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorts/data/models/fetching_model.dart';

import '/core/constants/status_switcher.dart';
import 'fetching_cubit.dart';
import 'fetching_state.dart';

class FetchingPage extends StatefulWidget {
  final FetchingCubit cubit;

  const FetchingPage({super.key, required this.cubit});

  @override
  State<FetchingPage> createState() => _FetchingState();
}

class _FetchingState extends State<FetchingPage> {
  FetchingCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: cubit.fetching,
        color: scheme.primary,
        child: BlocBuilder(
          bloc: cubit,
          builder: (context, state) {
            state as FetchingState;
            return state.response.toWidget(
              onLoading: (context) => const Center(child: Text("Loading...")),
              onCompleted: (context, data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final usr = data[index];
                  return UserCardUI(user: usr);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserCardUI extends StatelessWidget {
  const UserCardUI({super.key, required this.user});
  final FetchingModel user;

  @override
  Widget build(BuildContext context) {
    final address = user.address;
    final company = user.company;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 26, child: Text(user.name[0])),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@${user.username}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Email
            Row(
              children: [
                Icon(Icons.email, size: 18),
                SizedBox(width: 8),
                Text(user.email),
              ],
            ),

            const SizedBox(height: 8),

            /// Phone
            Row(
              children: [
                Icon(Icons.phone, size: 18),
                SizedBox(width: 8),
                Text(user.phone),
              ],
            ),

            const Divider(height: 20),

            /// Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 18),
                SizedBox(width: 8),
                Expanded(child: Text(address!.street)),
              ],
            ),

            const SizedBox(height: 8),

            /// Company
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.business, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${company!.name}\n${company.catchPhrase}",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
