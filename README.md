Unobstrusive Passwords
======================

This is a Chrome extension that provides a way to use hashed
passwords as discussed [here][1]. 

Essentially, a master password combined with a key phrase
provides a difficult-to-guess generated  password for each site
that you wish to use, but it's easy to retrieve the password
given the master password and the key phrase. 

Site keys that you use will automatically be remembered (to make
it a little easier to come up with the right one). You can remove
them from the history in the settings menu.

I provide 3 hashes for each keyword/password pair - you can
choose which one to use.

There are a bunch of these types of extensions on the Chrome App
Store, but they all do too much for my comfort. I refuse to
install an extension with permissions of '*read anything on all
pages; modify pages*'. This type of extension shouldn't have
access to anything on pages that I'm looking at .

Security
--------

Each provided password a substring of the first bytes of the
Base64 encoded hash. You can specify how long to make the
passwords in the settings menu. Passwords are created by
repeatedly applying a SHA256 HMAC from the [CryptoJS][2] library.

This extension does not require access to any of your pages. It
does make use of the Chrome local storage engine, but only two
types of information are stored: previously used site keys and
configuration settings.

It also uses Angular and jQuery, but only for display purposes.
All library files are included and not retrieved over the network

Where can I get it?
-------------------

You can either clone this repo, and install it manually, or you
can grab it from the [Chrome Web Store][3] (for free).


[1]: http://pragmattica.wordpress.com/2009/04/30/password-hashing-a-neat-idea-that-can-help-to-protect-your-online-accounts/
[2]: http://code.google.com/p/crypto-js/
[3]: https://chrome.google.com/webstore/detail/unobtrusivepasswords/oloklipnlbjjjbpggeeijidknkmnjhje


