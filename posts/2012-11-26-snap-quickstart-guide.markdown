---
title: Building a Haskell web app with Snap
author: Ali
---

I'm a Haskell newbie, and it's fun. I thought I'd document my adventures.
Starting with my attempt to build a web app. I could have spent months picking a
web framework. There are decent comparisons on the web. I picked
[Snap](http://snapframework.com), because
of the name (and perhaps some advice from a geeky friend of mine). I've written
web frameworks (in Python) and the intro to Snap caught my eye. All pretty
arbitrary reasons, so let's get started.

First there is a quickstart guide. Great, who doesn't love quickstart guides? It tells me how to install the framework, though that redirects me to another page, but I don't mind. I would have to have Cabal installed, otherwise it wouldn't work. Instead of just plain:

    cabal install snap

I do:

    cabal install --user --prefix=$HOME snap

Which seems the most convenient way to put things in my ~ tree rather than anywhere on the system. Great it works first time with no dependency issues, conflicts, or compile errors. That's pretty rare, so great start!

I start to follow the quickstart guide. First create a directory, then call:

    snap init barebones

This is great too, so we have a utility script to perform basic operations (as
any decent web framework should), and by the look of "barebones" it seems that
there are multiple possible templates to start from. Another great feature. The
guide suggests running

    snap init -h

To see the list of templates, and here they are:


    snap init [type]

        [type] can be one of:
        default   - A default project using snaplets and heist
        barebones - A barebones project with minimal dependencies
        tutorial  - The literate Haskell tutorial project

So three starter templates, one of which is a tutorial. So, two starter
templates: "barebones" and "default". I guess we will use default in the future
when writing a real app, with Snaplets. I won't have much cause to write my own
templates, I hope, so moving on.

The guide doesn't explain much what it created, but my tree looks like this now:

    ./log
    ./log/access.log
    ./snaptest.cabal
    ./src
    ./src/Main.hs
    ./.ghci

Pretty much nothing there except Main.hs, which looks like this:

~~~ {.haskell}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server

main :: IO ()
main = quickHttpServe site

site :: Snap ()
site =
    ifTop (writeBS "hello world") <|>
    route [ ("foo", writeBS "bar")
          , ("echo/:echoparam", echoHandler)
          ] <|>
    dir "static" (serveDirectory ".")

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param
~~~
It reads nicely, don't you think?

* Some imports
* A main function that serves the site
* A site function that returns some Snap, Snap looking like a monad. This is the
  part that I don't exactly get: <|> anyone?. We are obviously defining routes,
  and I am guessing there are 3 ways of hitting this site (This is possibly a
  bit too much information for a quickstart, I might be happier with just the
  echo handler, but maybe that isn't possible on its own. Doesn't matter
  though):
  * `/` -- (ifTop, I'm guessing for the root) where we just return "hello world"
  * `/foo` -- which just returns "bar"
  * `/echo/<something>` -- which echoes the something back at us
* The echo handler itself, which gets the parameter defined in the route and
  returns it. Not exactly sure what the maybe line is doing here. I guess it is
  a failure condition, though I am more used to frameworks where a missing
  echoparam would not match the route and just 404.

Because the snap utility created a cabal file for us (how convenient), I can just install the app with:

    cabal install --user --prefix=$HOME

That's right, my app is an executable, now installed, which I can just run.
That's pretty awesome, we don't have stuff like that in Python frameworks. I had
called my initial directory snaptest and that is how the executable comes out.
Let's run it:

    $ snaptest -p 8000
    Listening on http://0.0.0.0:8000/

And here is what we get:

    http://localhost:8000/
    hello world

    http://localhost:8000/foo
    bar

    http://localhost:8000/echo
    No handler accepted echo

    http://localhost:8000/echo/banana
    banana

Great, as we mostly imagined, except I can't make the maybe condition in the
echo handler happen, but I don't care much either. After maybe 256 seconds of
actual effort and 16 minutes after deciding to write a Haskell web app, I have
one.

This is the best quick start experience I have had for any web application
framework in any language, so things bode well for the future.
