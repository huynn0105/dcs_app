window.requestFileSystem  = window.requestFileSystem || window.webkitRequestFileSystem;

browser.runtime.sendNativeMessage("application.id", {message: "Hello from background page"}, function(response) {
    console.log("Received sendNativeMessage response:");
    console.log(response);
});


browser.runtime.sendNativeMessage("application.id", {message: "xin chao toi la nguyen nhat huy"});
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Received request: ", "nguyen nhat huy");
    if (request.type == "content") {
        browser.runtime.sendNativeMessage("application.id", {message: "Hello"}, function(response) {
            const obj = JSON.parse(response);
            console.log("nhan duoc hang: ", obj);
            if (obj.type == "native") {
                sendResponse(obj);
            }
        });
    }
    return true;
});



var sites_need_to_show = ["yahoo", "myspace", "linkedin", "alibaba", "jpmorgan", "pinterest", "apple", "sprint", "foursquare", "glenmedeconnect",
                          "united", "tdbank", "morganstanleyclientserv", "nba",  "spotify", "paypal", "prudential", "victoriassecret", "arena", "live",
                          "tumblr", "dropbox", "ebay", "instagram", "vudu", "airbnb", "vine", "nhl", "passwordbox", "bestbuy", "tripadvisor", "easyweb.td.com",
                          "hulu", "enterprise", "ihg", "peepers", "irg", "ancestry", "td.com", "godaddy", "pcoptimum.ca", "accounts.google.com", "ebgames.ca"];
var pdc_domain = be_environments[current_environment];
if(is_present(localStorage['count_number_sign_in_iframe_shown']) == false){
  localStorage['count_number_sign_in_iframe_shown'] = 0;
}
localStorage['token_used_expired'] = '';

function resetToolbar(){
  localStorage['pdc_hasSubmitInfo'] = 'false';
  localStorage['pdc_username'] = '';
  localStorage['pdc_url'] = '';
  localStorage['pdc_domain'] = '';
  localStorage['pdc_is_not_normal'] = 'false';
  localStorage['pdc_sign_in_type'] = '';
}

function clearTabIDWindowID(){
  localStorage['pdc_institution_name'] = '';
  localStorage['pdc_tabID'] = '';
  localStorage['pdc_windowID'] = '';
  localStorage['pdc_save_success'] = 'false';
  localStorage['pdc_save_fail'] = 'false';
  localStorage['existing_accounts'] = '';
  localStorage['pdc_is_not_normal'] = 'false';
  localStorage['pdc_sign_in_type'] = '';
}

function getCurrentTime()
{
  var d = new Date();
  offset = d.getTimezoneOffset()/60;
  var curr_offset = "" + offset;
  if(offset <= 0)
  {
    curr_offset = "+" + Math.abs(offset);
  }
  var dateTime = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds() + ":" + d.getMilliseconds() + " GMT" + curr_offset;
  return dateTime
}

