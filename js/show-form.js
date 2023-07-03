var button = document.getElementById('show-form');
var button1 = document.getElementById('show-form1');
var popupOverlay = document.getElementById('popup-overlay');
var popup = document.getElementById('popup');
var closeButton = document.getElementById('close-form');

button.addEventListener('click', function() {
  popupOverlay.classList.remove('hidden');
  popup.classList.remove('hidden');
});

closeButton.addEventListener('click', function() {
  popupOverlay.classList.add('hidden');
  popup.classList.add('hidden');
  document.getElementById('form').reset();
});

button1.addEventListener('click', function() {
  popupOverlay.classList.remove('hidden');
  popup.classList.remove('hidden');
});
