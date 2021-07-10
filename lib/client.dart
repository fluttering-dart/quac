import 'dart:async';
import 'dart:io';

import 'package:quap/generated/qua.pbgrpc.dart';

class QuaTerminalClient {
  final String candidateName;

  final QuaClient stub;

  QuaTerminalClient(this.stub, {this.candidateName = 'n/a'});

  Future<void> quaInterview() async {
    final candidateStreamController = StreamController<QuaMessage>();

    final serviceStream = stub.quaInterview(candidateStreamController.stream);

    candidateStreamController
        .add(_createMessage(candidateName, 'I am ready for the interview'));

    await for (var message in serviceStream) {
      print('Message from ${message.from}:\n${message.body}');

      if (message.body.toLowerCase().contains('thank')) {
        return;
      }
      print('enter your answer:\n');

      final answer = stdin.readLineSync();

      candidateStreamController.add(_createMessage(candidateName, answer!));
    }
  }
}

QuaMessage _createMessage(String from, String text) => QuaMessage()
  ..from = from
  ..body = text;