chrome.runtime.onMessage.addListener(function(request, sender, callback)
{
  switch (request.directive) {
    case 'site-to-detect':
      console.log("");
      console.log(getCurrentTime());
      console.log("Site to detect: " + request.url);
      console.log("inner_body_tag");
      console.log(request.inner_body);
      break;
    case 'form-is-loaded':
      console.log("");
      console.log(getCurrentTime());
      console.log(request.login_form_message);
    case 'submit-button-is-clicked':
      console.log("");
      console.log(getCurrentTime());
      console.log(request.submit_button_message);
    case 'form_submit':
      if (request.form_html !== undefined)
      {
        console.log("");
        console.log(getCurrentTime());
        console.log(request.form_html);
      }
      break;
    case 'ajax-form-type':
      if (request.type !== '')
      {
        console.log("");
        console.log(getCurrentTime());
        console.log('Form type: ' + request.type);
      }
    case 'cancel-login':
      callback({});
      break;

    case 'reset_toolbar':
      resetToolbar();
      break;

    case 'checking_authorized':
      var is_authoried = localStorage['pdc_is_authoried'];
      var client_token = localStorage['pdc_client_token'];
      localStorage['pdc_sign_in_type'] = '';
      if (is_authoried === 'true'){
        console.log("");
        console.log(getCurrentTime());
        console.log("Send checking request: " + pdc_domain + "/api/v1/accounts/checking");
        console.log("Parameters {username: " + request.username + ", url: " + request.url + ", token: " + client_token + "}");
        var xhr = new XMLHttpRequest();
        xhr.open("POST", pdc_domain + "/api/v1/accounts/checking", true);
        xhr.onreadystatechange = function()
        {
          if (xhr.readyState == 4)
          {
            var obj = JSON.parse(xhr.responseText);
            if (xhr.status == 200)
            {
              if (obj['has_confirmation'] == true)
              {
                localStorage['pdc_hasSubmitInfo'] = 'true';
                localStorage['pdc_username'] = request.username;
                localStorage['pdc_institution_name'] = obj['institution_name'];
                localStorage['pdc_url'] = request.url;
                localStorage['existing_accounts'] = JSON.stringify(obj['existing_accounts']);
                var tab_id = parseInt(request.tab_id);
                var window_id = parseInt(request.window_id);
                var is_not_normal = request.is_not_normal;
                chrome.tabs.query({active: true, windowId: window_id}, function(tabs){
                  if (localStorage['pdc_tabID'] != undefined && localStorage['pdc_tabID'] != null && localStorage['pdc_tabID'] != ''){
                    var old_tab_id = parseInt(localStorage['pdc_tabID']);
                    if (localStorage['pdc_save_success'] === 'true'){
                      chrome.tabs.sendMessage(old_tab_id, {"directive": "hide_iframe_success"}, function(response) {});
                      localStorage['pdc_save_success'] = 'false';
                    }else if (localStorage['pdc_save_fail'] === 'true') {
                      chrome.tabs.sendMessage(old_tab_id, {"directive": "hide_iframe_fail"}, function(response) {});
                      localStorage['pdc_save_fail'] = 'false';
                    }
                    else{
                      chrome.tabs.sendMessage(old_tab_id, {"directive": "hide_iframe"}, function(response) {});
                    }
                  }
                  localStorage['pdc_tabID'] = tab_id;
                  localStorage['pdc_windowID'] = window_id;
                  if (request.is_not_normal === 'true'){
                    chrome.tabs.sendMessage(tab_id, {"directive": "show_iframe"}, function(response) {});
                  }else{
                    for(i = 0; i < sites_need_to_show.length; i ++)
                    {
                      if (request.url.indexOf(sites_need_to_show[i]) > -1){
                        chrome.tabs.sendMessage(tab_id, {"directive": "show_iframe"}, function(response) {});
                      }
                    }
                  }
                  if(is_present(request.is_from_sign_in_bar) && request.is_from_sign_in_bar === 'true'){
                    chrome.tabs.sendMessage(tab_id, {"directive": "show_iframe"}, function(response) {});
                  }
                });
              }else{
                localStorage['pdc_hasSubmitInfo'] = 'false';
              }
            }
            else if (xhr.status == 401 || (xhr.status == 404 && (obj['message'] === 'Invalid access token')) || (xhr.status == 400 && (obj['message'] === 'Missing Token parameter')))
            {
              localStorage['pdc_sign_in_type'] = 'token_expired';
              localStorage['token_used_expired'] = client_token;
              handleTokenExpired(parseInt(request.tab_id), parseInt(request.window_id), request);
            }else{
              localStorage['pdc_hasSubmitInfo'] = 'false';
            }
            console.log("");
            console.log(getCurrentTime());
            console.log("Response from " + pdc_domain + "/api/v1/accounts/checking");
            console.log("{");
            for (var key in obj) {
              if (obj.hasOwnProperty(key)) {
                console.log(key + ": " + obj[key]);
              }
            }
            console.log("}");
          }
        }
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.send(JSON.stringify({"username": request.username, "url": request.url, "token": client_token, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain}));
      }else{
        localStorage['pdc_hasSubmitInfo'] = 'false';
        localStorage['pdc_sign_in_type'] = 'never_sign_in';
        handleTokenExpired(parseInt(request.tab_id), parseInt(request.window_id), request);
      }
      break;
    case 'authorize_automatically':
      var is_authoried = localStorage['pdc_is_authoried'];
      var client_token = localStorage['pdc_client_token'];
      if (is_authoried === 'true'){
        var xhr = new XMLHttpRequest();
        xhr.open("POST", pdc_domain + "/api/v1/auth/authorize_automatically", true);
        xhr.onreadystatechange = function(){
          if (xhr.readyState == 4)
          {
            var obj = JSON.parse(xhr.responseText);
            if (xhr.status == 200){
              localStorage['pdc_session_name'] = obj['browser_name'];
              if (obj['notify_client_already_signed_in'] == true){
                chrome.tabs.query({active: true, currentWindow: true}, function(tabs){
                  localStorage['pp_is_signed_in'] = 'true';
                  localStorage['pp_is_signed_in_tab_id'] = tabs[0].id;
                  localStorage['pp_is_signed_in_message'] = localStorage['pdc_client_first_name'] + " is signed in to DCS Portfolio Plus";
                  chrome.tabs.sendMessage(tabs[0].id, {"directive": "show_automatically_sign_in", "pdc_client_first_name": localStorage['pdc_client_first_name'], "tab_id": tabs[0].id, "window_id": tabs[0].windowId}, function(response) {});
                });
              }
            }else{
              reauthorize_to_pp(request);
            }
          }
        }
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.send(JSON.stringify({"email": request.username, "password": request.password, "token": client_token, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain}));
      }else{
        reauthorize_to_pp(request);
      }
      break;
    case 'save_account':
      var client_token = localStorage['pdc_client_token'];
      var username = localStorage['pdc_username'];
      var url = localStorage['pdc_url'];
      var xhr = new XMLHttpRequest();
      var submit_type = request.submit_type;
      console.log("");
      console.log(getCurrentTime());
      console.log("Send saving request: " + pdc_domain + "/api/v1/accounts");
      console.log("Request parameters:");
      console.log("Parameters {username: " + username + ", url: " + url + ", token: " + client_token + ", submit_type: " + submit_type + "}");
      xhr.open("POST", pdc_domain + "/api/v1/accounts", true);
      xhr.onreadystatechange = function()
      {
        if (xhr.readyState == 4)
        {
          if (xhr.status == 200)
          {
            localStorage['pdc_save_success'] = 'true';
            var tab_id = JSON.parse(localStorage['pdc_tabID']);
            chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe_fail"}, function(response) {});
            chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe"}, function(response) {});
            chrome.windows.getAll({populate:true},function(windows){
              windows.forEach(function(window){
                window.tabs.forEach(function(tab){
                  chrome.tabs.sendMessage(tab.id, {"directive": "hide_iframe_fail"}, function(response) {});
                  chrome.tabs.sendMessage(tab.id, {"directive": "hide_iframe"}, function(response) {});
                });
              });
            });
            localStorage['pdc_save_fail'] = 'false';
            resetToolbar();
            if (submit_type === 'save')
            {
              chrome.tabs.sendMessage(tab_id, {"directive": "show_iframe_success"}, function(response) {});
            }
            var obj = JSON.parse(xhr.responseText);
            console.log("");
            console.log(getCurrentTime());
            console.log("Response from " + pdc_domain + "/api/v1/accounts");
            console.log("{");
            for (var key in obj) {
              if (obj.hasOwnProperty(key)) {
                console.log(key + ": " + obj[key]);
              }
            }
            console.log("}");
          }
          else{
            console.log("");
            console.log(getCurrentTime());
            console.log("Response from " + pdc_domain + "/api/v1/accounts");
            console.log("{");
            var obj2 = JSON.parse(xhr.responseText);
            for (var key in obj) {
              if (obj2.hasOwnProperty(key)) {
                console.log(key + ": " + obj2[key]);
              }
            }
            console.log("}");
            var tab_id = JSON.parse(localStorage['pdc_tabID']);
            if (request.is_from_toolbar_fail !== 'true'){
              chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe"}, function(response) {});
              chrome.tabs.sendMessage(tab_id, {"directive": "show_iframe_fail"}, function(response) {});
            }
            localStorage['pdc_save_fail'] = 'true';
            localStorage['pdc_save_success'] = 'false';
          }
        }
      }
      xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xhr.send(JSON.stringify({"username": username, "url": url, "token": client_token, "submit_type": submit_type, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain}));
      break;
    case 'hide_iframe':
      var tab_id = JSON.parse(localStorage['pdc_tabID']);
      chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe"}, function(response) {});
      resetToolbar();
      clearTabIDWindowID();
      break;
    case 'hide_iframe_success':
      var tab_id = JSON.parse(localStorage['pdc_tabID']);
      chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe_success"}, function(response) {});
      clearTabIDWindowID();
      break;
    case 'hide_iframe_fail':
      var tab_id = JSON.parse(localStorage['pdc_tabID']);
      chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe_fail"}, function(response) {});
      resetToolbar();
      clearTabIDWindowID();
      break;
    case 'get_institution':
      callback({'pdc_institution_name': localStorage['pdc_institution_name'], 'pdc_client_first_name': localStorage['pdc_client_first_name'], 'existing_accounts': JSON.parse(localStorage['existing_accounts'])});
      break;
    case 'getUrl':
      chrome.windows.getCurrent(function(window){
        if (window.type === 'normal') {
          chrome.tabs.query({active: true, currentWindow: true}, function(tabs){
            var url = request.url;
            while (url.indexOf('|') > -1){
              url = url.replace('|', '');
            }
            chrome.tabs.sendMessage(tabs[0].id, {"directive": "sendInfoToBackground", "username": request.username, "url": url, "form_html": request.form_html, "tab_id": tabs[0].id, "window_id": tabs[0].windowId}, function(response) {});
          });
        }else{
          chrome.tabs.query({active: true, windowType: 'normal', currentWindow: false}, function(tabs){
            var url = tabs[0].url;
            while (url.indexOf('|') > -1){
              url = url.replace('|', '');
            }
            chrome.tabs.sendMessage(tabs[0].id, {"directive": "sendInfoToBackground", "username": request.username, "url": url, "form_html": request.form_html, "tab_id": tabs[0].id, "window_id": tabs[0].windowId, "is_not_normal": "true"}, function(response) {});
          });
        }
      });
      break;
    case 'reload-contentscript':
      chrome.tabs.query({active: true, currentWindow: true}, function(tabs){
        chrome.tabs.executeScript(tabs[0].id, { file: "form_submits.js" }, function() {});
      });
      break;
    case 'closeAutomaticallySignIn':
      var tab_id = JSON.parse(localStorage['pp_is_signed_in_tab_id']);
      chrome.tabs.sendMessage(tab_id, {"directive": "hideAutomaticallySignIn"}, function(response) {});
      resetPPIsSignedIn();
      break;
    case 'closePPInstructions':
      chrome.tabs.query({active: true, currentWindow: true}, function(tabs){
        for (var i = 0; i < tabs.length; ++i)
        {
          if (tabs[i].url.indexOf('pp_instructions') > -1)
          {
            chrome.tabs.remove(tabs[i].id, function() { });
          }
        }
      });
      break;
    case 'getPPSignedInMessage':
      callback({'pp_is_signed_in_message': localStorage['pp_is_signed_in_message']});
      break;
    case 'hide_sign_in_iframe':
      var tab_id = JSON.parse(localStorage['pdc_tabID']);
      chrome.tabs.sendMessage(tab_id, {"directive": "hide_sign_in_iframe"}, function(response) {});
      resetToolbar();
      clearTabIDWindowID();
      break;
    case 'submit_sign_in_form_from_bar':
      email = request.email;
      password = request.password;
      var xhr = new XMLHttpRequest();
      xhr.open("POST", pdc_domain + "/api/v1/auth/authorize", true);
      xhr.onreadystatechange = function() {
        if (xhr.readyState == 4) {
          var obj = JSON.parse(xhr.responseText);
          if (xhr.status == 200)
          {
            localStorage['pdc_is_authoried'] = 'true';
            localStorage['pdc_client_token'] = obj['token'];
            localStorage['pdc_client_first_name'] = obj['first_name'];
            localStorage['pdc_session_name'] = obj['default_session_name'];
            var username = localStorage['pdc_username'];
            var url = localStorage['pdc_url'];
            var tab_id = parseInt(localStorage['pdc_tabID']);
            var window_id = localStorage['pdc_windowID'];
            var is_not_normal = localStorage['pdc_is_not_normal'];
            chrome.tabs.sendMessage(parseInt(localStorage['pdc_tabID']), {"directive": "show_asking_browser_name_bar", browsers: obj['browsers']}, function(response) {});
          }else {
            localStorage['pdc_is_authoried'] = 'false';
            localStorage['pdc_client_token'] = '';
            chrome.tabs.sendMessage(parseInt(localStorage['pdc_tabID']), {"directive": "show_error_when_sign_in_from_bar", request_status: xhr.status, response_domain: obj['domain'], response_message: obj['message']}, function(response) {});
          }
        }
      }
      xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xhr.send(JSON.stringify({"email": email, "password": password, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain}));
      break;
    case 'deauthorize_all_browsers_from_bar':
      var is_authoried = localStorage['pdc_is_authoried'];
      var client_token = localStorage['pdc_client_token'];
      if((is_authoried == 'true') && is_present(client_token)){
        var xhr = new XMLHttpRequest();
        xhr.open("POST", pdc_domain + "/api/v1/auth/deauthorize", true);
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4) {
            var obj = JSON.parse(xhr.responseText);
            if (xhr.status == 200){
              var tab_id = parseInt(localStorage['pdc_tabID']);
              chrome.tabs.sendMessage(tab_id, {"directive": "hide_browser_list"}, function(response) {});
            }
          }
        }
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.send(JSON.stringify({"token": client_token, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain}));
      }
      break;
    case 'save_browser_name_from_bar':
      var is_authoried = localStorage['pdc_is_authoried'];
      var client_token = localStorage['pdc_client_token'];
      var browser_name_val = request.browser_name;
      if((is_authoried == 'true') && is_present(browser_name_val) && is_present(client_token)){
        var xhr = new XMLHttpRequest();
        xhr.open("POST", pdc_domain + "/api/v1/auth/save_browser_name", true);
        xhr.onreadystatechange = function(){
          if(xhr.readyState == 4){
            var obj = JSON.parse(xhr.responseText);
            $('#enter-browser-name-form-error').html('').addClass('hide');
            if (xhr.status == 200){
              localStorage['pdc_session_name'] = obj['browser_name'];
              var username = localStorage['pdc_username'];
              var url = localStorage['pdc_url'];
              var tab_id = parseInt(localStorage['pdc_tabID']);
              var window_id = localStorage['pdc_windowID'];
              var is_not_normal = localStorage['pdc_is_not_normal'];
              chrome.tabs.sendMessage(tab_id, {"directive": "hide_sign_in_iframe"}, function(response) {});
              chrome.tabs.sendMessage(tab_id, {'directive': 'ask_to_save_new_account', 'username': username, 'url': url, 'tab_id': tab_id, 'window_id': window_id, 'is_not_normal': is_not_normal}, function(response){});
            }else{
              if(is_present(obj['message'])){
                chrome.tabs.sendMessage(parseInt(localStorage['pdc_tabID']), {"directive": "show_error_when_save_browser_name_from_bar", request_status: xhr.status, response_domain: obj['domain'], response_message: obj['message']}, function(response) {});
              }
            }
          }
        }
        xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xhr.send(JSON.stringify({'browser_name': browser_name_val, "token": client_token, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain}));
      }
      break;
  }
});

