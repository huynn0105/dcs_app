var is_submit = false;

function doNotSaveNow(){
  chrome.runtime.sendMessage({'directive': 'hide_iframe'}, function(response){});
}


function save(){
  if (is_submit == false){
    chrome.runtime.sendMessage({'directive': 'save_account', 'submit_type': 'save'}, function(response){
    });
    is_submit = true;
  }
}

function neverSave(){
  if (is_submit == false){
    chrome.runtime.sendMessage({'directive': 'save_account', 'submit_type': 'ignore'}, function(response){
    });
    is_submit = true;
  }
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('btn-not-now').addEventListener('click', doNotSaveNow);
  document.getElementById('btn-save').addEventListener('click', save);
  document.getElementById('btn-never').addEventListener('click', neverSave);
  document.getElementById('link-close-iframe').addEventListener('click', doNotSaveNow);
  chrome.runtime.sendMessage({"directive": "get_institution"}, function(response){
    $('#institution_name').html(response.pdc_institution_name);
    $('#pdc_client_first_name').html(response.pdc_client_first_name);
    let account_size = response.existing_accounts.length;
    if (account_size > 0){
      if (account_size == 1){
        $('#existing-accounts-message').html("There is 1 " + response.pdc_institution_name + " account in this profile:");
      }else{
        $('#existing-accounts-message').html("There are " + account_size + " " + response.pdc_institution_name + " accounts in this profile:");
      }
      let list_accounts = '';
      $.each(response.existing_accounts, function(index, value){
        if (index == account_size - 1){
          list_accounts += "<span>" + value + "</span>";
        }else{
          list_accounts += "<span>" + value + "</span>" + ", ";
        }
      });
      $('#existing-accounts').html(list_accounts);
      $('.existing-content').removeClass('hide');
    }
  });
});