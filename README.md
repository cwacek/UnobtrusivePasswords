Unobstrusive Passwords
======================

This is a Chrome extension that provides a way to use hashed
passwords as discussed [here][1]. 

Essentially, a master password combined with a key phrase
provides a difficult-to-guess generated  password for each site
that you wish to use, but it's easy to retrieve the password
given the master password and the key phrase. 

I provide 3 hashes for each keyword/password pair - you can
choose which one to use.

There are a bunch of these types of extensions on the Chrome App
Store, but they all do too much for my comfort. This type of
extension shouldn't have access to anything on my pages. I don't
find auto-filling to be particularly helpful.

Security
--------

Each provided password is the first 10 bytes of the Base64
encoded hash.

The extension is sandboxed, so it's only using local resources.
It doesn't require access to any of your pages. Passwords are
created by repeatedly applying a SHA256 HMAC from the
[CryptoJS][2] library.

It also uses jQuery, but only for display purposes. All library
files are included and not retrieved over the network


[1]: http://pragmattica.wordpress.com/2009/04/30/password-hashing-a-neat-idea-that-can-help-to-protect-your-online-accounts/
[2]: http://code.google.com/p/crypto-js/