// the sites that after login successfully, the TabId is changed
var sites_tabID_changed = ["dropbox", "easyweb.td.com"];

chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab){
  if(changeInfo && changeInfo.status === "complete")
  {
    if (typeof localStorage['pdc_tabID'] !== 'undefined' && localStorage['pdc_tabID'] != null && localStorage['pdc_tabID'] !== '')
    {
      if (typeof localStorage['pdc_windowID'] != 'undefined' && localStorage['pdc_windowID'] != null && localStorage['pdc_windowID'] !== ''){
        var tab_id = parseInt(localStorage['pdc_tabID']);
        var window_id = parseInt(localStorage['pdc_windowID']);
        chrome.tabs.query({active: true, windowId: window_id}, function(tabs){
          if (localStorage['pdc_is_authoried'] === 'true') {
            if (localStorage['pdc_hasSubmitInfo'] === 'true')
            {
              if (localStorage['pdc_save_fail'] === 'true') {
                chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe_fail"}, function(response) {});
                chrome.tabs.sendMessage(tab_id, {"directive": "show_iframe_fail"}, function(response) {});
              }else{
                chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe"}, function(response) {});
                chrome.tabs.sendMessage(tab_id, {"directive": "show_iframe"}, function(response) {});
              }
            }else{
              if (localStorage['pdc_save_success'] === 'true'){
                clearTabIDWindowID();
                chrome.tabs.sendMessage(tab_id, {"directive": "hide_iframe_success"}, function(response) {});
              }
            }
          }else{
            if(localStorage['pdc_client_token'] === ''){
              if(parseInt(localStorage['count_number_sign_in_iframe_shown']) < 3){
                chrome.tabs.sendMessage(tab_id, {"directive": "show_sign_in_iframe"}, function(response) {});
                increase_number_sign_in_iframe_shown();
              }
            }else{
              resetToolbar();
              clearTabIDWindowID();
            }
          }
        });
      }
    }
    if (typeof localStorage['pp_is_signed_in'] !== 'undefined' && localStorage['pp_is_signed_in'] != null && localStorage['pp_is_signed_in'] !== ''){
      var tab_id = parseInt(localStorage['pp_is_signed_in_tab_id']);
      chrome.tabs.sendMessage(tab_id, {"directive": "show_automatically_sign_in", "pdc_client_first_name": localStorage['pdc_client_first_name']}, function(response) {});
      localStorage['pp_is_signed_in'] = '';
    }
  }
});

