var popup_page_urls = window.location.href;
var is_reload_content_script = false

if (popup_page_urls.indexOf("vine.co") > -1 )
{
  $("login-link").click(function(e){
    if (!is_reload_content_script){
      is_reload_content_script = true
      chrome.runtime.sendMessage({'directive': 'reload-contentscript', 'url': popup_page_urls});
    }
  });
}
else if (popup_page_urls.indexOf("tripadvisor") > -1 )
{
  $("li.login").click(function(e){
    if (!is_reload_content_script){
      is_reload_content_script = true
      chrome.runtime.sendMessage({'directive': 'reload-contentscript', 'url': popup_page_urls});
    }
  });
}
else if (popup_page_urls.indexOf("hulu") > -1){
  $(".login").click(function(e){
    if (!is_reload_content_script){
      is_reload_content_script = true
      chrome.runtime.sendMessage({'directive': 'reload-contentscript', 'url': popup_page_urls});
    }
  });
}
