var isInstalledNode = document.createElement('div');
isInstalledNode.className = 'pdc-be-extension-is-installed';
document.body.appendChild(isInstalledNode);

var is_detect_button_click = false;
var selectors = "input[type='submit'], "
  + "input[name='login'], input[name='log_in'], input[name='log in'], "
  + "input[name='signin'], input[name='sign_in'], input[name='sign in'], "
  + "button[type='submit'], "
  + "button[name*='login'], button[name*='log_in'], button[name*='log in'], "
  + "button[name*='signin'], button[name*='sign_in'], button[name*='sign_in'], "
  + "button[id*='Login'], button[id*='login'], button[id*='Submit'], button[id*='submit'], "
  + "button[class*='Login'], button[class*='login'], button[class*='Submit'], button[class*='submit'], button[class*='sign-on'], "
  + "input[name*='Submit'], input[name*='submit'], input[name='Log In'], input[id='brandedLoginBtn'], "
  + "input[type='image'], "
  + "img[id*='Login'], "
  + "button:contains('Log In'), button:contains('Log in'), button:contains('LOG IN'), button#signup_forms_submit, "
  + "button:contains('Sign In'), button:contains('sign in'), "
  + "li:contains('Submit'), td:contains('Sign In'), "
  + "div[class*='submit'], div[class*='Submit'], div[class*='Login'], div[class*='login'], div[class*='btn-login']";

var form_attribute_filters = ["login", "log_in", "log-in", "log in", "logon", "log_on", "log-on", "log on",
  "signin", "sign_in", "sign-in", "sign in"];

var popup_pages = ["instagram"];

chrome.runtime.onMessage.addListener(function (request, sender, callback) {
  switch (request.directive) {
    case 'sendInfoToBackground':
      if (window == window.top) {
        var url = request.url;
        var username = request.username;
        var form_html = request.form_html;
        var tab_id = request.tab_id;
        var window_id = request.window_id;
        var is_not_normal = request.is_not_normal;
        var newDate = new Date();
        chrome.runtime.sendMessage({ 'directive': 'form_submit', 'url': url, 'username': username, "form_html": form_html }, function () { });
        if (username != undefined && username != null && username != '' && url != undefined && url != null && url != '') {
          chrome.runtime.sendMessage({ 'directive': 'checking_authorized', 'username': username, 'url': url, 'tab_id': tab_id, 'window_id': window_id, 'is_not_normal': is_not_normal }, function (response) { });
        }
      }
      break;
  }
});

