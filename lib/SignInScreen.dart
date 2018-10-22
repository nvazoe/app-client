import 'ConfirmAccountScreen.dart';
import 'SignUpScreen.dart';
import 'HomeScreen.dart';
import 'package:flutter/material.dart';
import 'Utils/MyBehavior.dart';
import 'Utils/AppSharedPreferences.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'DAO/Presenters/LoginPresenter.dart';
import 'Models/Client.dart';
import 'EmailRecoveryAccountScreen.dart';

class SignInScreen extends StatefulWidget {
  @override
  createState() => new SignInScreenState();
}

class SignInScreenState extends State<SignInScreen>
    implements LoginContract {
  bool _isLoading = false;
  bool _showError = false;
  bool hide_content = true;
  String _errorMsg ;
  static const double padding_from_screen = 30.0;

  final emailKey = new GlobalKey<FormState>();
  final passKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _email;

  LoginPresenter _presenter;

  SignInScreenState() {
    _presenter = new LoginPresenter(this);
  }

  void _submit() {
    emailKey.currentState.save();
    passKey.currentState.save();

    if (_email.length == 0 || _password.length == 0) {
      setState(() {
        _errorMsg = "Renseigner vos identifiants";
        _showError = true;
      });
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(_email)) {
        setState(() {
          _errorMsg = "Email invalide";
          _showError = true;
        });
      } else {
        setState(() {
          _isLoading = true;
          _showError = false;
        });
        _presenter.doLogin(_email, _password, false);
      }
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  Widget showError() {
    return _showError
        ? Container(
            margin: EdgeInsets.only(
                left: padding_from_screen, right: padding_from_screen),
            child: Center(
              child: Text(
                _errorMsg,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    void _update_state() {
      setState(() {
        hide_content = !hide_content;
      });
    }

    Container buildEntrieRow(IconData startIcon, IconData endIcon,
        String hintText, TextInputType inputType, bool hide_content) {
      Color color = Colors.grey;
      return Container(
        decoration: new BoxDecoration(border: new Border.all(color: color, width: 2.0)),
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(
            left: padding_from_screen, right: padding_from_screen),
        child: new Form(
            key: emailKey,
            child: Row(
              children: [
                Icon(startIcon, color: color),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: TextFormField(
                            onSaved: (val) => _email = val,
//                        validator: (val) {
////                          if(val.length == 0)
////                              return "Aucun email entré";
////                          else {
////                            Pattern pattern =
////                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
////                            RegExp regex = new RegExp(pattern);
////                            if (!regex.hasMatch(val))
////                              return "Entrer un email valide";
////                            else
////                              return null;
////                          }
//                        },
                            obscureText: hide_content,
                            autofocus: false,
                            autocorrect: false,
                            maxLines: 1,
                            keyboardType: inputType,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: hintText,
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )))),
                Icon(endIcon, color: color),
              ],
            )),
      );
    }

    Container buildPassEntry(String hintText) {
      Color color = Colors.grey;
      return Container(
        decoration: new BoxDecoration(border: new Border.all(color: color, width: 2.0)),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        margin: EdgeInsets.only(
            left: padding_from_screen,
            right: padding_from_screen,
            top: 10.0,
            bottom: 10.0),
        child: Form(
          key: passKey,
          child: Row(
            children: [
              Icon(Icons.lock, color: color),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: TextFormField(
                          onSaved: (val) => _password = val,
                          obscureText: hide_content,
                          autofocus: false,
                          autocorrect: false,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: hintText
                          ),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )))),
              IconButton(
                  onPressed: _update_state,
                  icon: Icon(
                    hide_content ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ))
            ],
          ),
        ),
      );
    }

    Widget buttonSection = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen,
            right: padding_from_screen,
            top: 30.0,
            bottom: 15.0),
        child: RaisedButton(
          onPressed: _submit,
          child: SizedBox(
            width: double.infinity,
            child: Text("ME CONNECTER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          textColor: Colors.white,
          color: Colors.lightGreen,
          elevation: 1.0,
        ));

    Widget sinscrire = Container(
        padding: const EdgeInsets.only(
            left: padding_from_screen,
            right: padding_from_screen,
            top: 25.0,
            bottom: 15.0),
        child: Row(children: <Widget>[
          new RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                    text: 'Vous n\'avez pas de compte?',
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
              child: PositionedTapDetector(
                  onTap: (position) {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => SignUpScreen()));
                  },
                  child: Text('  S\'inscrire',
                      style: new TextStyle(
                        color: Colors.lightGreen,
                        decoration: TextDecoration.none,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ))))
        ]));

    return Material(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  children: [
                    Image.asset(
                      'images/header.jpg',
                      width: double.infinity,
                      height: 210.0,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 20.0,
                          bottom: 30.0,
                          left: padding_from_screen,
                          right: padding_from_screen),
                      child: new Text(
                          'Heureux de vous revoir ! Connectez-vous pour continuer',
                          style: new TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    buildEntrieRow(Icons.email, null, "Entrer un email",
                        TextInputType.emailAddress, false),
                    buildPassEntry("Entrer le mot de passe"),
                    showError(),
                    _isLoading
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: padding_from_screen,
                                right: padding_from_screen,
                                top: 30.0,
                                bottom: 15.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : buttonSection,
                    sinscrire,
                    Row(children: <Widget>[
                      PositionedTapDetector(
                          onTap: (position) {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => EmailRecoveryAccountScreen()));
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: padding_from_screen, right: padding_from_screen, bottom: 15.0),
                              child: Text('Mot de passe oublié ?',
                                  style: new TextStyle(
                                    color: Colors.lightGreen,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )))),
                      Expanded(
                        child: Text(''),
                      )
                    ])
                  ],
                )),
            Container(
              height: AppBar().preferredSize.height,
              child: AppBar(
                title: Text('Connexion au compte'),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onLoginError() {
    setState(() {
      _isLoading = false;
      _errorMsg = "Email ou mot de passe erroné";
      _showError = true;
    });
  }

  @override
  void onLoginSuccess(Client client) async {

    setState(() => _isLoading = false);
    if(true) { // si le compte est activee

      AppSharedPreferences().setAppLoggedIn(true); // on memorise qu'un compte s'est connecter
      Navigator.of(context)
          .pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => HomeScreen()),
          ModalRoute.withName(Navigator.defaultRouteName));

    }else{ // si le compte n'est pas activee

      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => ConfirmAccountScreen(clientId: client.id, isForResetPassword: false, clientEmail: _email,)));
    }
  }

  @override
  void onConnectionError() {
    _showSnackBar("Échec de connexion. Vérifier votre connexion internet");
    setState(() => _isLoading = false);
  }
}
