chrome.runtime.onMessage.addListener(function(request, sender, callback){
  switch (request.directive) {
    case 'show_iframe':
      if (window == window.top) {
        var url = chrome.runtime.getURL("toolbar.html");
        var iframe = "<iframe src='" + url + "' class='toolbar-style' scrolling='no' style='width: 100%; border:none; position: fixed; z-index: 9999999999; top:0px; left: 0px;'></iframe>";
        if($(".toolbar-style").length < 1)
        {
          if (window.location.href.indexOf("webbanking") > -1){
            $('html').append(iframe);
          }else{
            if($('body')){
              $('body').append(iframe);
            }
            else{
              $('html').append(iframe);
            }
          }
        }
      }
      break;
    case 'show_iframe_success':
      if (window == window.top) {
        var url = chrome.runtime.getURL("toolbar-success.html");
        var iframe = "<iframe src='" + url + "' class='toolbar-success-style' scrolling='no' style='width: 100%; border:none; position: fixed; z-index: 9999999999; top:0px; left: 0px;'></iframe>";
        if ($('.toolbar-success-style').length < 1)
        {
          if (window.location.href.indexOf("webbanking") > -1){
            $('html').append(iframe);
          }else{
            if($('body')){
              $('body').append(iframe);
            }
            else{
              $('html').append(iframe);
            }
          }
        }
      }
      break;
    case 'show_iframe_fail':
      if (window == window.top) {
        var url = chrome.runtime.getURL("toolbar-fail.html");
        var iframe = "<iframe src='" + url + "' class='toolbar-fail-style' scrolling='no' style='width: 100%; border:none; position: fixed; z-index: 9999999999; top:0px; left: 0px;'></iframe>";
        if ($('.toolbar-fail-style').length < 1){
          if (window.location.href.indexOf("webbanking") > -1){
            $('html').append(iframe);
          }else{
            if($('body')){
              $('body').append(iframe);
            }
            else{
              $('html').append(iframe);
            }
          }
        }
      }
      break;
    case 'hide_iframe':
      $('.toolbar-style').remove();
      break;
    case 'hide_iframe_success':
      $('.toolbar-success-style').remove();
      break;
    case 'hide_iframe_fail':
      $('.toolbar-fail-style').remove();
      break;
    case 'show_automatically_sign_in':
      if (window == window.top){
        var url = chrome.runtime.getURL("automatically_sign_in.html");
        var iframe = "<iframe src='" + url + "' class='automatically-sign-in' scrolling='no' style='width: 100%; border:none; position: fixed; z-index: 9999999999; top:0px; left: 0px;'></iframe>";
        if($(".automatically-sign-in").length < 1)
        {
          if($('body')){
            $('body').append(iframe);
          }
          else{
            $('html').append(iframe);
          }
        }
      }
      break;
    case 'hideAutomaticallySignIn':
      $('.automatically-sign-in').remove();
      break;
    case 'show_sign_in_iframe':
      if (window == window.top) {
        var url = chrome.runtime.getURL("toolbar_sign_in_form.html");
        var iframe = "<iframe src='" + url + "' class='token-expired-toolbar' scrolling='no' style='width: 100%; border:none; position: fixed; z-index: 9999999999; top:0px; left: 0px; height: -webkit-fill-available;'></iframe>";
        if ($('.token-expired-toolbar').length < 1){
          if (window.location.href.indexOf("webbanking") > -1){
            $('html').append(iframe);
          }else{
            if($('body')){
              $('body').append(iframe);
            }
            else{
              $('html').append(iframe);
            }
          }
        }
      }
      break;
    case 'hide_sign_in_iframe':
      if (window == window.top){
        $('.token-expired-toolbar').remove();
      }
      break;
    case 'ask_to_save_new_account':
      if (window == window.top){
        var username = request.username;
        var url = request.url;
        var tab_id = request.tab_id;
        var is_not_normal = request.is_not_normal;
        var window_id = request.window_id;
        if (username != undefined && username != null && username != '' && url != undefined && url != null && url != ''){
          chrome.runtime.sendMessage({"directive": "checking_authorized", "username": username, "url": url, "tab_id": tab_id, "window_id": window_id, "is_not_normal": is_not_normal, "is_from_sign_in_bar": "true"});
        }
      }
      break;
  }
});