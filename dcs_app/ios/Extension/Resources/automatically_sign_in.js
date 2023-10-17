const closeAutomaticallySignIn = () => {
  chrome.runtime.sendMessage({'directive': 'closeAutomaticallySignIn'});
}

document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('link-close-automatically-sign-in').addEventListener('click', closeAutomaticallySignIn);
  chrome.runtime.sendMessage({"directive": "getPPSignedInMessage"}, (response) => {
    $('#pp-signed-in-message').html(response.pp_is_signed_in_message);
  });
});