// Environment: 'local': Local, 'dev': Dev, 'qa': QA, 'demo': Demo, 'production': Production, 'production_ca': Canada Production
var current_environment = "qa";
var be_environments = {
  "vagrant": "http://192.168.30.30:3000",
  "local": "http://localhost:3000",
  "dev": "https://dev.directivecommunications.com",
  "qa": "https://qa.directivecommunications.com",
  "demo": "https://demo.directivecommunications.com",
  "production": "https://app.directivecommunications.com",
  "production_ca": "https://app.directivecommunications.ca",
  "qa_ca": "https://qa.directivecommunications.ca",
  "demo_ca": "https://demo.directivecommunications.ca",
  "dev_ca": "https://dev.directivecommunications.ca",
};

var pdc_domain = be_environments[current_environment];
var current_browser = 'CHROME';
var pp_version = 'DCS Portfolio Plus 1.2.48';
var full_browser_version = navigator.userAgent;
var is_submit_enter_asking_browser_name = false;
var is_submit_bn = false;

function cancelLogin(e) {
  chrome.runtime.sendMessage({ directive: "cancel-login" }, function () {
    this.close();
  });
}

const submitLogin = (e) => {
  window.open("DCSPortfolioPlus://");
  // var email = $('#wad-email').val();
  // var password = $('#wad-password').val();
  // if (email === '' || password === '') {
  //   $("#login-form-error").html("Missing username or password.");
  //   $('#login-form-error').removeClass('hide');
  //   $('#login-form-error-2').addClass('hide');
  // } else if (!validateEmail(email)) {
  //   $("#login-form-error").html("Email format is not valid.");
  //   $('#login-form-error').removeClass('hide');
  //   $('#login-form-error-2').addClass('hide');
  // }
  // else {
  //   fetch(
  //     pdc_domain + "/api/v1/auth/authorize", {
  //     method: "POST",
  //     headers: { "Content-Type": "application/json;charset=UTF-8" },
  //     body: JSON.stringify({ "email": email, "password": password, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain })
  //   }
  //   ).then((response) => {
  //     if (!response.ok) {
  //       response.json().then((obj) => {
  //         if (response.status === 406 && obj['domain'].indexOf('http') > -1) {
  //           $('#link-signin').attr('href', obj['domain']);
  //           $('#login-form-error-2').removeClass('hide');
  //           $('#login-form-error').addClass('hide');
  //         } else {
  //           $('#login-form-error').removeClass('hide');
  //           $('#login-form-error').html(obj['message']);
  //           $('#login-form-error-2').addClass('hide');
  //         }
  //       });
  //     } else {
  //       response.json().then((obj) => {
  //         chrome.storage.local.set({ 'pdc_is_authoried': 'true' });
  //         chrome.storage.local.set({ 'pdc_client_token': obj['token'] });
  //         chrome.storage.local.set({ 'pdc_client_first_name': obj['first_name'] });
  //         chrome.storage.local.set({ 'pdc_session_name': obj['default_session_name'] });

  //         $('#link-first-name').html(obj['first_name']);
  //         $('#bn-first-name').html(obj['first_name']);
  //         $('#current-browser-name').html(obj['default_session_name']);
  //         $('#login-form').addClass('hide');
  //         $('#browser_name').val(obj['default_session_name']).prop('placeholder', obj['default_session_name']);
  //         $('#enter-browser-name-form .text-list .list-ct ul').empty();
  //         if (obj['browsers'] && (obj['browsers'].length > 0)) {
  //           $.each(obj['browsers'], function (i, v) {
  //             $('#enter-browser-name-form .text-list .list-ct ul').append('<li>' + v + '</li>');
  //           });
  //           $('#enter-browser-name-form .text-list').removeClass('hide');
  //         }
  //         $('#user-account-info').removeClass('hide');
  //         $('#enter-browser-name-form').removeClass('hide');
  //         setTimeout(function () {
  //           $('#browser_name').focus();
  //         }, 300);
  //       });
  //     }
  //   });
  // }
}

