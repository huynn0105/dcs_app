function doNotSaveNow(){
  chrome.runtime.sendMessage({'directive': 'hide_iframe_success'}, function(response){});
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('link-close-iframe').addEventListener('click', doNotSaveNow);
  chrome.runtime.sendMessage({"directive": "get_institution"}, function(response){
    $('#institution_name').html(response.pdc_institution_name);
    $('#pdc_client_first_name').html(response.pdc_client_first_name);
  });
});