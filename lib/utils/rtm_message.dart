import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RTMMessage {
  static AgoraRtmClient _client;
  static var _channels = <String, AgoraRtmChannel>{};

  static init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _client =
        await AgoraRtmClient.createInstance('9c2be3809d414367a9eac783c3621d72');
    _client.login(token, userId)
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      print("Peer msg: " + peerId + ", msg: " + message.text);
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
    var channel = await _client.createChannel(peerId);
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
    }
    return channel;
  }

  static sendMessage(String peerId, String text) async {
    var _channel = await createChannel(peerId);
    try {
      await _channel.sendMessage(AgoraRtmMessage.fromText(text), true);
      print('Send channel message success.');
    } catch (errorCode) {
      print('Send channel message error: ' + errorCode.toString());
    }
  }
}