const logout = (e) => {
  chrome.storage.local.get(['pdc_client_token'], function (storage) {
    fetch(
      pdc_domain + "/api/v1/auth/sign_out", {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=UTF-8" },
      body: JSON.stringify({ "token": storage['pdc_client_token'], "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain })
    }
    ).then((response) => {
      if (response.ok) {
        console.log('sign out successfully');
      } else {
        console.log('sign out unsuccessfully');
      }
    });
    handleAfterSignOut();
  })
}

const forgotPassword = (e) => {
  $('#login-form').addClass('hide');
  $('#is_authoried').addClass('hide');
  $('#user-account-info').addClass('hide');
  $('#login-form-error').addClass('hide');
  $('#login-form-error-2').addClass('hide');
  $('#login-successful').addClass('hide');
  $('#reset-password-form').removeClass('hide');
  $('#div-quick-add').addClass('hide');
  $('#quick-add-form').addClass('hide');
  $('#wad-email-reset').focus();
}

const submitForgotPassword = (e) => {
  var email = $('#wad-email-reset').val();
  if (email === '') {
    $("#reset-password-form-error").html("Missing email address.");
    $('#reset-password-form-error').removeClass('hide');
  } else if (!validateEmail(email)) {
    $("#reset-password-form-error").html("Email format is not valid.");
    $('#reset-password-form-error').removeClass('hide');
  }
  else {
    fetch(
      pdc_domain + "/api/v1/passwords/reset", {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=UTF-8" },
      body: JSON.stringify({ "email": email, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain })
    }
    ).then((response) => {
      response.json().then((obj) => {
        if (response.ok) {
          $('#reset-password-form').addClass('hide');
          $('#reset-password-success-message').html(obj['message']);
          $('#reset-password-success').removeClass('hide');
        } else {
          $('#reset-password-form-error').removeClass('hide');
          $('#reset-password-form-error').html(obj['message']);
          $('#reset-password-success').addClass('hide');
        }
      })
    });
  }
}

const returnToLogin = (e) => {
  $('#reset-password-form').addClass('hide');
  $('#reset-password-success').addClass('hide');
  $('#login-form').removeClass('hide');
  $('#quick-add').addClass('hide');
}

const hideQuickAddForm = () => {
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
}

function signInFirstTime(e) {
  var href = this.href;
  chrome.tabs.create({ url: href });
}

const signInToDCS = (e) => {
  var href = pdc_domain;
  chrome.tabs.create({ url: href });
}

const validateEmail = (email) => {
  var reg = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
  return reg.test(email);
}

const quickAdd = (e) => {
  chrome.storage.local.get(['pdc_client_token', 'pdc_client_first_name', 'pdc_session_name'], (storage) => {
    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
      url = tabs[0].url;
      while (url.indexOf('|') > -1) {
        url = url.replace('|', '');
      }
      if (url.length > 255) {
        url = url.substring(0, 255);
      }
      page_title = tabs[0].title;
      if (url !== "") {
        fetch(
          pdc_domain + "/api/v1/accounts/query_url", {
          method: "POST",
          headers: { "Content-Type": "application/json;charset=UTF-8" },
          body: JSON.stringify({ "token": storage['pdc_client_token'], "url": url, "page_title": page_title, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain })
        }
        ).then((response) => {
          if (response.ok) {
            response.json().then((obj) => {
              $('#login-form').addClass('hide');
              $('#link-first-name').html(storage['pdc_client_first_name']);
              $('#current-browser-name').html(storage['pdc_session_name']);
              $('#is_authoried').removeClass('hide');
              $('#user-account-info').removeClass('hide');

              $("#div-quick-add").addClass('hide');
              $("#quick-add-form").removeClass('hide');
              $("#account-name").val(obj['original_name']);
              $("#account-name").focus();
              $("#account-url").val(obj['original_url']);
              chrome.storage.local.set({ 'pdc_original_name': obj['original_name'] })
              chrome.storage.local.set({ 'pdc_original_url': obj['original_name'] })
              chrome.storage.local.set({ 'pdc_is_irg': obj['pdc_is_irg'] })
              var height = 450;
              if (obj['is_irg'] === "yes") {
                if (!obj['account_number'] && !obj['username'] && !obj['email']) {
                  $("#div-account-number").removeClass('hide');
                  $("#div-account-username").removeClass('hide');
                  bindEmailToDropdownList(obj);
                }
                else {
                  if (obj['account_number'])
                    $("#div-account-number").removeClass('hide');
                  if (obj['username'])
                    $("#div-account-username").removeClass('hide');
                  if (obj['email'])
                    bindEmailToDropdownList(obj);
                }
              }
              else {
                $("#div-account-number").removeClass('hide');
                $("#div-account-username").removeClass('hide');
                bindEmailToDropdownList(obj);
              }
              $('body').height(height);
            })
          } else {
            response.json().then((obj) => {
              if ((response.status == 400 && obj['message'] === 'Token') || response.status == 401 || (response.status == 404 && obj['message'] === 'Invalid access token')) {
                chrome.storage.local.set({ 'pdc_is_authoried': 'false' })
                chrome.storage.local.set({ 'pdc_client_token': '' })
                logout();
                // alert("DCS Portfolio Plus\n\nFor security purposes your DCS Portfolio Plus session has expired. This is normal and is intended to protect your personal data.\n\nPlease click on the DCS Portfolio Plus icon in to top-right of your browser window and sign in to your DCS account.");
              }
              if (response.status == 400 && obj['message'] === 'Invalid host name') {
                alert("DCS Portfolio Plus\n\nInvalid Host Name.");
              }
            })
          }
        });
      } else {
        alert("DCS Portfolio Plus\n\nInvalid Host Name.");
      }
    });
  })
}

