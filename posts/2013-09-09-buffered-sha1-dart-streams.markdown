---
title: Buffered SHA1 in Dart with a StreamTransformer
author: Ali
tags: dart, sha1, streams
---

I've been hacking somewhat on a [Dart] client for [Camlistore] recently, and as
part of that I need to take a SHA1 hash of files. This is easy to do in Dart, as
the [Crypto] package takes care of me, and I can produce a simple
implementation.

~~~ {.java}
String sha1(List<int> bs) {
  final crypto.SHA1 sha1 = new crypto.SHA1();
  sha1.add(bs);
  final hexdgst = crypto.CryptoUtils.bytesToHex(sha1.close());
  return 'sha1-${hexdgst}';
}

Future<String> sha1File(String filename) =>
  return new File(filename).readAsBytes().then(sha1);

sha1File('/home/ali/banana.png').then(print);
~~~

This is fine until I read a 2 gigabyte file. At that point, I need to buffer the
loading. Dart streams to the rescue. You can read a file as
a `Stream<List<int>>` and using a `StreamTransformer` can just convert that
stream into a `Stream<String>` which is the SHA1.

~~~ {.java}
bufferedSha1Transformer() {
  final sha1 = new crypto.SHA1();
  return new StreamTransformer<List<int>, String>(
    handleData: (List<int> value, EventSink<String> sink) {
      sha1.add(value);
    },
    handleDone: (EventSink<String> sink) {
      final dgst = crypto.CryptoUtils.bytesToHex(sha1.close());
      sink.add('sha1-${dgst}');
    }
  );
}

Stream<String> sha1BufferedFile(String filename) =>
  new File(filename).openRead().transform(bufferedSha1Transformer());

sha1BufferedFile('/home/ali/banana.png').listen(print);
~~~

The file is read in chunks of 65536 bytes, and added to the SHA1. When the file
is finished the target stream (sink) emits the digest.

Neat, eh? I'll admit until today I thought Dart streams were annoying, but now
I am converted.

[Dart]: http://dartlang.org
[Camlistore]: http://camlistore.org/
[Crypto]: http://api.dartlang.org/docs/bleeding_edge/crypto.html

