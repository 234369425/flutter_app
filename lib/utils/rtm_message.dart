import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/bean/Relay.dart';
import 'package:flutter_app/db/DBOpera.dart';

class RTMMessage {
  static AgoraRtmClient _client;
  static var _channels = <String, AgoraRtmChannel>{};
  static String user = "";
  static String title = "";
  static dynamic callback = (dynamic s) {};
  static dynamic listCallback = (dynamic s) {};
  static var imageCache = {};

  static logout() async {
    _client.logout();
    _channels.clear();
  }

  static registerQuestionList(dynamic fn) {
    listCallback = fn;
  }

  static unRegisterQuestionList() {
    listCallback = (dynamic s) {};
  }

  static registerCurrent(String u, String t, dynamic cb) {
    user = u;
    title = t;
    callback = cb;
  }

  static unRegister() {
    user = '';
    title = '';
    callback = (dynamic s) {};
  }

  static init(String user) async {
    WidgetsFlutterBinding.ensureInitialized();
    _client =
        await AgoraRtmClient.createInstance('9c2be3809d414367a9eac783c3621d72');

    _client.login(null, user);

    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      print("Peer msg: " + peerId + ", msg: " + message.text);
      try {
        var mess = jsonDecode(message.text);
        mess['user'] = peerId;
        var relay = Relay.fromJson(mess);
        //数据已经拆包
        if (relay.all != null) {
          var data = imageCache[relay.tid];
          if (data == null) {
            data = List(relay.all);
          }
          data[relay.sec] = relay.image;
          for (var i = 0; i < data.length; i++) {
            if (data[i] == null) {
              return;
            }
          }

          var imageData = '';
          for (var i = 0; i < data.length; i++) {
            imageData += data[i];
          }
          relay.image = imageData;
        }

        var isNew = 1;
        if (mess['title'] == title) {
          callback(relay);
          isNew = 0;
        }
        listCallback(relay);
        DBOperator.insertRelay(relay, newMessage: isNew);
      } catch (e) {
        print(e);
      }
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      print('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client.logout();
        print('Logout.');
      }
    };
  }

  static Future<AgoraRtmChannel> createChannel(String peerId) async {
    var channel = _channels[peerId];
    if (channel == null) {
      channel = await _client.createChannel(peerId);
      _channels[peerId] = channel;
      channel.onMemberJoined = (AgoraRtmMember member) {
        print("Member joined: " +
            member.userId +
            ', channel: ' +
            member.channelId);
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        print(
            "Member left: " + member.userId + ', channel: ' + member.channelId);
      };
      channel.onMessageReceived =
          (AgoraRtmMessage message, AgoraRtmMember member) {
        print("Channel msg: " + member.userId + ", msg: " + message.text);
      };
      _channels[peerId] = channel;
    }
    return channel;
  }

  static sendRelayMessage(
      String peerId, Relay relay, dynamic success, dynamic fail) async {
    var k30 = 20 * 1000;

    //处理message长度过长
    if (relay.image == null || relay.image.length < k30) {
      sendMessage(peerId, relay.toJsonStr(), success, fail);
      return;
    }
    relay.tid = DateTime.now().microsecond;
    var image = relay.image;

    var blocks =
        relay.image.length / k30 + (relay.image.length % k30 == 0 ? 0 : 1);

    for (var i = 0; i < blocks; i++) {
      try {
        var end = k30 * (i + 1);
        end = end > image.length - 1 ? image.length - 1 : end;
        relay.image = image.substring(i * k30, end);
        relay.sec = i;
        AgoraRtmMessage message = AgoraRtmMessage.fromText(relay.toJsonStr());
        _client.sendMessageToPeer(peerId, message, true);
        print('Send channel message success.');
      } catch (errorCode) {
        if (errorCode != "4") {
          fail();
          return;
        }
        print('Send channel message error: ' + errorCode.toString());
      }
    }
    success();
  }

  static sendMessage(
      String peerId, String text, dynamic success, dynamic fail) async {
    try {
      AgoraRtmMessage message = AgoraRtmMessage.fromText(text);
      _client.sendMessageToPeer(peerId, message, true);
      print('Send channel message success.');
      success();
    } catch (errorCode) {
      if (errorCode == "4") {
        success();
      } else {
        fail();
      }
      print('Send channel message error: ' + errorCode.toString());
    }
  }
}
