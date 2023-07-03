<?php
require_once 'app/auth.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>PiVPN</title>
    <link type="text/css" rel="stylesheet" href="css/index.css">
    <link rel="icon" type="image/png" sizes="64x64" href="img/pivpnlogo64.png">
</head>
<body>
    <p id="result"></p>
    <script src="js/mobile.js"></script>
    <script src="js/checkName.js"></script>
    <nav>
        <a href="index.php"><img alt="PiVPN Logo" src="img/pivpnlogo64.png" width="32"></a>
        <h1>PiVPN <span class="version">(OpenVPN v<?php echo shell_exec("openvpn --version | awk '/OpenVPN/ {print $2\")\"}' | head -n 1") ?></span></h1>
        <button class="reload" onClick="window.location.reload();">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
                <path d="M13.5 2c-5.621 0-10.211 4.443-10.475 10h-3.025l5 6.625 5-6.625h-2.975c.257-3.351 3.06-6 6.475-6 3.584 0 6.5 2.916 6.5 6.5s-2.916 6.5-6.5 6.5c-1.863 0-3.542-.793-4.728-2.053l-2.427 3.216c1.877 1.754 4.389 2.837 7.155 2.837 5.79 0 10.5-4.71 10.5-10.5s-4.71-10.5-10.5-10.5z"/>
            </svg>
        </button>
        <form action="index.php" method="POST">
            <button class="logout" type="submit" name="logout">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-log-out">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
            </button>
        </form>
    </nav>
    <div class="container">
        <?php
        $output = shell_exec("/bin/sh clients.sh");
        echo $output;
        ?>
        <p>
            <a target="_blank" href="https://github.com/g8998/pivpn-web">GITHUB</a>
            <a> · </a>
            <a target="_blank" href="https://pivpn.io">PiVPN Project</a>
            <a> · </a>
            <a target="_blank" href="https://www.buymeacoffee.com/g8998">Donate</a>
        </p>
    </div>
    <div id="popup-overlay" class="hidden"></div>
    <div id="popup" class="hidden">
        <h3>New Client</h3>
        <form onsubmit="return checkName()" action="app/new.php" method="POST" id="form">
            <input type="text" id="name" name="name" placeholder="Name" required><br>
            <input type="number" id="days" name="days" min="1" max="3650" placeholder="Days" required><br>
            <input type="password" id="password" name="password" placeholder="Password (Optional)"><br>
            <button class="close" id="close-form">Close</button>
            <input class="submit" type="submit" value="Submit">
        </form>
    </div>
    <script src="js/show-form.js"></script>
</body>
</html>