chrome.tabs.onRemoved.addListener(function(tabId, objectInfo){
  if (typeof localStorage['pdc_tabID'] !== 'undefined' && localStorage['pdc_tabID'] != null && localStorage['pdc_tabID'] !== '' && tabId.toString() === localStorage['pdc_tabID'])
  {
    if (typeof localStorage['pdc_windowID'] != 'undefined' && localStorage['pdc_windowID'] != null && localStorage['pdc_windowID'] !== '' && objectInfo.windowId.toString() === localStorage['pdc_windowID']){
      if (localStorage['pdc_hasSubmitInfo'] === 'true')
      {
        resetToolbar();
        clearTabIDWindowID();
        resetPPIsSignedIn();
      }
    }
  }
});

chrome.windows.onRemoved.addListener(function(windowId){
  if (typeof localStorage['pdc_windowID'] != 'undefined' && localStorage['pdc_windowID'] != null && localStorage['pdc_windowID'] !== '' && windowId.toString() === localStorage['pdc_windowID']){
    if (localStorage['pdc_hasSubmitInfo'] === 'true')
    {
      resetToolbar();
      clearTabIDWindowID();
      resetPPIsSignedIn();
    }
  }
});

chrome.runtime.onInstalled.addListener(function(details){
  if(details.reason == "install" || details.reason == "update"){
    chrome.windows.getAll({populate:true},function(windows){
      windows.forEach(function(window){
        window.tabs.forEach(function(tab){
          if((tab.url.indexOf("directivecommunications.com") > -1) || (tab.url.indexOf("localhost") > -1) || (tab.url.indexOf("protectmyplans.com") > -1)){
            // chrome.tabs.reload(tab.id);
            chrome.tabs.executeScript(tab.id, { file: "jquery.min.js" }, function() {
              chrome.tabs.executeScript(tab.id, { file: "remove_extension.js" });
            });
          }
        });
      });
    });
  }
  if(details.reason == "install"){
    chrome.tabs.create({url: pdc_domain + '/clients/pp_instructions'});
  }
});

