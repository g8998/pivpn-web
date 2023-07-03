function checkName() {
  var nameInput = document.getElementById("name").value;
  var closeBtn = document.getElementById("close-form");

  if (document.activeElement === closeBtn) {
    return true;
  }

  if (!nameInput.match(/[a-zA-Z0-9.@_-]/)) {
    showAlert("Name can only contain alphanumeric characters and these symbols (.-@_).");
    return false;
  } else if (nameInput.match(/^[0-9]+$/)) {
    showAlert("Names cannot be integers.");
    return false;
  } else if (nameInput.match(/\s|'/)) {
    showAlert("Names cannot contain spaces.");
    return false;
  } else if (nameInput.startsWith("-")) {
    showAlert("Name cannot start with - (dash).");
    return false;
  } else if (nameInput.startsWith(".")) {
    showAlert("Names cannot start with a . (dot).");
    return false;
  } else if (nameInput.length === 0) {
    showAlert("You cannot leave the name blank.");
    return false;
  }

  return true;
}

function showAlert(errorMessage) {
  alert(errorMessage);
}
