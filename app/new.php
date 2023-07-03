<?php
require_once 'auth.php';
?>
<?php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $name = $_POST["name"];
    $days = $_POST["days"];
    $password = $_POST["password"];

    if (empty($password)) {
        $command = "pivpn -a nopass -n ".$name." -d ".$days;
    } else {
        $command = "pivpn -a -n ".$name." -p ".$password." -d ".$days;
    }

    $output = shell_exec($command);

    $currentPath = rtrim(dirname($_SERVER['PHP_SELF']), '/');
    header("Refresh: 0; URL=$currentPath/../index.php");
}
?>