function resetPPIsSignedIn(){
  localStorage['pp_is_signed_in'] = '';
  localStorage['pp_is_signed_in_tab_id'] = '';
  localStorage['pp_is_signed_in_message'] = '';
}

function handleTokenExpired(tab_id, window_id, request){
  localStorage['pdc_username'] = request.username;
  localStorage['pdc_url'] = request.url;
  localStorage['pdc_is_not_normal'] = request.is_not_normal;

  // Clear 'session' on PP
  localStorage['pdc_is_authoried'] = 'false';
  localStorage['pdc_client_token'] = '';
  localStorage['pdc_tabID'] = tab_id;
  localStorage['pdc_windowID'] = window_id;

  // Display sign-in form
  $('#login-form').removeClass('hide');
  $('#login-form-error').addClass('hide');
  $('#login-form-error-2').addClass('hide');
  $('#is_authoried').addClass('hide');
  $('#wad-password').val('');
  $('#user-account-info').addClass('hide');
  $('#login-successful').addClass('hide');
  $('#div-quick-add').addClass('hide');
  $('#quick-add-form').addClass('hide');

  // Hide Quick Add container
  $("#quick-add-form").addClass('hide');
  $("#div-account-number").addClass('hide');
  $("#div-account-username").addClass('hide');
  $("#div-account-email").addClass('hide');
  $("#div-add-account-error").addClass('hide');
  $("#account-name-error").addClass('hide');
  $("#account-url-error").addClass('hide');
  $("#account-email-error").addClass('hide');
  $("#quick-add-successfully").addClass('hide');
  $("#div-quick-add-account").addClass('hide');

  if (request.is_not_normal === 'true'){
    if(parseInt(localStorage['count_number_sign_in_iframe_shown']) < 3){
      chrome.tabs.sendMessage(tab_id, {"directive": "show_sign_in_iframe"}, function(response) {});
      increase_number_sign_in_iframe_shown();
    }
  }else{
    for(i = 0; i < sites_need_to_show.length; i ++)
    {
      if (request.url.indexOf(sites_need_to_show[i]) > -1){
        if(parseInt(localStorage['count_number_sign_in_iframe_shown']) < 3){
          chrome.tabs.sendMessage(tab_id, {"directive": "show_sign_in_iframe"}, function(response) {});
          increase_number_sign_in_iframe_shown();
        }
      }
    }
  }
}