function detectLogin(e, curent_form, special_form) {
  var ajax_form_type = "";
  var inputs = $("input[type='text'], input[type='email'], input[type='password'], input[id*='userName'], input[id='fm-login-id']", curent_form);
  var all_inputs = $("input", curent_form);
  var arr_exception_types = ['submit', 'radio', 'checkbox', 'button', 'number', 'date', 'color', 'range', 'month', 'week', 'time', 'datetime', 'datetime-local', 'search', 'tel', 'url', 'hidden'];
  var arr_selected_types = ['undefined', 'email', 'text', 'password'];
  var password_field = $('input[type="password"]', curent_form);
  var form_html = $(curent_form).parent().html();
  var detect_username = false;
  var use_all_inputs = false;
  if (inputs.length > 1) {
    detect_username = true;
  } else {
    var inputs_length = 0;
    for (i = 0; i < all_inputs.length; i++) {
      var thisType = $(all_inputs[i]).attr('type');
      if (thisType == undefined || thisType === 'undefined') {
        thisType = 'undefined';
      }
      if ($.inArray(thisType.toLowerCase(), arr_selected_types)) {
        inputs_length++;
      }
    }
    if (inputs_length > 1) {
      detect_username = true;
      use_all_inputs = true;
    }
  }
  var institution_url = window.location.href;
  if (institution_url.indexOf("facebook.com") > -1 && institution_url.indexOf("skip_api_login=1") > -1) {
    institution_url = findFaceBookRedirectDomain(institution_url.toLowerCase());
  }

  if (institution_url.indexOf("google.com") > -1 && institution_url.indexOf("redirect_uri") > -1) {
    institution_url = findGoogleRedirectDomain(institution_url.toLowerCase());
  }

  if (institution_url.indexOf("linkedin.com") > -1 && institution_url.indexOf("redirect_uri") > -1) {
    institution_url = findLinkedinRedirectDomain(institution_url.toLowerCase());
  }

  if (institution_url.indexOf("mail.google.com") > -1 && institution_url.indexOf("redirect_uri") > -1) {
    institution_url = findGmailRedirectDomain(institution_url.toLowerCase());
  }

  if (inputs.length == 1 && password_field.length == 0 && special_form == true) {
    is_detect_button_click = true;
    getUrl(inputs.val(), institution_url, form_html)
  }
  else if (detect_username == true && password_field != undefined && password_field != null) {
    is_detect_button_click = true;
    if (password_field.length == 1) {
      if (inputs.length == 3) {
        // THIS IS WORK-AROUND FOR FIXING TICKET WAD-2854
        // Because I dont want to touch the processing here because the detecting STILL CORRECT up to now
        // But for this page (dhgate.com) the row "inputs.eq(index_of_password_field - 2)" return inorrect field username
        // TODO Need to refactor that we do not set hard-code
        if (institution_url.indexOf("dhgate.com") > -1) {
          if ($('#username').length > 0) {
            var username_field = $('#username');
            getUrl(username_field.val(), institution_url, form_html);
          }
        } else {
          var index_of_password_field = inputs.index(password_field);
          var username_field = inputs.eq(index_of_password_field - 2);
          var type = username_field.prop('type');
          if (type !== 'hidden') {
            getUrl(username_field.val(), institution_url, form_html);
          }
        }
      }
      else if (password_field.val() !== '') {
        var index_of_password_field = inputs.index(password_field);
        var username_field = inputs.eq(index_of_password_field - 1);
        if (use_all_inputs == true) {
          index_of_password_field = all_inputs.index(password_field);
          username_field = all_inputs.eq(index_of_password_field - 1);
        }
        var type = username_field.prop('type');
        if (type !== 'hidden') {
          getUrl(username_field.val(), institution_url, form_html);
        }
      }
    }
    else if (password_field.length > 1) {
      ajax_form_type += "A5 ";
      var form_class = $(curent_form).attr('class');
      var form_id = $(curent_form).attr('id');
      var form_name = $(curent_form).attr('name');
      var form_action = $(curent_form).attr('action');
      var has_form_info = 'false';
      for (i = 0; i < form_attribute_filters.length; i++) {
        if (typeof form_class !== 'undefined' && form_class.toLowerCase().indexOf(form_attribute_filters[i]) > -1) {
          has_form_info = 'true';
          break;
        }

        if (typeof form_id !== 'undefined' && form_id.toLowerCase().indexOf(form_attribute_filters[i]) > -1) {
          has_form_info = 'true';
          break;
        }

        if (typeof form_name !== 'undefined' && form_name.toLowerCase().indexOf(form_attribute_filters[i]) > -1) {
          has_form_info = 'true';
          break;
        }

        if (typeof form_action !== 'undefined' && form_action.toLowerCase().indexOf(form_attribute_filters[i]) > -1) {
          has_form_info = 'true';
          break;
        }
      }

      if (has_form_info === 'true') {
        var username_field = $("input[type='text'][name*='USER'], input[type='text'][name*='user'], input[type='text'][name*='User'], input[type='text'][placeholder*='Email'], input[type='text'][placeholder*='email'], input[type='text'][placeholder*='User'], input[type='text'][placeholder*='user']", curent_form);
        getUrl(username_field.val(), institution_url, form_html);
      } else {
        ajax_form_type += "A7 ";
      }
    }
  }
  if (ajax_form_type !== '') {
    sendAjaxFormType(ajax_form_type);
  }
}

function sendAjaxFormType(message) {
  if (is_login_button_is_clicked) {
    chrome.runtime.sendMessage({ 'directive': 'ajax-form-type', 'type': message }, function (response) {
    });
  }
}

function getSpecialForm() {
  var selector = "body form[name='rbunxcgi'], body form[name='idForm'], body form#signup_form";
  return $(selector);
}

function getUrl(username, url, form_html) {
  chrome.runtime.sendMessage({ 'directive': 'getUrl', 'url': url, 'username': username, 'form_html': form_html }, function (response) {
  });
}

