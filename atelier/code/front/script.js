document.getElementById('getProverb').addEventListener('click', function() {
  fetch('https://<url-api-gateway>/prod/proverb')
    .then(response => response.json())
    .then(data => {
      document.getElementById('proverb').textContent = data.proverb;
    })
    .catch(error => console.error('Erreur:', error));
});
