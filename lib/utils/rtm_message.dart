import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/bean/Relay.dart';
import 'package:flutter_app/db/DBOpera.dart';

class RTMMessage {
  static AgoraRtmClient _client;
  static var _channels = <String, AgoraRtmChannel>{};

  static init(String user) async {
    WidgetsFlutterBinding.ensureInitialized();
    _client =
        await AgoraRtmClient.createInstance('9c2be3809d414367a9eac783c3621d72');

    _client.login(null, user);

    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      print("Peer msg: " + peerId + ", msg: " + message.text);
      try {
        var mess = jsonDecode(message.text);
        DBOperator.insertRelay(Relay.fromJson(mess));
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
