import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/data/model/api/video_model.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';

import '../../../../core/util/my_box_decoration.dart';
import '../../video_player/video_player_page.dart';
import '../bloc/edited_video_bloc.dart';
import '../../../widgets/empty_video_list_widget.dart';

class UploadedEditedVideoPage extends StatelessWidget {
  const UploadedEditedVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySizes.widgetSideSpace),
      child: BlocBuilder<EditedVideoBloc, EditedVideoState>(
        builder: (context, state) {
          if (state.requestState == RequestState.loading) {
            return const LoadingWidget();
          } else if (state.requestState == RequestState.loaded) {
            if(state.data!.data != null) {
              return state.data!.data!.isNotEmpty
                ? GridView.count(
                    shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 1 / 1,
                    children: List.generate(state.data!.data!.length, (index) {
                      VideoModel data = state.data!.data![index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return VideoPlayerPage(url: data.videoUrl);
                            },
                          ));
                        },
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: myBoxDecoration.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                            const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 60,
                                  color: Colors.white70,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      data.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "00:30",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                : const EmptyVideoListWidget();
            }
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