const bindEmailToDropdownList = (obj) => {
  $("#div-account-email").removeClass('hide');
  $("#select-account-email").html('');
  $("#select-account-email").append("<option value='' disabled='disabled' selected='selected'>Select email address</option>");
  email_list = obj['email_list'];
  for (i = 0; i < email_list.length; i++) {
    $("#select-account-email").append("<option value='" + email_list[i] + "'>" + email_list[i] + "</option>");
  }
  $("#select-account-email").append("<option value='add-another-email-address'>Add another email address</option>");
}

const addAccount = (is_confirm) => {
  chrome.storage.local.get(['pdc_original_name', 'pdc_original_url', 'pdc_is_irg', 'pdc_found_account_id', 'pdc_client_token',
    'pdc_found_account_id', 'pdc_is_authoried',], (storage) => {
      $("#div-add-account-error").addClass('hide');
      var has_error = false;
      if ($("#account-name").val() === "") {
        $("#account-name-error").removeClass('hide');
        has_error = true;
      } else {
        $("#account-name-error").addClass('hide');
      }

      if ($("#account-url").val() === "") {
        $("#account-url-error").removeClass('hide');
        has_error = true;
      } else {
        $("#account-url-error").addClass('hide');
      }

      if (!$("#div-input-account-email").hasClass('hide')) {
        if ($("#account-email").val() !== "" && !validateEmail($("#account-email").val())) {
          $("#account-email-error").removeClass('hide');
          has_error = true;
        } else {
          $("#account-email-error").addClass('hide');
        }
      }

      if (!has_error) {
        var account_name = $("#account-name").val();
        var account_url = $("#account-url").val();
        var account_number = $("#account-number").hasClass("hide") ? "" : $("#account-number").val();
        var account_username = $("#account-username").hasClass("hide") ? "" : $("#account-username").val();
        var account_email = "";
        if (!$("#div-account-email").hasClass('hide')) {
          if (!$("#div-input-account-email").hasClass('hide')) {
            account_email = $("#account-email").val();
          } else {
            account_email = $("#select-account-email").val();
            if (account_email === "add-another-email-address") {
              account_email = "";
            }
          }
        }
        var original_name = storage["pdc_original_name"];
        var original_url = storage["pdc_original_url"];
        var is_irg = storage["pdc_is_irg"];
        if (is_irg === "yes" && original_name !== account_name && original_name !== "") {
          is_irg = "no";
        }
        var found_account_id = storage['pdc_found_account_id'];
        fetch(
          pdc_domain + "/api/v1/accounts/create_quick_add_account", {
          method: "POST",
          headers: { "Content-Type": "application/json;charset=UTF-8" },
          body: JSON.stringify({
            "token": storage['pdc_client_token'], "account_name": account_name, "account_url": account_url, "account_number": account_number,
            "account_username": account_username, "account_email": account_email, "original_name": original_name, "original_url": original_url,
            "is_irg": is_irg, "is_confirm": is_confirm, "found_account_id": found_account_id,
            "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain
          })
        }
        ).then((response) => {
          if (response.ok) {
            response.json().then((obj) => {
              if (obj['success'] == false && obj['account_status'] === 'is_added') {
                $("#quick-add-form").addClass('hide');
                $("#div-quick-add-account").removeClass('hide');
                $("#div-add-account-error").addClass('hide');
                $("#is_authoried").html("You already have <strong>" + account_name + "</strong> in your DCS Portfolio. Are you sure you want to add another?");
                $("#login-successful").html("You already have <strong>" + account_name + "</strong> in your DCS Portfolio. Are you sure you want to add another?");
                chrome.storage.local.set({ 'pdc_found_account_id': obj['account_id'] });
              } else {
                chrome.storage.local.set({ 'pdc_original_name': '' });
                chrome.storage.local.set({ 'pdc_original_url': '' });
                chrome.storage.local.set({ 'pdc_is_irg': 'false' });
                chrome.storage.local.set({ 'pdc_found_account_id': '' });
                $("#quick-add-form").addClass('hide');
                $("#div-quick-add-account").addClass('hide');
                $("#div-add-account-error").addClass('hide');
                $("#is_authoried").addClass('hide');
                $("#login-successful").addClass('hide');
                $("#quick-add-successfully").removeClass('hide');
              }
              $('body').height(0);
            })
          } else {
            response.json().then((obj) => {
              if ((response.status == 400 && obj['message'] === 'Token') || response.status == 401 || (response.status == 404 && obj['message'] === 'Invalid access token')) {
                chrome.storage.local.set({ 'pdc_original_name': '' });
                chrome.storage.local.set({ 'pdc_original_url': '' });
                chrome.storage.local.set({ 'pdc_is_irg': 'false' });
                chrome.storage.local.set({ 'pdc_found_account_id': '' });
                logout();
                alert("DCS Portfolio Plus\n\nFor security purposes your DCS Portfolio Plus session has expired. This is normal and is intended to protect your personal data.\n\nPlease click on the DCS Portfolio Plus icon in to top-right of your browser window and sign in to your DCS account.");
              } else {
                $("#div-add-account-error").removeClass('hide');
              }
            })
          }
        });
      }
    })

}

