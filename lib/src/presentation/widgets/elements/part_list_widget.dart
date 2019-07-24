import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_cv_client_flutter/bloc.dart';
import 'package:social_cv_client_flutter/domain.dart';

abstract class PartListWidget extends StatefulWidget {
  final String parentProfileId;
  final String ownerId;
  final PartListBloc partListBloc;

  PartListWidget({
    Key key,
    this.parentProfileId,
    this.ownerId,
    this.partListBloc,
  })  : assert(
            parentProfileId != null && ownerId == null && partListBloc == null),
        assert(
            parentProfileId == null && ownerId != null && partListBloc == null),
        assert(
            parentProfileId == null && ownerId == null && partListBloc != null),
        super(key: key);
}

/// If [widget.partListBloc] exists the lifecycle of it will be managed by its creator
abstract class PartListWidgetState<T extends PartListWidget> extends State<T> {
  PartListBloc partListBloc;

  @override
  void initState() {
    super.initState();

    partListBloc = widget.partListBloc;

    if (widget.partListBloc == null) {
      final partRepo = Provider.of<PartRepository>(context, listen: false);

      partListBloc = PartListBloc(repository: partRepo);
      partListBloc.dispatch(PartListInitialized(
        parentProfileId: widget.parentProfileId,
        ownerId: widget.ownerId,
      ));
    }
  }

  @override
  void dispose() {
    if (widget.partListBloc == null) partListBloc.dispose();
    super.dispose();
  }
}