---
title: Watching a file system directory with inotify and Linux
author: Ali
tags: twisted, inotify
---

> "Inotify is a Linux kernel subsystem that acts to extend filesystems to notice
> changes to the filesystem, and report those changes to applications."

[[Citation Needed]](http://en.wikipedia.org/wiki/Inotify)

You can use this service from Python using
[Twisted](http://twistedmatrix.com/trac/) to watch a directory and its contents.
Twisted is perfect for this as you likely want to be doing a number of other
things at the same time, for example, making an HTTP request every time a change
is noticed. The code is so monstrously simple, I will just paste it below.


~~~ {.python}
from twisted.internet import inotify
from twisted.python import filepath

class FileSystemWatcher(object):

  def __init__(self, path_to_watch):
    self.path = path_to_watch

  def Start(self):
    notifier = inotify.INotify()
    notifier.startReading()
    notifier.watch(filepath.FilePath(self.path),
                   callbacks=[self.OnChange])

  def OnChange(self, watch, path, mask):
    print path, 'changed' # or do something else!

if __name__ == '__main__':
  from twisted.internet import reactor
  fs = FileSystemWatcher('/home/ali/tmp')
  fs.Start()
  reactor.run()
~~~

Incredibly easy, and another example of how awesome Twisted is.
