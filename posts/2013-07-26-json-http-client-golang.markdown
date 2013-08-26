---
title: Using Go as an HTTP+JSON client
author: Ali
tags: go, http-client, json
---

Making HTTP calls from [Go](http://golang.org) is really easy. I rather like the
[HTTP client](http://golang.org/pkg/net/http/) because it makes easy things
easy, and is flexible enough to do more complicated things without pain.
Straight from the documentation, making an HTTP request is as simple as knowing
the verb and the URL that you want (minus some boilerplate).

~~~ {.go}
resp, err := http.Get(url)
~~~

Adding a header to our request is a bit more complex, but again well documented.
We will be adding the `Accept` header with a value of `application/json`. We
should create the client and request manually, and add the header.

~~~ {.go}
client := &http.Client{}
req, err := http.NewRequest("GET", url, nil)
if err != nil {
  log.Fatalln(err)
}
req.Header.Add("Accept", "application/json")
~~~

We can then make the request. Defer is an unbelievably cool and pragmatic Go
feature which executes a list of things [after a function
returns](http://blog.golang.org/defer-panic-and-recover).

~~~ {.go}
resp, err := client.Do(req)
if err != nil {
  log.Fatalln(err)
}
defer resp.Body.Close()
~~~

We actually want data from a JSON service, so we will need to decode the JSON.
Forunately the `resp.Body` value implements
[`io.Reader`](http://golang.org/pkg/io/#Reader) so it can be simply read.
`io.Reader` is the common language of reading any stream, and of course the
[JSON](http://golang.org/pkg/encoding/json/) package supports it.

All we need to do is to know what we are decoding and create a type to receive
that data, which is explained well in [this article about JSON with
Go](http://blog.golang.org/json-and-go). In our example case, we are using
data from [FOAAS](https://foaas.herokuapp.com/), which looks like this:

~~~ {.json}
{
  "message":"A message",
  "subtitle":"A subtitle"
}
~~~

This easily translates into a Go struct type like:

~~~ {.go}
type Fo struct {
  Message string
  Subtitle string
}
~~~

Once we have this, we can easily decode our response straight into a pointer to
our struct. We create the decoder from the reader, an instance of the struct,
then call `Decode`.

~~~ {.go}
decoder := json.NewDecoder(resp.Body)
v := Fo{}
err = decoder.Decode(&v)
if err != nil {
  log.Fatalln(err)
}
~~~

Finally we print out our struct. This uses the default `String()` but you can
easily attach your own for custom printing.

~~~
2013/08/26 13:37:56 {Ali, Thou clay-brained guts, thou knotty-pated fool, thou
whoreson obscene greasy tallow-catch! - Hilda}
~~~

That's it. It might seem a bit verbose compared to other languages, but we have
done some interesting things that might have been a bit of a pain elsewhere:

1. Added a header to an HTTP request
2. Decoded JSON into an instance
3. Checked every error and responded appropriately

I think for doing all that, it is pretty concise. Complete code follows:

~~~ {.go}
package main

import (
  "encoding/json"
  "net/http"
  "log"
)

const url = "https://foaas.herokuapp.com/shakespeare/Ali/Hilda"

type Fo struct {
  Message  string
  Subtitle string
}

func main() {
  client := &http.Client{}
  req, err := http.NewRequest( "GET", url , nil)
  if err != nil {
    log.Fatalln(err)
  }
  req.Header.Add("Accept", "application/json")
  resp, err := client.Do(req)
  if err != nil {
    log.Fatalln(err)
  }
  defer resp.Body.Close()
  decoder := json.NewDecoder(resp.Body)
  v := Fo{}
  err = decoder.Decode(&v)
  if err != nil {
    log.Fatalln(err)
  }
  log.Println(v)
}
~~~
