function closeAutomaticallySignIn(){
  chrome.runtime.sendMessage({'directive': 'closeAutomaticallySignIn'}, function(response){});
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('link-close-automatically-sign-in').addEventListener('click', closeAutomaticallySignIn);
  chrome.runtime.sendMessage({"directive": "getPPSignedInMessage"}, function(response){
    $('#pp-signed-in-message').html(response.pp_is_signed_in_message);
  });
});