function is_present(val){
  return ($.inArray(val, ['', null, undefined, NaN]) == -1)
}

function increase_number_sign_in_iframe_shown(){
  if(is_present(localStorage['count_number_sign_in_iframe_shown']) == false){
    localStorage['count_number_sign_in_iframe_shown'] = 0;
  }else{
    localStorage['count_number_sign_in_iframe_shown'] = parseInt(localStorage['count_number_sign_in_iframe_shown']) + 1;
  }
  if(parseInt(localStorage['count_number_sign_in_iframe_shown']) == 3){
    var client_token = localStorage['token_used_expired'];
    if(is_present(client_token)){
      var xhr = new XMLHttpRequest();
      xhr.open("POST", pdc_domain + "/api/v1/auth/inform_token_epxired", true);
      xhr.onreadystatechange = function() {
        if (xhr.readyState == 4) {
          var obj = JSON.parse(xhr.responseText);
        }
      }
      xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xhr.send(JSON.stringify({"current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain, 'client_token': client_token}));
    }
  }
}

function reauthorize_to_pp(request){
  var xhr = new XMLHttpRequest();
  xhr.open("POST", pdc_domain + "/api/v1/auth/authorize", true);
  xhr.onreadystatechange = function() {
    if (xhr.readyState == 4) {
      var obj = JSON.parse(xhr.responseText);
      if (xhr.status == 200)
      {
        localStorage['pdc_is_authoried'] = 'true';
        localStorage['pdc_client_token'] = obj['token'];
        localStorage['pdc_client_first_name'] = obj['first_name'];
        localStorage['pdc_session_name'] = obj['default_session_name'];
        chrome.tabs.query({active: true, currentWindow: true}, function(tabs){
          localStorage['pp_is_signed_in'] = 'true';
          localStorage['pp_is_signed_in_tab_id'] = tabs[0].id;
          localStorage['pp_is_signed_in_message'] = "DCS Portfolio Plus has signed in as " + localStorage['pdc_client_first_name'];
          chrome.tabs.sendMessage(tabs[0].id, {"directive": "show_automatically_sign_in", "pdc_client_first_name": localStorage['pdc_client_first_name'], "tab_id": tabs[0].id, "window_id": tabs[0].windowId}, function(response) {});
        });
      }else {
      }
    }
  }
  xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
  xhr.send(JSON.stringify({"email": request.username, "password": request.password, "is_automatic": true, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain}));
}
