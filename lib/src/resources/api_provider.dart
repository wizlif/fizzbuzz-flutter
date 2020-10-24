import 'package:dio/dio.dart';
import 'package:fizzbuzz/src/mixins/dio.dart';
import 'package:fizzbuzz/src/models/JoinResponse.dart';
import 'package:fizzbuzz/src/models/session.dart';
import 'package:fizzbuzz/src/resources/source.dart';

import '../config.dart' show api;
class ApiProvider with DioErrorMixin implements Source {
  Dio _dio;

  ApiProvider(){
    _dio = Dio(
      BaseOptions(
        baseUrl: api,
      ),
    );
  }

  @override
  Future<List<GameSession>> fetchPreviousSessions() async{
    try{
      final _response = await _dio.get<List>("/sessions");
      return _response.data.map<GameSession>((v) =>  GameSession.fromJson(v)).toList();
    } on DioError catch(e){
      if(e.response != null && e.response.statusCode == 400) {
        return Future.error((e.response.data as Map)['message']);
      }else{
        return Future.error(handleError(e));
      }
    }catch (error) {
      return Future.error(error.toString());
    }
  }

  @override
  Future<GameSession> play(int id,String choice) async{
    try{
      Map<String,dynamic> req = new Map<String, dynamic>();
      req['guess'] = choice;
      req['id'] = id;

      final _response = await _dio.post<Map<String,dynamic>>("/play",data:req);
      return GameSession.fromJson(_response.data);
    } on DioError catch(e){
      if(e.response != null && e.response.statusCode == 400) {
        return Future.error((e.response.data as Map)['message']);
      }else{
        return Future.error(handleError(e));
      }
    }catch (error) {
      return Future.error(error.toString());
    }
  }

  @override
  Future<JoinResponse> joinGame() async{
    try{
      final _response = await _dio.get<Map<String,dynamic>>("/join");
      print(_response.data);
      return JoinResponse.fromJson(_response.data);
    } on DioError catch(e){
      if(e.response != null && e.response.statusCode == 400) {
        return Future.error((e.response.data as Map)['message']);
      }else{
        return Future.error(handleError(e));
      }
    }catch (error) {
      return Future.error(error.toString());
    }
  }

}

final API = ApiProvider();