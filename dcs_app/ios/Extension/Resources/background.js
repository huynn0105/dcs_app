import * as config from "./config.js";

try {
  var sites_need_to_show = ["yahoo", "myspace", "linkedin", "alibaba", "jpmorgan", "pinterest", "apple", "sprint", "foursquare", "glenmedeconnect",
    "united", "tdbank", "morganstanleyclientserv", "nba", "spotify", "paypal", "prudential", "victoriassecret", "arena", "live",
    "tumblr", "dropbox", "ebay", "instagram", "vudu", "airbnb", "vine", "nhl", "passwordbox", "bestbuy", "tripadvisor", "easyweb.td.com",
    "hulu", "enterprise", "ihg", "peepers", "irg", "ancestry", "td.com", "godaddy", "pcoptimum.ca", "accounts.google.com", "ebgames.ca"];
  var pdc_domain = config.be_environments[config.current_environment];

  const getCurrentTab = async () => {
    const [tab] = await chrome.tabs.query({ active: true, lastFocusedWindow: true });
    return tab || undefined;
  };

  const setLocalStorage = (obj) => {
    return new Promise((resolve) => {
      chrome.storage.local.set(obj, () => {
        resolve();
      });
    });
  };

  setLocalStorage({ 'token_used_expired': '' });

  const resetToolbar = () => {
    setLocalStorage({ 'pdc_hasSubmitInfo': 'false' });
    setLocalStorage({ 'pdc_username': '' });
    setLocalStorage({ 'pdc_url': '' });
    setLocalStorage({ 'pdc_domain': '' });
    setLocalStorage({ 'pdc_is_not_normal': 'false' });
    setLocalStorage({ 'pdc_sign_in_type': '' });
  }

  const clearTabIDWindowID = () => {
    setLocalStorage({ 'pdc_institution_name': '' });
    setLocalStorage({ 'pdc_tabID': '' });
    setLocalStorage({ 'pdc_windowID': '' });
    setLocalStorage({ 'pdc_save_success': 'false' });
    setLocalStorage({ 'pdc_save_fail': 'false' });
    setLocalStorage({ 'existing_accounts': '{}' });
    setLocalStorage({ 'pdc_is_not_normal': 'false' });
    setLocalStorage({ 'pdc_sign_in_type': '' });
  }


  chrome.storage.local.get(['count_number_sign_in_iframe_shown'], (localStorage) => {
    if (is_present(localStorage['count_number_sign_in_iframe_shown'] == false)) {
      setLocalStorage({ 'count_number_sign_in_iframe_shown': 0 });
    }
  })

  const getCurrentTime = () => {
    let d = new Date();
    let offset = d.getTimezoneOffset() / 60;
    let curr_offset = "" + offset;
    if (offset <= 0) {
      curr_offset = "+" + Math.abs(offset);
    }
    let dateTime = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds() + ":" + d.getMilliseconds() + " GMT" + curr_offset;
    return dateTime;
  }

  chrome.runtime.onMessage.addListener((request, sender, callback) => {
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
        break;
      case 'submit-button-is-clicked':
        console.log("");
        console.log(getCurrentTime());
        console.log(request.submit_button_message);
        break;
      case 'form_submit':
        if (request.form_html !== undefined) {
          console.log("");
          console.log(getCurrentTime());
          console.log(request.form_html);
        }
        break;
      case 'ajax-form-type':
        if (request.type !== '') {
          console.log("");
          console.log(getCurrentTime());
          console.log('Form type: ' + request.type);
        }
      case 'cancel-login':
        break;

      case 'reset_toolbar':
        resetToolbar();
        break;

      case 'checking_authorized':
        chrome.storage.local.get(['pdc_is_authoried', 'pdc_save_success', 'pdc_client_token', 'pdc_tabID', 'pdc_save_fail'], (localStorage) => {
          var is_authoried = localStorage['pdc_is_authoried'];
          var client_token = localStorage['pdc_client_token'];
          setLocalStorage({ 'pdc_sign_in_type': '' });

          if (is_authoried === 'true') {
            console.log("");
            console.log(getCurrentTime());
            console.log("Send checking request: " + pdc_domain + "/api/v1/accounts/checking");
            console.log("Parameters {username: " + request.username + ", url: " + request.url + ", token: " + client_token + "}");

            fetch(pdc_domain + '/api/v1/accounts/checking', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json;charset=UTF-8' },
              body: JSON.stringify({
                username: request.username,
                url: request.url,
                token: client_token,
                current_browser: config.current_browser,
                full_browser_version: config.full_browser_version,
                pp_version: config.pp_version,
                site: pdc_domain
              })
            }).then((response) => {
              response.json().then((obj) => {
                if (response.ok) {
                  if (obj['has_confirmation'] == true) {
                    setLocalStorage({ 'pdc_hasSubmitInfo': 'true' });
                    setLocalStorage({ 'pdc_username': request.username });
                    setLocalStorage({ 'pdc_institution_name': obj['institution_name'] });
                    setLocalStorage({ 'pdc_url': request.url });
                    setLocalStorage({ 'existing_accounts': JSON.stringify(obj['existing_accounts']) });
                    var tab_id = parseInt(request.tab_id);
                    var window_id = parseInt(request.window_id);
                    var is_not_normal = request.is_not_normal;

                    chrome.tabs.query({ active: true, windowId: window_id }, (tabs) => {
                      var old_tab_id = parseInt(localStorage['pdc_tabID']);
                      if (old_tab_id) {
                        if (localStorage['pdc_save_success'] === 'true') {
                          chrome.tabs.sendMessage(old_tab_id, { directive: 'hide_iframe_success' });
                          setLocalStorage({ 'pdc_save_success': 'false' });
                        } else if (localStorage['pdc_save_fail'] === 'true') {
                          chrome.tabs.sendMessage(old_tab_id, { directive: 'hide_iframe_fail' });
                          setLocalStorage({ 'pdc_save_fail': 'false' });
                        } else {
                          chrome.tabs.sendMessage(old_tab_id, { directive: 'hide_iframe' });
                        }
                      }
                      setLocalStorage({ 'pdc_tabID': tab_id });
                      setLocalStorage({ 'pdc_windowID': window_id });
                      if (is_not_normal === 'true') {
                        chrome.tabs.sendMessage(tab_id, { directive: 'show_iframe' });
                      } else {
                        for (let i = 0; i < sites_need_to_show.length; i++) {
                          if (request.url.indexOf(sites_need_to_show[i]) > -1) {
                            chrome.tabs.sendMessage(tab_id, { directive: 'show_iframe' });
                          }
                        }
                      }
                      if (is_present(request.is_from_sign_in_bar) && request.is_from_sign_in_bar === 'true') {
                        chrome.tabs.sendMessage(tab_id, { directive: 'show_iframe' });
                      }
                    });
                  } else {
                    setLocalStorage({ 'pdc_hasSubmitInfo': 'false' });
                  }
                } else if (response.status == 401 || (response.status == 404 && (obj['message'] === 'Invalid access token')) || (response.status == 400 && (obj['message'] === 'Missing Token parameter'))) {
                  setLocalStorage({ 'pdc_sign_in_type': 'token_expired' });
                  setLocalStorage({ 'token_used_expired': client_token });
                  handleTokenExpired(parseInt(request.tab_id), parseInt(request.window_id), request);
                } else {
                  setLocalStorage({ 'pdc_hasSubmitInfo': 'false' });
                }
              })
            })
          } else {
            setLocalStorage({ 'pdc_hasSubmitInfo': 'false' });
            setLocalStorage({ 'pdc_sign_in_type': 'never_sign_in' });
            handleTokenExpired(parseInt(request.tab_id), parseInt(request.window_id), request);
          }
        })
        break;
      case 'authorize_automatically':
        chrome.storage.local.get(['pdc_is_authoried', 'pdc_client_token', 'pdc_client_first_name', 'pdc_client_first_name'], (localStorage) => {
          var is_authoried = localStorage['pdc_is_authoried'];
          var client_token = localStorage['pdc_client_token'];

          if (is_authoried === 'true') {
            fetch(
              pdc_domain + "/api/v1/auth/authorize_automatically", {
              method: "POST",
              headers: { "Content-Type": "application/json;charset=UTF-8" },
              body: JSON.stringify({
                "email": request.username,
                "password": request.password,
                "token": client_token,
                "current_browser": config.current_browser,
                "full_browser_version": config.full_browser_version,
                "pp_version": config.pp_version,
                "site": pdc_domain
              })
            }
            ).then((response) => {
              response.json().then((obj) => {
                if (response.ok) {
                  setLocalStorage({ 'pdc_session_name': obj['browser_name'] });
                  if (obj['notify_client_already_signed_in'] == true) {
                    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
                      setLocalStorage({ 'pp_is_signed_in': 'true' });
                      setLocalStorage({ 'pp_is_signed_in_tab_id': tabs[0].id });
                      setLocalStorage({ 'pp_is_signed_in_message': localStorage['pdc_client_first_name'] + " is signed in to DCS Portfolio Plus" });
                      chrome.tabs.sendMessage(tabs[0].id, { "directive": "show_automatically_sign_in", "pdc_client_first_name": localStorage['pdc_client_first_name'], "tab_id": tabs[0].id, "window_id": tabs[0].windowId });
                    });
                  }
                } else {
                  reauthorize_to_pp(request);
                }
              })
            })
          } else {
            reauthorize_to_pp(request);
          }
        })
        break;
      case 'save_account':
        chrome.storage.local.get(['pdc_client_token', 'pdc_username', 'pdc_url', 'pdc_tabID'], (localStorage) => {
          var client_token = localStorage['pdc_client_token'];
          var username = localStorage['pdc_username'];
          var url = localStorage['pdc_url'];
          var submit_type = request.submit_type;
          console.log("");
          console.log(getCurrentTime());
          console.log("Send saving request: " + pdc_domain + "/api/v1/accounts");
          console.log("Request parameters:");
          console.log("Parameters {username: " + username + ", url: " + url + ", token: " + client_token + ", submit_type: " + submit_type + "}");
          fetch(
            pdc_domain + "/api/v1/accounts", {
            method: "POST",
            headers: { "Content-Type": "application/json;charset=UTF-8" },
            body: JSON.stringify({
              "username": username,
              "url": url,
              "token": client_token,
              "submit_type": submit_type,
              "current_browser": config.current_browser,
              "full_browser_version": config.full_browser_version,
              "pp_version": config.pp_version,
              "site": pdc_domain
            })
          }
          ).then((response) => {
            response.json().then((obj) => {
              if (response.ok) {
                setLocalStorage({ 'pdc_save_success': 'true' });
                getCurrentTab().then((tab) => {
                  var tab_id = localStorage['pdc_tabID'] || tab?.id;
                  if (tab_id) {
                    chrome.tabs.sendMessage(tab_id, { "directive": "hide_iframe_fail" });
                    chrome.tabs.sendMessage(tab_id, { "directive": "hide_iframe" });

                    if (submit_type === 'save') {
                      chrome.tabs.sendMessage(tab_id, { "directive": "show_iframe_success" });
                    }
                  }

                  chrome.windows.getAll({ populate: true }, (windows) => {
                    windows.forEach((window) => {
                      window.tabs.forEach((window_tab) => {
                        if (window_tab.id && window_tab.active) {
                          chrome.tabs.sendMessage(window_tab.id, { "directive": "hide_iframe_fail" });
                          chrome.tabs.sendMessage(window_tab.id, { "directive": "hide_iframe" });
                        }
                      });
                    });
                  });
                  setLocalStorage({ 'pdc_save_fail': 'false' });
                  resetToolbar();

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
                });
              } else {
                console.log("");
                console.log(getCurrentTime());
                console.log("Response from " + pdc_domain + "/api/v1/accounts");
                console.log("{");
                var obj2 = obj;
                for (var key in obj) {
                  if (obj2.hasOwnProperty(key)) {
                    console.log(key + ": " + obj2[key]);
                  }
                }
                console.log("}");
                getCurrentTab().then((tab) => {
                  var tab_id = localStorage['pdc_tabID'] || tab?.id;
                  if (request.is_from_toolbar_fail !== 'true' && tab_id) {
                    chrome.tabs.sendMessage(tab_id, { "directive": "hide_iframe" });
                    chrome.tabs.sendMessage(tab_id, { "directive": "show_iframe_fail" });
                  }
                  setLocalStorage({ 'pdc_save_fail': 'true' });
                  setLocalStorage({ 'pdc_save_success': 'false' });
                });
              }
            });
          });
        })
        break;
      case 'hide_iframe':
        chrome.storage.local.get(['pdc_tabID'], (localStorage) => {
          getCurrentTab().then((tab) => {
            var tab_id = localStorage['pdc_tabID'] || tab?.id;
            if (tab_id) {
              chrome.tabs.sendMessage(parseInt(tab_id), { "directive": "hide_iframe" });
              resetToolbar();
              clearTabIDWindowID();
            }
          });
        })
        break;
      case 'hide_iframe_success':
        chrome.storage.local.get(['pdc_tabID'], function (localStorage) {
          getCurrentTab().then((tab) => {
            var tab_id = localStorage['pdc_tabID'] || tab?.id;
            if (tab_id) {
              chrome.tabs.sendMessage(parseInt(tab_id), { "directive": "hide_iframe_success" });
              clearTabIDWindowID();
            }
          });
        })
        break;
      case 'hide_iframe_fail':
        chrome.storage.local.get(['pdc_tabID'], (localStorage) => {
          getCurrentTab().then((tab) => {
            var tab_id = localStorage['pdc_tabID'] || tab?.id;
            if (tab_id) {
              chrome.tabs.sendMessage(parseInt(tab_id), { "directive": "hide_iframe_fail" });
              resetToolbar();
              clearTabIDWindowID();
            }
          });
        })
        break;
      case 'get_institution':
        chrome.storage.local.get(['pdc_institution_name', 'pdc_client_first_name', 'existing_accounts'], (localStorage) => {
          callback({ 'pdc_institution_name': localStorage['pdc_institution_name'], 'pdc_client_first_name': localStorage['pdc_client_first_name'], 'existing_accounts': JSON.parse(localStorage['existing_accounts']) });
        });
        return true;
      case 'getUrl':
        chrome.windows.getCurrent((window) => {
          if (window.type === 'normal') {
            chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
              var url = request.url;
              while (url.indexOf('|') > -1) {
                url = url.replace('|', '');
              }
              chrome.tabs.sendMessage(tabs[0].id, { "directive": "sendInfoToBackground", "username": request.username, "url": url, "form_html": request.form_html, "tab_id": tabs[0].id, "window_id": tabs[0].windowId, "is_not_normal": "false" });
            });
          } else {
            chrome.tabs.query({ active: true, windowType: 'normal', currentWindow: false }, function (tabs) {
              var url = tabs[0].url;
              while (url.indexOf('|') > -1) {
                url = url.replace('|', '');
              }
              chrome.tabs.sendMessage(tabs[0].id, { "directive": "sendInfoToBackground", "username": request.username, "url": url, "form_html": request.form_html, "tab_id": tabs[0].id, "window_id": tabs[0].windowId, "is_not_normal": "true" });
            });
          }
        });
        break;
      case 'reload-contentscript':
        chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
          chrome.scripting.executeScript({
            target: { tabId: tabs[0].id },
            files: ["form_submits.js"]
          }, () => { });
        });
        break;
      case 'closeAutomaticallySignIn':
        chrome.storage.local.get(['pp_is_signed_in_tab_id'], function (localStorage) {
          var tab_id = JSON.parse(localStorage['pp_is_signed_in_tab_id']);
          chrome.tabs.sendMessage(tab_id, { "directive": "hideAutomaticallySignIn" });
          resetPPIsSignedIn();
        })
        break;
      case 'closePPInstructions':
        chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
          for (var i = 0; i < tabs.length; ++i) {
            if (tabs[i].url.indexOf('pp_instructions') > -1) {
              chrome.tabs.remove(tabs[i].id, function () { });
            }
          }
        });
        break;
      case 'getPPSignedInMessage':
        chrome.storage.local.get(['pp_is_signed_in_message'], (localStorage) => {
          callback({ 'pp_is_signed_in_message': localStorage['pp_is_signed_in_message'] });
        })
        return true;
      case 'hide_sign_in_iframe':
        chrome.storage.local.get(['pdc_tabID'], (localStorage) => {
          getCurrentTab().then((tab) => {
            var tab_id = localStorage['pdc_tabID'] || tab?.id;
            setLocalStorage({ 'sign_in_bar_close': 'true' });
            chrome.tabs.sendMessage(parseInt(tab_id), { "directive": "hide_sign_in_iframe" });
            resetToolbar();
            clearTabIDWindowID();
          })
        })
        break;
      case 'submit_sign_in_form_from_bar':
        // var email = request.email;
        // var password = request.password;
        // fetch(
        //   pdc_domain + "/api/v1/auth/authorize", {
        //     method: "POST",
        //     headers: { "Content-Type": "application/json;charset=UTF-8" },
        //     body: JSON.stringify({"email": email, "password": password, "current_browser": config.current_browser, "full_browser_version": config.full_browser_version, "pp_version": config.pp_version, "site": pdc_domain})
        // }
        // ).then((response) => {
        //   response.json().then((obj) => {
        //     if (response.ok) {
        //       setLocalStorage({'pdc_is_authoried': 'true'});
        //       setLocalStorage({'pdc_client_token': obj['token']});
        //       setLocalStorage({'pdc_client_first_name': obj['first_name']});
        //       setLocalStorage({'pdc_session_name': obj['default_session_name']});
        //       var username = localStorage['pdc_username'];
        //       var url = localStorage['pdc_url'];
        //       var tab_id = parseInt(localStorage['pdc_tabID']);
        //       var window_id = parseInt(localStorage['pdc_windowID']);
        //       var is_not_normal = localStorage['pdc_is_not_normal'];
        //       chrome.tabs.sendMessage(tab_id, {"directive": "show_asking_browser_name_bar", browsers: obj['browsers']});
        //     } else {
        //       setLocalStorage({'pdc_is_authoried': 'false'});
        //       setLocalStorage({'pdc_client_token': ''});
        //       chrome.tabs.sendMessage(parseInt(localStorage['pdc_tabID']), {"directive": "show_error_when_sign_in_from_bar", request_status: response.status, response_domain: obj['domain'], response_message: obj['message']});
        //     }
        //   });
        // });
        chrome.storage.local.get(['pdc_is_authoried', 'pdc_username', 'pdc_client_token', 'pdc_url', 'pdc_tabID', 'pdc_windowID', 'pdc_is_not_normal'], (localStorage) => {
          getCurrentTab().then((tab) => {
            var tab_id = localStorage['pdc_tabID'] || tab?.id;
            var username = localStorage['pdc_username'];
            var url = localStorage['pdc_url'];
            var is_not_normal = localStorage['pdc_is_not_normal'];
            var tab_id = localStorage['pdc_tabID'] || tab?.id;
            var window_id = parseInt(localStorage['pdc_windowID']);
            chrome.tabs.sendMessage(tab_id, { "directive": "hide_sign_in_iframe" });
            chrome.tabs.sendMessage(tab_id, { 'directive': 'ask_to_save_new_account', 'username': username, 'url': url, 'tab_id': tab_id, 'window_id': window_id, 'is_not_normal': is_not_normal });
          })
        })

        break;
      case 'deauthorize_all_browsers_from_bar':
        chrome.storage.local.get(['pdc_is_authoried', 'pdc_client_token', 'pdc_tabID'], (localStorage) => {
          var is_authoried = localStorage['pdc_is_authoried'];
          var client_token = localStorage['pdc_client_token'];
          if ((is_authoried == 'true') && is_present(client_token)) {
            fetch(
              pdc_domain + "/api/v1/auth/deauthorize", {
              method: "POST",
              headers: { "Content-Type": "application/json;charset=UTF-8" },
              body: JSON.stringify({ "token": client_token, "current_browser": config.current_browser, "full_browser_version": config.full_browser_version, "pp_version": config.pp_version, "site": pdc_domain })
            }
            ).then((response) => {
              response.json().then((obj) => {
                if (response.ok) {
                  var tab_id = parseInt(localStorage['pdc_tabID']);
                  chrome.tabs.sendMessage(tab_id, { "directive": "hide_browser_list" });
                }
              });
            });
          }
        })
        break;
      case 'save_browser_name_from_bar':
        chrome.storage.local.get(['pdc_is_authoried', 'pdc_username', 'pdc_client_token', 'pdc_url', 'pdc_tabID', 'pdc_windowID', 'pdc_is_not_normal'], (localStorage) => {
          var is_authoried = localStorage['pdc_is_authoried'];
          var client_token = localStorage['pdc_client_token'];
          var browser_name_val = request.browser_name;
          getCurrentTab().then((tab) => {
            if ((is_authoried == 'true') && is_present(browser_name_val) && is_present(client_token)) {
              fetch(
                pdc_domain + "/api/v1/auth/save_browser_name", {
                method: "POST",
                headers: { "Content-Type": "application/json;charset=UTF-8" },
                body: JSON.stringify({ "token": client_token, "current_browser": config.current_browser, "browser_name": browser_name_val, "full_browser_version": config.full_browser_version, "pp_version": config.pp_version, "site": pdc_domain })
              }
              ).then((response) => {
                response.json().then((obj) => {
                  // $('#enter-browser-name-form-error').html('').addClass('hide');
                  var username = localStorage['pdc_username'];
                  var url = localStorage['pdc_url'];
                  var is_not_normal = localStorage['pdc_is_not_normal'];
                  var tab_id = localStorage['pdc_tabID'] || tab?.id;
                  var window_id = parseInt(localStorage['pdc_windowID']);
                  if (response.ok) {
                    setLocalStorage({ 'pdc_session_name': obj['browser_name'] });
                    chrome.tabs.sendMessage(tab_id, { "directive": "hide_sign_in_iframe" });
                    chrome.tabs.sendMessage(tab_id, { 'directive': 'ask_to_save_new_account', 'username': username, 'url': url, 'tab_id': tab_id, 'window_id': window_id, 'is_not_normal': is_not_normal });
                  } else {
                    if (is_present(obj['message'])) {
                      chrome.tabs.sendMessage(parseInt(tab_id), { "directive": "show_error_when_save_browser_name_from_bar", request_status: response.status, response_domain: obj['domain'], response_message: obj['message'] });
                    } else {
                      chrome.tabs.sendMessage(tab_id, { "directive": "hide_sign_in_iframe" });
                      chrome.tabs.sendMessage(tab_id, { 'directive': 'ask_to_save_new_account', 'username': username, 'url': url, 'tab_id': tab_id, 'window_id': window_id, 'is_not_normal': is_not_normal });
                    }
                  }
                });
              });
            }
          })
        })
        break;
    }
  });

  // the sites that after login successfully, the TabId is changed
  var sites_tabID_changed = ["dropbox", "easyweb.td.com"];

  chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
    chrome.storage.local.get(['pdc_is_authoried', 'pdc_hasSubmitInfo', 'pdc_client_token', 'count_number_sign_in_iframe_shown',
      'pdc_save_fail', 'pdc_tabID', 'pdc_windowID', 'pdc_client_first_name', 'pp_is_signed_in', 'pp_is_signed_in_tab_id', 'pdc_save_success', 'sign_in_bar_close'], (localStorage) => {
        if (changeInfo && changeInfo.status === "complete") {
          if (typeof localStorage['pdc_tabID'] !== 'undefined' && localStorage['pdc_tabID'] != null && localStorage['pdc_tabID'] !== '') {
            if (typeof localStorage['pdc_windowID'] != 'undefined' && localStorage['pdc_windowID'] != null && localStorage['pdc_windowID'] !== '') {
              var tab_id = parseInt(localStorage['pdc_tabID']);
              var window_id = parseInt(localStorage['pdc_windowID']);
              chrome.tabs.query({ active: true, windowId: parseInt(window_id) }, (tabs) => {
                if (localStorage['pdc_is_authoried'] == 'true') {
                  if (localStorage['pdc_hasSubmitInfo'] == 'true') {
                    if (localStorage['pdc_save_fail'] == 'true') {
                      chrome.tabs.sendMessage(tab_id, { "directive": "hide_iframe_fail" });
                      chrome.tabs.sendMessage(tab_id, { "directive": "show_iframe_fail" });
                    } else {
                      setLocalStorage({ 'pdc_hasSubmitInfo': 'false' })
                      chrome.tabs.sendMessage(tab_id, { "directive": "hide_iframe" });
                      chrome.tabs.sendMessage(tab_id, { "directive": "show_iframe" });
                    }
                  } else {
                    if (localStorage['pdc_save_success'] == 'true') {
                      clearTabIDWindowID();
                      chrome.tabs.sendMessage(tab_id, { "directive": "hide_iframe_success" });
                    }
                  }
                } else {
                  if (localStorage['sign_in_bar_close'] == 'true') {
                    setLocalStorage({ 'sign_in_bar_close': 'false' });
                    resetToolbar();
                    clearTabIDWindowID();
                  } else {
                    if (localStorage['pdc_client_token'] === '') {
                      if (parseInt(localStorage['count_number_sign_in_iframe_shown']) < 3) {
                        chrome.tabs.sendMessage(tab_id, { "directive": "show_sign_in_iframe" });
                        increase_number_sign_in_iframe_shown();
                      }
                    } else {
                      resetToolbar();
                      clearTabIDWindowID();
                    }
                  }
                }
              });
            }
          }
          if (typeof localStorage['pp_is_signed_in'] !== 'undefined' && localStorage['pp_is_signed_in'] != null && localStorage['pp_is_signed_in'] !== '') {
            var tab_id = parseInt(localStorage['pp_is_signed_in_tab_id']);
            chrome.tabs.sendMessage(tab_id, { "directive": "show_automatically_sign_in", "pdc_client_first_name": localStorage['pdc_client_first_name'] });
            setLocalStorage({ 'pp_is_signed_in': '' });
          }
        }
      })
  });

  chrome.tabs.onRemoved.addListener(function (tabId, objectInfo) {
    chrome.storage.local.get(['pdc_tabID', 'pdc_windowID', 'pdc_hasSubmitInfo'], (localStorage) => {
      if (typeof localStorage['pdc_tabID'] !== 'undefined' && localStorage['pdc_tabID'] != null && localStorage['pdc_tabID'] !== '' && tabId.toString() === localStorage['pdc_tabID']) {
        if (typeof localStorage['pdc_windowID'] != 'undefined' && localStorage['pdc_windowID'] != null && localStorage['pdc_windowID'] !== '' && objectInfo.windowId.toString() === localStorage['pdc_windowID']) {
          if (localStorage['pdc_hasSubmitInfo'] === 'true') {
            resetToolbar();
            clearTabIDWindowID();
            resetPPIsSignedIn();
          }
        }
      }
    })
  });

  chrome.windows.onRemoved.addListener(function (windowId) {
    chrome.storage.local.get(['pdc_windowID', 'pdc_hasSubmitInfo'], (localStorage) => {
      if (typeof localStorage['pdc_windowID'] != 'undefined' && localStorage['pdc_windowID'] != null && localStorage['pdc_windowID'] !== '' && windowId.toString() === localStorage['pdc_windowID']) {
        if (localStorage['pdc_hasSubmitInfo'] === 'true') {
          resetToolbar();
          clearTabIDWindowID();
          resetPPIsSignedIn();
        }
      }
    })
  });

  chrome.runtime.onInstalled.addListener(function (details) {
    if (details.reason == "install" || details.reason == "update") {
      chrome.windows.getAll({ populate: true }, function (windows) {
        windows.forEach(function (window) {
          window.tabs.forEach(function (tab) {
            if ((tab.url.indexOf("directivecommunications.com") > -1) || (tab.url.indexOf("localhost") > -1) || (tab.url.indexOf("protectmyplans.com") > -1) || (tab.url.indexOf("directivecommunications.ca") > -1) || (tab.url.indexOf("protectmyplans.ca") > -1)) {
              // chrome.tabs.reload(tab.id);
              chrome.scripting.executeScript({
                target: { tabId: tab.id },
                files: ["jquery.min.js"]
              }, () => {
                chrome.scripting.executeScript({
                  target: { tabId: tab.id },
                  files: ["remove_extension.js"]
                }, () => { });
              });
            }
          });
        });
      });
    }
    if (details.reason == "install") {
      chrome.tabs.create({ url: pdc_domain + '/clients/pp_instructions' });
    }
  });

  const resetPPIsSignedIn = () => {
    setLocalStorage({ 'pp_is_signed_in': '' });
    setLocalStorage({ 'pp_is_signed_in_tab_id': '' });
    setLocalStorage({ 'pp_is_signed_in_message': '' });
  }

  const handleTokenExpired = (tab_id, window_id, request) => {
    setLocalStorage({ 'pdc_username': request.username });
    setLocalStorage({ 'pdc_url': request.url });
    setLocalStorage({ 'pdc_is_not_normal': request.is_not_normal });

    // Clear 'session' on PP
    setLocalStorage({ 'pdc_is_authoried': 'false' });
    setLocalStorage({ 'pdc_client_token': '' });
    setLocalStorage({ 'pdc_tabID': tab_id });
    setLocalStorage({ 'pdc_windowID': window_id });

    // Display sign-in form
    chrome.scripting.executeScript({
      target: { tabId: tab_id },
      files: ["jquery.min.js"]
    }, () => {
      chrome.scripting.executeScript({
        target: { tabId: tab_id },
        files: ["display_sign_in_form.js"]
      }, () => { });
    });

    chrome.storage.local.get(['count_number_sign_in_iframe_shown'], (localStorage) => {
      if (request.is_not_normal === 'true') {
        if (parseInt(localStorage['count_number_sign_in_iframe_shown']) < 3) {
          chrome.tabs.sendMessage(tab_id, { "directive": "show_sign_in_iframe" });
          increase_number_sign_in_iframe_shown();
        }
      } else {
        for (let i = 0; i < sites_need_to_show.length; i++) {
          if (request.url.indexOf(sites_need_to_show[i]) > -1) {
            if (parseInt(localStorage['count_number_sign_in_iframe_shown']) < 3) {
              chrome.tabs.sendMessage(tab_id, { "directive": "show_sign_in_iframe" });
              increase_number_sign_in_iframe_shown();
            }
          }
        }
      }
    })
  }

  const is_present = (val) => {
    return !['', null, undefined, NaN].includes(val);
  }

  const increase_number_sign_in_iframe_shown = () => {
    chrome.storage.local.get(['count_number_sign_in_iframe_shown', 'token_used_expired'], (localStorage) => {
      if (is_present(localStorage['count_number_sign_in_iframe_shown']) == false) {
        setLocalStorage({ 'count_number_sign_in_iframe_shown': 0 });
      } else {
        setLocalStorage({ 'count_number_sign_in_iframe_shown': parseInt(localStorage['count_number_sign_in_iframe_shown']) + 1 });
      }
      if (parseInt(localStorage['count_number_sign_in_iframe_shown']) == 3) {
        var client_token = localStorage['token_used_expired'];
        if (is_present(client_token)) {
          fetch(
            pdc_domain + "/api/v1/auth/inform_token_epxired", {
            method: "POST",
            headers: { "Content-Type": "application/json;charset=UTF-8" },
            body: JSON.stringify({ "current_browser": config.current_browser, "full_browser_version": config.full_browser_version, "pp_version": config.pp_version, "site": pdc_domain, 'client_token': client_token })
          }).then(() => { });
        }
      }
    })
  }

  const reauthorize_to_pp = (request) => {
    fetch(
      pdc_domain + "/api/v1/auth/authorize", {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=UTF-8" },
      body: JSON.stringify({ "email": request.username, "password": request.password, "is_automatic": true, "current_browser": config.current_browser, "full_browser_version": config.full_browser_version, "pp_version": config.pp_version, "site": pdc_domain })
    }
    ).then((response) => {
      response.json().then((obj) => {
        if (response.ok) {
          setLocalStorage({ 'pdc_is_authoried': 'true' });
          setLocalStorage({ 'pdc_client_token': obj['token'] });
          setLocalStorage({ 'pdc_client_first_name': obj['first_name'] });
          setLocalStorage({ 'pdc_session_name': obj['default_session_name'] });
          chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
            setLocalStorage({ 'pp_is_signed_in': 'true' });
            setLocalStorage({ 'pp_is_signed_in_tab_id': tabs[0].id });
            setLocalStorage({ 'pp_is_signed_in_message': "DCS Portfolio Plus has signed in as " + obj['first_name'] });
            chrome.tabs.sendMessage(tabs[0].id, { "directive": "show_automatically_sign_in", "pdc_client_first_name": obj['first_name'], "tab_id": tabs[0].id, "window_id": tabs[0].windowId });
          });
        }
      })
    });
  }

} catch (e) {
  console.log(e)
}
