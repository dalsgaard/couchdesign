CouchDesign
===========

CouchDB design document uploader

Dependencies
------------

CouchDesign is dependent on
[SpiderMonkey](http://www.mozilla.org/js/spidermonkey/) and [Ruby
1.9](http://www.ruby-lang.org/en/)

Installetion
------------

> $ gem build couchdesign.gemspec

> $ sudo gem install couchdesign-x.x.x.gem

Usage
-----

> $ couchdesign &lt;file&gt; &lt;database&gt; \[&lt;host&gt;=localhost\] \[&lt;port&gt;=5984\]

To force a update in case of a conflict

> $ couchdesign -f &lt;file&gt; &lt;database&gt; \[&lt;host&gt;=localhost\] \[&lt;port&gt;=5984\]

To get a help text

> $ couchdesign -h

CouchDesign stores a revision file containing the new revision
number after an upload. The naming scheme for this file is as follows

> &lt;host&gt;\_\_&lt;port&gt;\_\_&lt;database&gt;\_\_&lt;file&gt;.rev

