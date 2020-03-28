import 'package:erploja/blocs/login_bloc.dart';
import 'package:erploja/screens/HomeScreen.dart';
import 'package:erploja/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginBloc = LoginBloc();

  @override
  void initState() { 
    super.initState();
    
    _loginBloc.outState.listen((state){
      switch (state) {
        case LoginState.SUCCESS:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen())
            );
          break;
        case LoginState.FAIL: 
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text('Usuarios invalidos!'),
          ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
          break;
        default:
      }
    });
  }


  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        builder: (context, snapshot) {
          print(snapshot.data);
          switch (snapshot.data) {
            case LoginState.LOADING:
              return Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.pinkAccent)),
              );
              break;
            case LoginState.FAIL:
            case LoginState.IDLE:
            case LoginState.SUCCESS: 
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.store_mall_directory,
                            color: Colors.pinkAccent,
                            size: 160,
                          ),
                          InputField(
                            icon: Icons.person_outline,
                            hint: "E-mail",
                            obscure: false,
                            stream: _loginBloc.outEmail,
                            onChanged: _loginBloc.changeEmail,
                          ),
                          InputField(
                            icon: Icons.lock_outline,
                            hint: "Password",
                            obscure: true,
                            stream: _loginBloc.outPassword,
                            onChanged: _loginBloc.changePassword,
                          ),
                          SizedBox(height: 32,),
                          StreamBuilder<bool>(
                            stream: _loginBloc.outSubmitValid,
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: 50,
                                child: RaisedButton(
                                  onPressed: snapshot.hasData ? _loginBloc.submit : null,
                                  color: Colors.pinkAccent,
                                  textColor: Colors.white,
                                  child: Text('Login'),
                                  disabledColor: Colors.pinkAccent.withAlpha(140),
                                ),
                              );
                            }
                          )
                        ],
                      )
                    ),
                  ),
                ],
              );
            default:
              return Center(
                child: Container(
                  child: Text('Sorry guys! \n App is off.',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              );
          }
        }
      ),
    );
  }
}