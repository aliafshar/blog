---
title: Calling the Google Drive API and other Google APIs asynchronously with Twisted
author: Ali
---

You may know that the [Google API Python
Client](https://code.google.com/p/google-api-python-client/) is built on
[httplib2](https://code.google.com/p/httplib2/). This is a reasonable general
choice, but the tight coupling is unhelpful in situations where a different HTTP
library, or an entirely different approach to network programming should be
used. An example of this is [Twisted](http://twistedmatrix.com/trac/).

Aside: I won't be going on about how awesome Twisted is, but let's just take it for granted that it is so awesome that I could not write this application without it.

Httplib2 is blocking, and that makes it incompatible with being run inside the Twisted reactor. Fortunately we are only the latest person to have this problem, and a solution exists:

[twisted.internet.threads.deferToThread](http://twistedmatrix.com/documents/current/api/twisted.internet.threads.deferToThread.html)

~~~ {.python}
api_call = drive.files().list()

def on_list(resp):
  for item in resp['items']:
    print item['title']

d = deferToThread(api_call.execute)
d.addCallback(on_list)
~~~

A blocking call will be made in a thread and will callback on the returned
deferred when it is done. I appreciate that no one[^1] is 100% happy with this
solution.

> "Argh, threads!", "Argh, async!"

But it is a testament to the Greatness of Twisted that it has this sort of
facility to play well with other, less flexible, systems.

[^1]: Did I mention? I am 100% happy. 