const changeEmail = () => {
  var selected_email = $('#select-account-email').val();
  if (selected_email === "add-another-email-address") {
    $("#div-input-account-email").removeClass("hide");
    $("#account-email").removeClass("hide");
  } else {
    $("#div-input-account-email").addClass("hide");
    $("#account-email").val("");
    $("#account-email").addClass("hide");
    $("#account-email-error").addClass("hide");
  }
}

// Source is copied from: https://stackoverflow.com/questions/1026069/how-do-i-make-the-first-letter-of-a-string-uppercase-in-javascript
const capitalizeFirstLetter = (string) => {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

const is_present = (val) => {
  return ($.inArray(val, ['', null, undefined, NaN]) == -1)
}

const handleDeAuthorizeAll = () => {
  chrome.storage.local.get(['pdc_is_authoried', 'pdc_client_token'], function (storage) {
    if (is_submit_enter_asking_browser_name == false) {
      is_submit_enter_asking_browser_name = true;
      var is_authoried = storage['pdc_is_authoried'];
      var client_token = storage['pdc_client_token'];
      if ((is_authoried == 'true') && is_present(client_token)) {
        fetch(
          pdc_domain + "/api/v1/auth/deauthorize", {
          method: "POST",
          headers: { "Content-Type": "application/json;charset=UTF-8" },
          body: JSON.stringify({ "token": client_token, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain })
        }
        ).then((response) => {
          if (response.ok) {
            response.json().then((obj) => {
              $('#enter-browser-name-form .text-list').addClass('hide');
              $('#enter-browser-name-form .text-list .list-ct ul').empty();
              setTimeout(function () {
                $('#browser_name').focus();
              }, 200);
              is_submit_enter_asking_browser_name = false;
            });
          }
        });
      } else {
        is_submit_enter_asking_browser_name = false;
      }
    }
  })
}

const handleAfterSignOut = () => {
  chrome.storage.local.set({ 'pdc_is_authoried': 'false' })
  chrome.storage.local.set({ 'pdc_client_token': '' })
  chrome.storage.local.set({ 'pdc_session_name': '' })

  $('#login-form').removeClass('hide');
  $('#login-form-error').addClass('hide');
  $('#login-form-error-2').addClass('hide');
  $('#is_authoried').addClass('hide');
  $('#wad-password').val('');
  $('#user-account-info').addClass('hide');
  $('#login-successful').addClass('hide');
  $('#div-quick-add').addClass('hide');
  $('#quick-add-form').addClass('hide');
  $('#enter-browser-name-form').addClass('hide');
  $('#enter-browser-name-form .text-list').addClass('hide');
  hideQuickAddForm();
  $('#wad-email').focus();
  $('body').height(0);
}

const submitBrowserName = () => {
  chrome.storage.local.get(['pdc_is_authoried', 'pdc_client_token', 'pdc_client_first_name', 'pdc_session_name'], function (storage) {
    if (is_submit_bn == false) {
      is_submit_bn = true;
      var is_authoried = storage['pdc_is_authoried'];
      var client_token = storage['pdc_client_token'];
      var browser_name_val = $("#enter-browser-name-form #browser_name").val();
      if ((is_authoried == 'true') && is_present(browser_name_val) && is_present(client_token)) {
        fetch(
          pdc_domain + "/api/v1/auth/save_browser_name", {
          method: "POST",
          headers: { "Content-Type": "application/json;charset=UTF-8" },
          body: JSON.stringify({ 'browser_name': browser_name_val, "token": client_token, "current_browser": current_browser, "full_browser_version": full_browser_version, "pp_version": pp_version, "site": pdc_domain })
        }
        ).then((response) => {
          is_submit_bn = false;
          $('#enter-browser-name-form-error').html('').addClass('hide');

          if (response.ok) {
            response.json().then((obj) => {
              chrome.storage.local.set({ 'pdc_session_name': obj['browser_name'] })
              $('#link-first-name').html(storage['pdc_client_first_name']);
              $('#current-browser-name').html(storage['pdc_session_name']);
              $('#login-form').addClass('hide');
              $('#enter-browser-name-form').addClass('hide');
              $('#enter-browser-name-form .text-list').addClass('hide');
              $('#login-successful').html("<div class='form-text'>"
                + "<p class='portfolio-plus-heading'>Portfolio Plus</p>"
                + "<p class='login-success-message'>"
                + "<b>Thank you for signing in to your DCS account.</b>"
                + "</p>"
                + "<p class='login-success-message'>"
                + " When you visit your accounts or enroll in new websites, they can now automatically be added to your DCS portfolio."
                + "</p>"
                + "</div>");
              $('#login-successful').removeClass('hide');
              is_submit_enter_asking_browser_name = false;
              chrome.runtime.sendMessage({ directive: "closePPInstructions" });
            })
          } else {
            if (is_present(obj['browser_name'])) {
              storage['pdc_session_name'] = obj['browser_name'];
            } else {
              storage['pdc_session_name'] = '';
            }
            if (is_present(obj['message'])) {
              $('#enter-browser-name-form-error').html(obj['message']).removeClass('hide');
            }
          }
        });
      } else {
        is_submit_bn = false;
      }
    } else {
      is_submit_bn = false;
    }
  })
}

document.addEventListener('DOMContentLoaded', (e) => {

  browser.runtime.sendNativeMessage("application.id", { message: "authoried" }).then((res) => {
    if (!!res) {
      var responseData = JSON.parse(res);
      console.log(responseData);
      var email = responseData['email'];
      var token = responseData['token'];
      var username = responseData['username'];
      var defaultSessionName = responseData['defaultSessionName'];
      var browsersString = responseData['browsers'];
      chrome.storage.local.set({ 'pdc_is_authoried': 'true' })
      chrome.storage.local.set({ 'pdc_client_token': token })
      chrome.storage.local.set({ 'pdc_client_first_name': username })
      chrome.storage.local.set({ 'pdc_session_name': defaultSessionName })

      var browsers = JSON.parse(browsersString);
      if (browsers && (browsers.length > 0)) {
        $.each(browsers, function (i, v) {
          $('#enter-browser-name-form .text-list .list-ct ul').append('<li>' + v + '</li>');
        });
        $('#enter-browser-name-form .text-list').removeClass('hide');
      }
      $('#link-first-name').html(username);
      $('#bn-first-name').html(username);
      $('#current-browser-name').html(defaultSessionName);
      $('#login-form').addClass('hide');
      $('#browser_name').val(defaultSessionName).prop('placeholder', defaultSessionName);
      $('#enter-browser-name-form .text-list .list-ct ul').empty();
      quickAdd();
    } else {
      chrome.storage.local.set({ 'pdc_is_authoried': 'false' })
      chrome.storage.local.set({ 'pdc_client_token': '' })
      chrome.storage.local.set({ 'pdc_client_first_name': '' })
      chrome.storage.local.set({ 'pdc_session_name': '' })
      $('#login-form').removeClass('hide');
      $('#is_authoried').addClass('hide');
      $('#user-account-info').addClass('hide');
      $('#div-quick-add').addClass('hide');
      $('#wad-email').focus();
    }



    document.getElementById('btn-submit-login').addEventListener('click', submitLogin);
    document.getElementById('logout').addEventListener('click', logout);
    document.getElementById('link-forgot-password').addEventListener('click', forgotPassword);
    document.getElementById('btn-cancel-reset-password').addEventListener('click', cancelLogin);
    document.getElementById('btn-submit-reset-password').addEventListener('click', submitForgotPassword);
    document.getElementById('return-to-login').addEventListener('click', returnToLogin);
    document.getElementById('link-signin').addEventListener('click', signInFirstTime);
    document.getElementById('link-my-account').addEventListener('click', signInToDCS);
    document.getElementById('button-quick-add').addEventListener('click', quickAdd);
    document.getElementById('btn-add-account').addEventListener('click', function () { addAccount(false); }, false);
    document.getElementById('btn-add-account-confirm').addEventListener('click', function () { addAccount(true); }, false);
    document.getElementById('btn-cancel-quick-add').addEventListener('click', cancelLogin);
    document.getElementById('btn-cancel-quick-add-confirm').addEventListener('click', cancelLogin);
    document.getElementById('select-account-email').addEventListener('change', changeEmail);
    document.getElementById('btn-deauthorize-all').addEventListener('click', handleDeAuthorizeAll);
    document.getElementById('btn-submit-browser-name').addEventListener('click', submitBrowserName);

  })

});

$(document).keypress((e) => {
  if (e.which == "13") {
    if (!$('#login-form').hasClass('hide')) {
      submitLogin(e);
    } else if (!$('#reset-password-form').hasClass('hide')) {
      submitForgotPassword(e);
    } else if (!$('#enter-browser-name-form').hasClass('hide')) {
      submitBrowserName(e);
    }
  }
});