function findFaceBookRedirectDomain(url) {
  var redirect_domain = "";
  var redirect_uri_idx = url.indexOf("redirect_uri");
  var url_sub1 = url.substring(redirect_uri_idx);
  var idx_252f_1 = url_sub1.indexOf("%252f");
  var url_sub2 = url_sub1.substring(idx_252f_1);
  var url_sub3 = url_sub2.substring(10);
  var idx_252f_2 = url_sub3.indexOf("%");
  redirect_domain = url_sub3.substring(0, idx_252f_2);
  if (redirect_domain.indexOf("facebook") < 0) {
    return redirect_domain
  } else {
    var url_sub4 = url_sub3.substring(idx_252f_2);
    var idx_252f_3 = url_sub4.indexOf("domain");
    var url_sub5 = url_sub4.substring(idx_252f_3 + 11);
    var idx_2526 = url_sub5.indexOf("%");
    redirect_domain = url_sub5.substring(0, idx_2526);
  }
  return redirect_domain
}

function findGmailRedirectDomain(url) {
  var redirect_domain = "";
  if (url.indexOf("origin") > -1) {
    var origin_idx = url.indexOf("origin");
    var url_sub1 = url.substring(origin_idx);
    var idx_2f_1 = url_sub1.indexOf("%3d");
    var url_sub2 = url_sub1.substring(idx_2f_1 + 3);
    var idx_percentage = url_sub2.indexOf("%26");
    redirect_domain = url_sub2.substring(0, idx_percentage);
    var idx_3a2f = redirect_domain.indexOf("%3a%2f%2f");
    if (idx_3a2f > -1) {
      redirect_domain = redirect_domain.substring(idx_3a2f + 9);
    }
  } else {
    var redirect_uri_idx = url.indexOf("redirect_uri");
    var url_sub1 = url.substring(redirect_uri_idx);
    var idx_2f_1 = url_sub1.indexOf("%3a%2f%2f");
    var url_sub2 = url_sub1.substring(idx_2f_1 + 9);
    var idx_2f_2 = url_sub2.indexOf("%3a443");
    redirect_domain = url_sub2.substring(0, idx_2f_2);
  }
  if (redirect_domain === '') {
    var redirect_uri_idx = url.indexOf("redirect_uri");
    var url_sub1 = url.substring(redirect_uri_idx);
    var idx_3d = url_sub1.indexOf("%3d");
    var url_sub2 = url_sub1.substring(idx_3d + 3);
    var idx_percentage = url_sub2.indexOf("%26");
    redirect_domain = url_sub2.substring(0, idx_percentage);
    var idx_3a2f = redirect_domain.indexOf("%3a%2f%2f");
    if (idx_3a2f > -1) {
      redirect_domain = redirect_domain.substring(idx_3a2f + 9);
    }
  }
  if (redirect_domain.indexOf('%2f') > -1) {
    redirect_domain = redirect_domain.substring(0, redirect_domain.indexOf("%2f"));
  }
  return redirect_domain
}

function findGoogleRedirectDomain(url) {
  var redirect_domain = "";
  if (url.indexOf("origin") > -1) {
    var origin_idx = url.indexOf("origin");
    var url_sub1 = url.substring(origin_idx);
    var idx_2f_1 = url_sub1.indexOf("%3d");
    var url_sub2 = url_sub1.substring(idx_2f_1 + 3);
    var idx_percentage = url_sub2.indexOf("%26");
    redirect_domain = url_sub2.substring(0, idx_percentage);
    var idx_3a2f = redirect_domain.indexOf("%3a%2f%2f");
    if (idx_3a2f > -1) {
      redirect_domain = redirect_domain.substring(idx_3a2f + 9);
    }
  } else {
    var redirect_uri_idx = url.indexOf("redirect_uri");
    var url_sub1 = url.substring(redirect_uri_idx);
    var idx_2f_1 = url_sub1.indexOf("%3a%2f%2f");
    var url_sub2 = url_sub1.substring(idx_2f_1 + 9);
    var idx_2f_2 = url_sub2.indexOf("%3a443");
    redirect_domain = url_sub2.substring(0, idx_2f_2);
  }
  if (redirect_domain === '') {
    var redirect_uri_idx = url.indexOf("redirect_uri");
    var url_sub1 = url.substring(redirect_uri_idx);
    var idx_3d = url_sub1.indexOf("%3d");
    var url_sub2 = url_sub1.substring(idx_3d + 3);
    var idx_percentage = url_sub2.indexOf("%26");
    redirect_domain = url_sub2.substring(0, idx_percentage);
    var idx_3a2f = redirect_domain.indexOf("%3a%2f%2f");
    if (idx_3a2f > -1) {
      redirect_domain = redirect_domain.substring(idx_3a2f + 9);
    }
  }
  if (redirect_domain.indexOf('%2f') > -1) {
    redirect_domain = redirect_domain.substring(0, redirect_domain.indexOf("%2f"));
  }
  return redirect_domain
}

