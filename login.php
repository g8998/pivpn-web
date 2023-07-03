<?php
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = $_POST['user'];
    $password = $_POST['password'];

    $command = './app/script.sh "'.$user.'" "'.$password.'"';
    $output = shell_exec($command);

    if (trim($output) === 'Authenticated') {
        $_SESSION['Authenticated'] = true;
        header('Location: index.php');
        exit;
    } else {
        $errorMessage = 'Username or Password wrong';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>PiVPN</title>
    <link type="text/css" rel="stylesheet" href="css/login.css">
    <link rel="icon" type="image/png" sizes="64x64" href="img/pivpnlogo64.png">
</head>
<body>
   <p id="result"></p>
   <script src="js/mobile.js"></script>
<div class="container">
<?php if (isset($errorMessage)) : ?>
        <script>alert("<?php echo $errorMessage; ?>");</script>
<?php endif; ?>
  <div class="brand-logo"></div>
  <div class="brand-title">PiVPN<div class="version"> (OpenVPN v<?php echo shell_exec("openvpn --version | awk '/OpenVPN/ {print $2\")\"}' | head -n 1") ?></div></div>
<form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
  <div class="inputs">
        <input type="text" id="user" name="user" placeholder="Username" required><br>
        <input type="password" id="password" name="password" placeholder="Password">

        <input class="button" type="submit" value="Sign in">
  </div>
    </form>
<p><a target="_blank" href="https://github.com/g8998/pivpn-web">GITHUB</a><a> · </a>
  <a target="_blank" href="https://pivpn.io">PiVPN Project</a><a> · </a>
  <a target="_blank" href="https://buymeacoffee.com/g8998">Donate</a></p>
</div>

</body>
</html>
