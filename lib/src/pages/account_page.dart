import 'package:cv/src/blocs/account_bloc.dart';
import 'package:cv/src/blocs/bloc_provider.dart';
import 'package:cv/src/commons/paths.dart';
import 'package:cv/src/localizations/localization.dart';
import 'package:cv/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building AccountPage');

    AccountBloc _accountBloc = BlocProvider.of<AccountBloc>(context);

    return SafeArea(
      child: Stack(
        children: <Widget>[
          StreamBuilder<bool>(
            stream: _accountBloc.isFetchingStream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return LinearProgressIndicator();
              }
              return Container();
            },
          ),
          StreamBuilder<bool>(
            stream: _accountBloc.isAuthenticatedStream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true)
                  return _buildConnectedAccount(context);
                if (snapshot.data == false)
                  return _buildNotConnectedAccount(context);
              } else if (snapshot.hasError) {
                return Container(
                    child: Text("Could not verify data ${snapshot.error}"));
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedAccount(context) {
    AccountBloc _accountBloc = BlocProvider.of<AccountBloc>(context);

    return StreamBuilder<UserModel>(
      stream: _accountBloc.fetchAccountDetailsStream,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          UserModel userModel = snapshot.data;
          return _buildAccountDetails(context, userModel);
        } else if (snapshot.hasError) {
          return Container(
              child: Text("Could not retrieve data ${snapshot.error}"));
        }
        return Container();
      },
    );
  }

  Center _buildNotConnectedAccount(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text(Localization.of(context).loginCTA),
        onPressed: () => _navigateToLogin(context),
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context, UserModel userModel) {
    return ListView(
      children: <Widget>[
        ExpansionTile(
          leading: Icon(MdiIcons.accountBoxMultiple),
          title: Text(Localization.of(context).accountMyProfile),
          children: _buildProfiles(context, userModel.profileIds),
        ),
      ],
    );
  }

  List<ListTile> _buildProfiles(BuildContext context, List<String> ids) {
    List<ListTile> _widgets = [];
    ids.forEach((profileId) {
      _widgets.add(ListTile(
        title: Text("CV $profileId"),
        subtitle: Text(profileId),
        onTap: () =>
            Navigator.of(context).pushNamed(kPathProfile + '/$profileId'),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
        ),
        trailing: Icon(MdiIcons.accountDetails),
      ));
    });
    return _widgets;
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamed(kPathLogin);
  }
}
