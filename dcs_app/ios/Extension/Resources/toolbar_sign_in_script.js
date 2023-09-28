var is_submit = false;
var is_submit_browser_name_sgnb = false;
var is_submit_deauthorize_all = false;
chrome.runtime.onMessage.addListener(function(request, sender, callback){
  switch (request.directive) {
    case 'show_error_when_sign_in_from_bar':
      if(request){
        is_submit = false;
        if (request.request_status == 406 && is_present(request.response_domain) && request.response_domain.indexOf('http') > -1){
          $('.custom-pop-si-extension #link-signin').attr('href', request.response_domain);
          $('.custom-pop-si-extension #login-form-error-2').removeClass('hide');
          $('.custom-pop-si-extension #login-form-error').addClass('hide');
        }else if (request.request_status == 404){
          // THIS IS HARD CODE FOR CASE 404 TO DISPLAY DIFFERENT ERROR MESSAGE
          // BECAUSE FOR NOW: WHEN AN ERROR 404 MESSAGE INCLUDE "Forgot your password" link into the error
          $('.custom-pop-si-extension #login-form-error').removeClass('hide');
          $('.custom-pop-si-extension #login-form-error').html('Sorry, we could not find the Username/Password combination you entered');
          $('.custom-pop-si-extension #login-form-error-2').addClass('hide');
        }else{
          $('.custom-pop-si-extension #login-form-error').removeClass('hide');
          $('.custom-pop-si-extension #login-form-error').html(request.response_message);
          $('.custom-pop-si-extension #login-form-error-2').addClass('hide');
        }
      }
      break;
    case 'show_asking_browser_name_bar':
      $('#sign_in_bar_content').addClass('hide');
      $('#sgnb_first_name').html(localStorage['pdc_client_first_name']);
      $('#sgnb_browser_name').val(localStorage['pdc_session_name']).prop('placeholder', localStorage['pdc_session_name']);
      $('.sgnb-form-ask-browser-name .text-list').addClass('hide');
      $('.sgnb-form-ask-browser-name .text-list .list-ct ul').empty();
      if(request.browsers && (request.browsers.length > 0)){
        $.each(request.browsers, function(i, v) {
          $('.sgnb-form-ask-browser-name .text-list .list-ct ul').append('<li>' + v + '</li>');
        });
        $('.sgnb-form-ask-browser-name .text-list').removeClass('hide');
      }
      $('#sgnb_ask_browser_name_content').removeClass('hide');
      setTimeout(function(){
        $('#sgnb_browser_name').focus();
      }, 300);
      break;
    case 'show_error_when_save_browser_name_from_bar':
      is_submit_browser_name_sgnb = false;
      if(is_present(request.response_message)){
        $('#sgnb-browser-name-error').html(request.response_message).removeClass('hide');
      }else{
        $('#sgnb-browser-name-error').html('').addClass('hide');
      }
      break;
    case 'hide_browser_list':
      $('.sgnb-form-ask-browser-name .text-list').addClass('hide');
      $('.sgnb-form-ask-browser-name .text-list .list-ct ul').empty();
      setTimeout(function(){
        $('#sgnb_browser_name').focus();
      }, 300);
      break;
  }
});

function closeSignInBar(){
  chrome.runtime.sendMessage({'directive': 'hide_sign_in_iframe'}, function(response){});
}

function validateEmail(email){
  var reg = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
  return reg.test(email);
}

function submitSignInFormFromBar(){
  var email = $('#fb-email').val();
  var password = $('#fb-password').val();
  if (email === '' || password === '')
  {
    $(".custom-pop-si-extension #login-form-error").html("Missing username or password.");
    $('.custom-pop-si-extension #login-form-error').removeClass('hide');
    $('.custom-pop-si-extension #login-form-error-2').addClass('hide');
  }else if (!validateEmail(email)){
    $(".custom-pop-si-extension #login-form-error").html("Email format is not valid.");
    $('.custom-pop-si-extension #login-form-error').removeClass('hide');
    $('.custom-pop-si-extension #login-form-error-2').addClass('hide');
  }
  else{
    if (is_submit == false){
      chrome.runtime.sendMessage({"directive": "submit_sign_in_form_from_bar", email: email, password: password}, function(response){});
      is_submit = true;
    }
  }
}

function handleMessageDisplay(pdc_sign_in_type){
  switch (pdc_sign_in_type) {
    case 'token_expired':
      $('.custom-pop-si-extension .token-expired-message').removeClass('hide');
      $('.custom-pop-si-extension .user-never-sign-in-message').addClass('hide');
      break;
    case 'never_sign_in':
      $('.custom-pop-si-extension .token-expired-message').addClass('hide');
      $('.custom-pop-si-extension .user-never-sign-in-message').removeClass('hide');
      break;
    default:
      $('.custom-pop-si-extension .token-expired-message').addClass('hide');
      $('.custom-pop-si-extension .user-never-sign-in-message').addClass('hide');
      break;
  }
}

function is_present(val){
  return ($.inArray(val, ['', null, undefined, NaN]) == -1)
}

function handleDeAuthorizeAll(){
  if(is_submit_deauthorize_all == false){
    is_submit_deauthorize_all = true;
    chrome.runtime.sendMessage({"directive": "deauthorize_all_browsers_from_bar"}, function(response){});
  }
}

function handleSubmitBrowserName(){
  var browser_name = $('#sgnb_browser_name').val();
  if(is_present(browser_name)){
    $(".custom-pop-si-extension #sgnb-browser-name-error").html('').addClass('hide');
    if(is_submit_browser_name_sgnb == false){
      is_submit_browser_name_sgnb = true;
      chrome.runtime.sendMessage({"directive": "save_browser_name_from_bar", browser_name: browser_name}, function(response){});
    }
  }else{
    $(".custom-pop-si-extension #sgnb-browser-name-error").html("Missing browser name.").removeClass('hide');
  }
}

document.addEventListener('DOMContentLoaded', function () {
  handleMessageDisplay(localStorage['pdc_sign_in_type']);
  document.getElementById('btn-submit-login-fb').addEventListener('click', submitSignInFormFromBar);
  document.getElementById('link-close-iframe').addEventListener('click', closeSignInBar);
  document.getElementById('link-close-iframe-sgnb').addEventListener('click', closeSignInBar);
  document.getElementById('btn-deauthorize-all-sgnb').addEventListener('click', handleDeAuthorizeAll);
  document.getElementById('btn-submit-browser-name-sgnb').addEventListener('click', handleSubmitBrowserName);
});

$(document).keypress(function(e) {
  if (e.which == "13") {
    if (!$('#sign_in_bar_content').hasClass('hide')){
      submitSignInFormFromBar(e);
    }else if (!$('#sgnb_ask_browser_name_content').hasClass('hide')){
      handleSubmitBrowserName(e);
    }
  }
});