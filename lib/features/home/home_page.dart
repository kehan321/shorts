import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shorts/core/constants/status_switcher.dart';
import 'package:shorts/core/utils/extensions.dart';
import 'package:shorts/data/models/home_model.dart';

import 'home_cubit.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  final HomeCubit cubit;

  const HomePage({super.key, required this.cubit});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  HomeCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: cubit.home,
        child: BlocBuilder(
          bloc: cubit,
          builder: (context, state) {
            state as HomeState;
            return state.response.toWidget(
              onCompleted: (cxt, data) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 163 / 56,
                      crossAxisSpacing: 10.r,
                      mainAxisSpacing: 10.r,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) =>
                        HomeWidget(data: data[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key, required this.data});

  final HomeModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000).withValues(alpha: 0.2),
            blurRadius: 15.r,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 6.r,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 4.r,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],

        color: Colors.red,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: data.downloadUrl,
              width: 53.w,
              height: double.infinity,

              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.r),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,

                children: [
                  Text(
                    data.author,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  Text(data.id, style: context.theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
