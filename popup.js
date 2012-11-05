// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


function doHash() {
  var siteval=$("#site").val()
  var mpass = $("#master").val()
  var hash1 = CryptoJS.HmacSHA256(siteval, mpass)
  var hashresult = hash1

  for (var i = 0; i < 3; i++) {
    hashresult = CryptoJS.HmacSHA256(hashresult, mpass)
    hashstr = CryptoJS.enc.Base64.stringify(hashresult)
    $('#result').append('<div class="result_entry"><label>Hash '+ i +':</label><span class="code">' + hashstr.substring(0,10) + '</span></div>')
  }
}

