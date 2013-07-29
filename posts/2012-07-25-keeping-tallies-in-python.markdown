---
title: Keeping tallies in Python
author: Ali
tags: python, collections
---

Python's collections module has some of the most consistently useful collection
data structures you will need for everyday programming. Here's one I didn't know
about, [collections.Counter](http://docs.python.org/2/library/collections.html#collections.Counter)
(Python 2.7 only!). It is designed to keep "tallies" or count instances of
something. The example will make it all clear:

~~~ {.python}
from collections import Counter
cars = Counter()
# I see one go past, it is red
cars['red'] += 1
# And a green one
cars['blue'] += 1
# etc
~~~

This is pretty much like a defaultdict with an integer value, but it is
convenient and neat, with a useful constructor.

There's more. "Are two strings anagrams?"

~~~ {.python}
are_anagrams = lambda s1, s2: Counter(s1) == Counter(s2)
~~~

Replied the smartass.




