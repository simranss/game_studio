// A real "can we reach the internet?" test. Uses dart:io where it exists;
// the web build gets a stub (ads never run there anyway).
export 'net_probe_stub.dart' if (dart.library.io) 'net_probe_io.dart';