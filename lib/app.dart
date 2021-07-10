import 'package:quap/generated/qua.pbgrpc.dart';

import 'client.dart';
import 'package:grpc/grpc.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('provide name arg');
    return;
  }

  final channel = ClientChannel(
    '127.0.0.1',
    port: 7777,
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    ),
  );

  final stub = QuaClient(channel);

  await QuaTerminalClient(stub, candidateName: args[0]).quaInterview();
  await channel.shutdown();
}
