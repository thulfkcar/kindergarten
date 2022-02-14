import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/providers/Providers.dart';

import '../../../network/ApiResponse.dart';
import '../genral_components/Error.dart';
import '../genral_components/loading.dart';
import 'Activities/Activities.dart';
import 'HomeViewModel.dart';

// import 'HomeViewModel.dart';
//
// class Home extends StatefulWidget {
//   Home({Key? key}) : super(key: key);
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   ScrollController _scrollController = ScrollController();
//
//   var loadingNext = false;
//   var loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     _scrollController.addListener(() {
//       if (_scrollController.position.maxScrollExtent ==
//           _scrollController.position.pixels) {
//         print("bottom end");
//         // if (!isLoading) {
//         //   isLoading = !isLoading;
//         //   // Perform event when user reach at the end of list (e.g. do Api call)
//         // }
//       }
//     });
//     return Scaffold(
//       body: Consumer(
//         builder: (context, ref, child) {
//           final viewModel = ref.watch(HomeViewModelProvider);
//           switch (viewModel.childActivitiesApiResponse.status) {
//             case Status.LOADING_NEXT_PAGE:
//               print("thug :: Loading next page");
//               return ActivitiesListView(
//                   viewModel.childActivitiesApiResponse.data!, true);
//             case Status.LOADING:
//               loading = true;
//               print("thug :: LOADING");
//               return LoadingWidget();
//             case Status.ERROR:
//               loading = false;
//               print("thug :: ERROR");
//               return MyErrorWidget(
//                   viewModel.childActivitiesApiResponse.message ?? "NA");
//             case Status.COMPLETED:
//               loading = false;
//
//               print("thug :: COMPLETED");
//               return ActivitiesListView(
//                   viewModel.childActivitiesApiResponse.data!, false);
//             default:
//           }
//
//           return Container();
//         },
//       ),
//     );
//   }
//
//   Widget ActivitiesListView(List<Child> data, bool loadingNextPage) {
//     var progress = CircularProgressIndicator();
//     return Column(
//       children: [
//         Activities(
//           scrollController: _scrollController,
//           children: data,
//         ),
//         if (loadingNext) progress
//       ],
//     );
//   }
// }

class HomeX extends ConsumerWidget {
  HomeX({
    Key? key,
  }) : super(key: key);
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(HomeViewModelProvider);
    return Scaffold(body: body(viewModel));
  }

  Widget body(HomeViewModel viewModel) {
    var state = viewModel.childActivitiesApiResponse.status;
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (state == Status.COMPLETED) {
          print("bottom end");
          viewModel.fetchNextChildrenWithInfo();
        }
      }
    });
    Activities? activities ;
    switch (viewModel.childActivitiesApiResponse.status) {
      case Status.LOADING_NEXT_PAGE:
        print("thug :: Loading next page");
        break;
      case Status.LOADING:
        print("thug :: LOADING");
        return LoadingWidget();
      case Status.ERROR:
        print("thug :: ERROR");
        return MyErrorWidget(
            viewModel.childActivitiesApiResponse.message ?? "NA");
      case Status.COMPLETED:
        print("thug :: COMPLETED");
        activities ??= Activities(
            scrollController: _scrollController,
            children: viewModel.childActivitiesApiResponse.data!,
          );
        return activities;
      default:
    }

    return Container();
  }
}
