import 'package:smarthome/provider/local/local_provider.dart';
import 'package:smarthome/provider/remote/control_device_provider.dart';

abstract class ControlDeviceRepo {
  Future<bool> controlDeviceWithRPCRequest(String method, dynamic params,
      {String id});
}

class ControlDeviceRepoImpl implements ControlDeviceRepo {
  final ControlDeviceProvider controlDeviceProvider;
  final LocalProvider localProvider;

  ControlDeviceRepoImpl(this.controlDeviceProvider, this.localProvider);

  @override
  Future<bool> controlDeviceWithRPCRequest(String method, params,
      {String id}) async {
    final token = await localProvider.getDataWithKey(LocalKeys.accessToken);
    return await controlDeviceProvider.sendRPCDeviceRequest(
        token, method, params);
  }
}