function findLinkedinRedirectDomain(url) {
  var redirect_domain = "";
  var redirect_uri_idx = url.indexOf("redirect_uri");
  var url_sub1 = url.substring(redirect_uri_idx);
  var idx_2f_1 = 0;
  if (url_sub1.indexOf("%3a%2f%2f") > -1) {
    idx_2f_1 = url_sub1.indexOf("%3a%2f%2f") + 9;
  } else if (url_sub1.indexOf("%3a") > -1) {
    idx_2f_1 = url_sub1.indexOf("%3a") + 3;
  } else if (url_sub1.indexOf("%2f%2f") > -1) {
    idx_2f_1 = url_sub1.indexOf("%2f%2f") + 6;
  }
  var url_sub2 = url_sub1.substring(idx_2f_1);
  var idx_2f_2 = url_sub2.indexOf("%");
  if (idx_2f_2 > -1) {
    redirect_domain = url_sub2.substring(0, idx_2f_2);
  } else {
    redirect_domain = url_sub2;
  }

  if (redirect_domain.indexOf("//") > -1) {
    redirect_domain = redirect_domain.substring(redirect_domain.indexOf("//") + 2);
  }
  return redirect_domain
}

var popup_page_url = window.location.href;
if (window == window.top) {
  chrome.runtime.sendMessage({ 'directive': 'site-to-detect', 'url': popup_page_url, 'inner_body': $('body').html() }, function () { });
}
var is_login_form_loaded = false;
var is_login_button_is_clicked = false;
var login_form_message = 'Login Form has not been loaded';
var submit_button_message = 'Login button is not clicked';

// if (popup_page_url === "https://www.instagram.com/" || popup_page_url === 'https://www.instagram.com/?hl=en')
// {
//   $(document).ready(function(){
//     var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
//     var list = document.querySelector('._nvyyp');
//     var is_bind_event = false;
//     var observer = new MutationObserver(function(mutations) {
//       mutations.forEach(function(mutation) {
//         if ($('._uikn3').length > 0){
//           if (!is_bind_event){
//             triggerSubmitForm();
//             is_bind_event = true;
//           }
//         }
//       });
//     });

