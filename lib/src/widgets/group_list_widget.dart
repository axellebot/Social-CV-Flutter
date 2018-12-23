import 'package:cv/src/blocs/bloc_provider.dart';
import 'package:cv/src/blocs/group_list_bloc.dart';
import 'package:cv/src/commons/utils.dart';
import 'package:cv/src/models/group_model.dart';
import 'package:cv/src/models/part_model.dart';
import 'package:cv/src/widgets/card_error_widget.dart';
import 'package:cv/src/widgets/error_content_widget.dart';
import 'package:cv/src/widgets/group_widget.dart';
import 'package:cv/src/widgets/loading_shadow_content_widget.dart';
import 'package:flutter/material.dart';

class GroupListWidget extends StatelessWidget {
  GroupListWidget({
    this.fromPartModel,
    this.fromSearch,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
  });

  final PartModel fromPartModel;
  final Object fromSearch;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context) {
    if (fromPartModel != null) {
      return _buildFromPartModel(context);
    } else if (fromSearch != null) {
      return _buildFromSearch(context);
    }
    return ErrorContent("Not supported");
  }

  Widget _buildFromPartModel(BuildContext context) {
    GroupListBloc _groupListBloc = BlocProvider.of<GroupListBloc>(context);
    _groupListBloc.fetchPartGroups(fromPartModel.id);

    return StreamBuilder<List<GroupModel>>(
      stream: _groupListBloc.groupsStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<GroupModel>> snapshot) {
        if (snapshot.hasError) {
          return _buildError(context, snapshot.error);
        } else if (snapshot.hasData) {
          return _buildGroups(context, snapshot.data);
        }
        return _buildLoadingGroups(context, fromPartModel.groupIds.length);
      },
    );
  }

  Widget _buildFromSearch(context) {
    return ErrorContent("Not Implemented Yet");
  }

  Widget _buildError(BuildContext context, error) {
    return ListView(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: <Widget>[
        CardError(message: translateError(context, error)),
      ],
    );
  }

  Widget _buildLoadingGroups(BuildContext context, int count) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: count,
      itemBuilder: (BuildContext context, int i) {
        return LoadingShadowContent(
          numberOfTitleLines: 1,
          numberOfContentLines: 3,
        );
      },
    );
  }

  Widget _buildGroups(BuildContext context, List<GroupModel> groupModels) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: groupModels.length,
      itemBuilder: (BuildContext context, int i) {
        return GroupWidget(groupModels[i]);
      },
    );
  }
}