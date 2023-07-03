<?php
$file = $_GET['file'];

$command = "ip=\$(sudo sed -n 's/ifconfig-push \(.*\) .*/\\1/p' /etc/openvpn/ccd/".$file.") && sudo sed -i \"1s/.*/ifconfig-push 0.0.0.1 255.255.255.0/\" /etc/openvpn/ccd/".$file." && sudo sed -i \"\$ a\\#\$ip\" /etc/openvpn/ccd/".$file;

$output = shell_exec($command);

if ($output == null) {
  ob_start();
  include_once 'index.php';
  $currentPath = rtrim(dirname($_SERVER['PHP_SELF']), '/');
  header("Refresh:0, URL=$currentPath/../index.php");
} else {
    $logFilePath = '../logs/error.log';
    $errorMessage = 'Error disabling user: Check if the file '.$file.' exists in the directory "/etc/openvpn/ccd/" or if it has the necessary permissions.';

    file_put_contents($logFilePath, date('Y-m-d H:i:s') . ' - ' . $errorMessage . "\n", FILE_APPEND);

    echo $errorMessage;
}
ob_end_clean();
?>
