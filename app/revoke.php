<?php
require_once 'auth.php';
?>
<?php
$name = $_GET['name'];

$output = shell_exec("pivpn -r -y $name");

if ($output) {
  ob_start();
  include_once 'index.php';
  $currentPath = rtrim(dirname($_SERVER['PHP_SELF']), '/');
  header("Refresh: 0; URL=$currentPath/../index.php");
} else {
  $logFilePath = '../logs/error.log';
  $errorMessage = 'Error revoking client: The client '.$name.' does not exist';
  file_put_contents($logFilePath, date('Y-m-d H:i:s') . ' - ' . $errorMessage . "\n", FILE_APPEND);

  echo $errorMessage;
}
ob_end_clean();
?>