//     observer.observe(list,{
//       childList: true,
//       subtree: true
//     });
//   });
// }
// else if(popup_page_url.indexOf("vudu.com") > -1)
if (popup_page_url.indexOf("vudu.com") > -1) {
  $("#topNavSingInLink").click(function (e) {
    chrome.runtime.sendMessage({ 'directive': 'reload-contentscript', 'url': popup_page_url }, function () { });
  });

  $("table.gray-button td[class='custom-button-center']").click(function (e) {
    chrome.runtime.sendMessage({ 'directive': 'reload-contentscript', 'url': popup_page_url }, function () { });
  });

  $("table.walmart-button td[class='custom-button-center']").click(function (e) {
    chrome.runtime.sendMessage({ 'directive': 'reload-contentscript', 'url': popup_page_url }, function () { });
  });

  $("table.green-button td[class='custom-button-center']").click(function (e) {
    var username = $(".vudu-sign-in-panel").find("input[type='email']").val();
    if (username != undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    } else {
      username = $(".oauth-sign-in-panel").find("input[type='email']").val();
      if (username != undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}
// else if (popup_page_url.indexOf("https://www.dropbox.com/") > -1 )
// {
//   if (popup_page_url === 'https://www.dropbox.com/?landing=cntl')
//   {
//     $(document).ready(function(){
//       var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
//       var is_bind_event = false;
//       var observer = new MutationObserver(function(mutations) {
//         mutations.forEach(function(mutation) {
//           if ($('#index-sign-in-modal').length > 0){
//             if (!is_bind_event){
//               $('.login-button').on('click', function(e) {
//                 var username = $("#index-sign-in-modal input[name='login_email']").val();
//                 if (username != undefined && username !== '')
//                 {
//                   getUrl(username, popup_page_url, "no form");
//                 }else{
//                   username = $(".login-register-container-wrapper input[name='login_email']").val();
//                   if (username != undefined && username !== '')
//                   {
//                     getUrl(username, popup_page_url, "no form");
//                   }
//                 }
//               });
//               is_bind_event = true;
//             }
//           }
//         });
//       });

//       observer.observe(document,{
//         childList: true,
//         subtree: true
//       });
//     });
//   }
//   else
//   {
//     $('.login-button').on('click', function(e) {
//       var username = $("#index-sign-in-modal input[name='login_email']").val();
//       if (username != undefined && username !== '')
//       {
//         getUrl(username, popup_page_url, "no form");
//       }else{
//         var username = $(".login-register-container-wrapper input[name='login_email']").val();
//         if (username != undefined && username !== '')
//         {
//           getUrl(username, popup_page_url, "no form");
//         }
//       }
//     });
//   }
// }
else if (popup_page_url.indexOf("vine.co") > -1) {
  triggerSubmitForm();
}
else if (popup_page_url.indexOf("https://www.pinterest.com/") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormPinterest();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("tripadvisor.com") > -1) {
  $(".regSubmitBtn").click(function (e) {
    var username = $("input[id='regSignIn.email']").val();
    if (username != undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });
  $("input[type='submit']").click(function (e) {
    var username = $("input[id='email']").val();
    if (username != undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });
}
else if (popup_page_url.indexOf("hulu.com") > -1) {
  $(".btn-login").click(function (e) {
    var username = $("input[id='login']").val();
    if (username != undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });
}
else if (popup_page_url.indexOf("alibaba.com") > -1) {
  $("input[value='Sign in']").click(function (e) {
    var username = $("input[name='loginId']").val();
    if (username != undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });
  triggerSubmitForm();
}
else if (popup_page_url.indexOf("enterprise.com") > -1) {
  if (window == window.top) {
    sendSubmitButtonIsClickedOrNot();
    sendLoginFormIsLoadedOrNot();
  }
  $(".enterprise-login .login-field-container .btn").click(function (e) {
    var username = $("#utility-eplus-email").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });
  $(".emerald-club-login .login-field-container .btn]").click(function (e) {
    var username = $("#utility-emeraldClub-email").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });
}
else if (popup_page_url.indexOf("live.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormMicrosoft();
    }, 1500);
  });
}
// else if (popup_page_url.indexOf("spotify.com") > -1 )
// {
//   $(document).ready(function(){
//     var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
//     var is_bind_event = false;
//     var observer = new MutationObserver(function(mutations) {
//       mutations.forEach(function(mutation) {
//         if ($('.login').length > 0){
//           if (!is_bind_event){
//             triggerSubmitForm();
//             is_bind_event = true;
//           }
//         }
//       });
//     });

//     observer.observe(document,{
//       childList: true,
//       subtree: true
//     });
//   });
// }
// else if (popup_page_url.indexOf("hilton.com") > -1){
//   $("a.linkBtn").on('click', function(e) {
//     var username = $("input#username").val();
//     if (username !== undefined && username !== '')
//     {
//       getUrl(username, popup_page_url, "no form");
//     }
//   });
// }
else if (popup_page_url.indexOf("healthportalsite.com") > -1) {
  $("button[name*='Login']").on('click', function (e) {
    var username = $("input[name*='UserName']").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  })
}
else if ((popup_page_url.indexOf("directivecommunications.com") > -1) || (popup_page_url.indexOf("localhost") > -1) || (popup_page_url.indexOf("protectmyplans.com") > -1)) {
  $('body').addClass('has-installed-pp');
  $(".custom-submit").on('click', function (e) {
    username = $('#user_email').val();
    password = $('#user_password').val();
    url = popup_page_url;
    if (username !== undefined && username !== '') {
      chrome.runtime.sendMessage({ 'directive': 'authorize_automatically', 'username': username, 'url': url, 'password': password }, function (response) { });
    }
  });
}
else if (popup_page_url.indexOf("td.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      triggerSubmitForm();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("godaddy.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormGoDaddy();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("cupid.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormOkCupid();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("pcoptimum.ca") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormPCoptimum();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("accounts.google.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormGmail();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("aol.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormAol();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("apple.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormApple();
    }, 1500);
  });
} else if (popup_page_url.indexOf("airbnb.co.in") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormAirBnb();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("spotify.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormSpotify();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("jetblue.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormJetBlue();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("instagram.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormInstagram();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("hilton.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormHilton();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("dropbox.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormDropbox();
    }, 1500);
  });
}
else if (popup_page_url.indexOf("box.com") > -1) {
  $(document).ready(function (e) {
    setTimeout(function () {
      handleSubmitFormBox();
    }, 1500);
  });
}

else {
  $(document).ready(function (e) {
    triggerSubmitForm();
  });
}

function triggerSubmitForm() {
  var is_form_detected = false;
  for (var i = 0; i < document.forms.length; i++) {
    document.forms[i].addEventListener("submit", function (e) {
      if (is_detect_button_click == false) {
        is_login_form_loaded = true;
        is_login_button_is_clicked = true;
        is_form_detected = true;
        sendLoginFormIsLoadedOrNot();
        detectLogin(e, this, false);
      }
    });
  }

  if (is_form_detected == false) {
    $(selectors).on('click', function (e) {
      is_form_detected = true;
      var form = $(this).closest('form');
      if (form.length == 0) {
        form = getSpecialForm();
        if (form.length > 0) {
          is_login_form_loaded = true;
          is_login_button_is_clicked = true;
          sendSubmitButtonIsClickedOrNot();
          sendAjaxFormType("A6");
        } else {
          is_login_button_is_clicked = true;
          sendSubmitButtonIsClickedOrNot();
          sendAjaxFormType("A6, A7 or M");
        }
        detectLogin(e, form, true);
      } else {
        is_login_form_loaded = true;
        is_login_button_is_clicked = true;
        sendSubmitButtonIsClickedOrNot();
        sendLoginFormIsLoadedOrNot();
        detectLogin(e, form, false);
      }
    });
  }

  $("a").on('click', function (e) {
    if ($(selectors).has('a').length < 1) {
      var form = $(this).closest('form');
      if (form.length == 0) {
        form = getSpecialForm();
        if (form.length > 0) {
          is_login_form_loaded = true;
          is_login_button_is_clicked = true;
          sendSubmitButtonIsClickedOrNot();
          sendAjaxFormType("A6");
        } else {
          is_login_button_is_clicked = true;
          sendSubmitButtonIsClickedOrNot();
          sendAjaxFormType("A6, A7 or M");
        }
        detectLogin(e, form, true);
      } else {
        is_login_form_loaded = true;
        is_login_button_is_clicked = true;
        sendSubmitButtonIsClickedOrNot();
        sendLoginFormIsLoadedOrNot();
        detectLogin(e, form, false);
      }
    }
    is_form_detected = true;
  });
  if (window == window.top) {
    sendSubmitButtonIsClickedOrNot();
    sendLoginFormIsLoadedOrNot();
  }
}

function sendLoginFormIsLoadedOrNot() {
  if (is_login_form_loaded) {
    login_form_message = 'Login form has been loaded';
  }
  chrome.runtime.sendMessage({ 'directive': 'form-is-loaded', 'login_form_message': login_form_message }, function () { });
}

function sendSubmitButtonIsClickedOrNot() {
  if (is_login_button_is_clicked) {
    submit_button_message = 'Login button is clicked';
  }
  chrome.runtime.sendMessage({ 'directive': 'submit-button-is-clicked', 'submit_button_message': submit_button_message }, function () { });
}

function handleSubmitFormGoDaddy() {
  $("#submitBtn").click(function (e) {
    var username = $("input[id='username']").val();
    if (username != undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[id='username']").val();
      if (username != undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormPCoptimum() {
  $('.login-form button[type=submit]').on('click', function (e) {
    var username = $(".login-form #email").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $(".login-form #email").val();
      if (username != undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormPinterest() {
  var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
  var is_bind_event = false;
  var observer = new MutationObserver(function (mutations) {
    mutations.forEach(function (mutation) {
      if ($("#email").length > 0) {
        if (!is_bind_event) {
          document.getElementsByClassName("SignupButton")[0].addEventListener("click", function (e) {
            var username = $("#email").val();
            if (username !== undefined && username !== '') {
              getUrl(username, popup_page_url, "no form");
            }
          });
          is_bind_event = true;
        }
      }
    });
  });

  observer.observe(document, {
    childList: true,
    subtree: true
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("#email").val();
      if (username != undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormGmail() {
  var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
  var is_bind_event = false;
  var observer = new MutationObserver(function (mutations) {
    mutations.forEach(function (mutation) {
      if ($("input[name='password']").length > 0) {
        if (!is_bind_event) {
          if (document.getElementById('passwordNext') != null) {
            document.getElementById('passwordNext').addEventListener('click', function (e) {
              var username = $("input[name='identifier']").val();
              if (username !== undefined && username !== '') {
                getUrl(username, popup_page_url, "no form");
              }
            });
            is_bind_event = true;
          }
        }
      }
    });
  });

  observer.observe(document, {
    childList: true,
    subtree: true
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[name='identifier']").val();
      if (username != undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormMicrosoft() {
  $('input[value="Sign in"]').on('click', function (e) {
    var username = $("input[name='loginfmt']").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[name='loginfmt']").val();
      if (username != undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormAol() {
  $('#login-username-form input[type=submit]').on('click', function (e) {
    var username = $("input[name='username']").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[name='username']").val();
      if (username != undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormApple() {
  $("button[id='sign-in']").on('click', function (e) {
    var username = $("input[can-field='accountName']").val();
    var password = $("input[can-field='password']").val();
    if (password !== undefined && password !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[can-field='password']").val();
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormDropbox() {
  $("button[type='submit']").on('click', function (e) {
    var username = $("input[name='login_email']")[0].value;
    console.log(username);
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[name='login_email']")[0].value;
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormSpotify() {
  $("button[id='login-button']").on('click', function (e) {
    var username = $("input[id='login-username']").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[id='login-username']").val();
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormOkCupid() {
  // var elementClicked;
  console.log('Hoiiiiiii')
  $('div.login-actions').bind('click', function () {
    alert('i was clicked');
  });
  // $("document").on('click','.login-actions-button',function(){
  //   alert("element clicked");
  // });
  // if( elementClicked != true ) {
  //     alert("element not clicked");
  // }else{
  //     alert("element clicked");
  // }
  // console.log('new',$("button[type='submit']"));
  // $(".login-actions-button").click(function(e) {
  //   var username = $("input[id='username']").val();
  //   console.log(username);
  //   if (username !== undefined && username !== '')
  //   {
  //     getUrl(popup_page_url, "no form");
  //   }
  // });

  $(document).keypress(function (e) {
    console.log(e)
    if (e.which == "13") {
      var username = $("input[id='username']").val();
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormJetBlue() {
  $("button[type='submit']").on('click', function (e) {
    var username = $("input[type='email']").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[type='email']").val();
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormInstagram() {
  console.log($("button[type='submit']"));
  $("button[type='submit']").on('click', function (e) {
    var username = $("input[name='username']").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[name='username']").val();
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormHilton() {
  $("button[type='submit']").on('click', function (e) {
    var username = $("input[id='username']").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[id='username']").val();
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormBox() {
  $("button[id='login-submit-password']").on('click', function (e) {
    var username = $("input[id='password-login']").val();
    if (username !== undefined && username !== '') {
      getUrl(username, popup_page_url, "no form");
    }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[id='login-email']").val();
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}

function handleSubmitFormAirBnb() {
  $("input[id='phone-verification-code-form__code-input_codeinput_5']").on('click', function (e) {
    $("input[id='phone-verification-code-form__code-input_codeinput_5']")
    // if (username !== undefined && username !== '')
    // {
    getUrl(username, popup_page_url, "no form");
    // }
  });

  $(document).keypress(function (e) {
    if (e.which == "13") {
      var username = $("input[id='phone-verification-code-form__code-input_codeinput_5']").val();
      if (username !== undefined && username !== '') {
        getUrl(username, popup_page_url, "no form");
      }
    }
  });
}
