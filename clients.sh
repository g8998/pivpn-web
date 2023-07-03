CDATE=$(date +"%y%m%d")

echo "<table><tr><th class='border-bottom' colspan='7'>Clients</th><th class='border-bottom'><button id='show-form' style='float:right' class='custom-btn-new btn'> + New </button></th></tr>"
IUSER=$(sudo cat /etc/pivpn/openvpn/setupVars.conf | grep install_user | sed s/install_user=//)
COMMAND=$(sudo cat /etc/openvpn/easy-rsa/pki/index.txt | grep '^V' | tail -n +2)

if [ -z $COMMAND ]; then
  echo "<tr><td colspan='8' style='text-align:center;'>No clients yet.</td></tr>"
  echo "<tr><td colspan='8' style='text-align:center;'><button id='show-form1' class='custom-btn-new btn'> + New Client</button></td></tr></table>"
else

sudo cat /etc/openvpn/easy-rsa/pki/index.txt | grep '^V' | tail -n +2 | while read -r line; do
    NAME=$(echo "$line" | awk -F'/CN=' '{print $2}')
    EXPD=$(echo "$line" | awk '{print $2}' | cut -b 1-6)

    if [ "$EXPD" -ge "$CDATE" ]; then
        EXPD_FORMATTED=$(date -d "20$EXPD" +"%b %d %Y")
        echo "<tr class='border-bottom'><td colspan='6'>$NAME ($EXPD_FORMATTED)"

	OUTPUT=$(sudo sed -n '4,$p' /var/log/openvpn-status.log | awk -v NAME="$NAME" '/CLIENT_LIST.*'"$NAME"'/ {
            split($3, addr, ":")
            print "<br><small>"addr[1]" · "$4" · <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"12\" height=\"12\" fill=\"currentColor\" class=\"bi bi-arrow-down\" viewBox=\"0 0 16 16\" id=\"IconChangeColor\" transform=\"scale(1, 1)\"> <path fill-rule=\"evenodd\" d=\"M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z\" id=\"mainIconPathAttribute\" stroke-width=\"0\" stroke=\"#ff0000\"></path> </svg> "$5" · <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"12\" height=\"12\" fill=\"currentColor\" class=\"bi bi-arrow-down\" viewBox=\"0 0 16 16\" id=\"IconChangeColor\" transform=\"scale(1, -1)\"> <path fill-rule=\"evenodd\" d=\"M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z\" id=\"mainIconPathAttribute\"></path> </svg> "$6" · <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"12\" height=\"12\" fill=\"currentColor\" class=\"bi bi-calendar-date\" viewBox=\"0 0 16 16\"> <path d=\"M6.445 11.688V6.354h-.633A12.6 12.6 0 0 0 4.5 7.16v.695c.375-.257.969-.62 1.258-.777h.012v4.61h.675zm1.188-1.305c.047.64.594 1.406 1.703 1.406 1.258 0 2-1.066 2-2.871 0-1.934-.781-2.668-1.953-2.668-.926 0-1.797.672-1.797 1.809 0 1.16.824 1.77 1.676 1.77.746 0 1.23-.376 1.383-.79h.027c-.004 1.316-.461 2.164-1.305 2.164-.664 0-1.008-.45-1.05-.82h-.684zm2.953-2.317c0 .696-.559 1.18-1.184 1.18-.601 0-1.144-.383-1.144-1.2 0-.823.582-1.21 1.168-1.21.633 0 1.16.398 1.16 1.23z\"/> <path d=\"M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z\"/> </svg> "$7" "$8"</small></td>"
        }')

	if [ -z "$OUTPUT" ]; then
	    echo "<br><small class=\"transparent\">-</small></td>"
	else
	    if grep -q "^#" /etc/openvpn/ccd/"$NAME"; then
	        echo "<br><small class=\"transparent\">-</small></td>"
	    else
	        echo "$OUTPUT"
	    fi
	fi


        echo "<td class='right'><a href=\"#\" id=\"toggleButton$NAME\"></a></td>"

        fileContent=$(sudo sed -n '2s/^\(.\).*/\1/p' /etc/openvpn/ccd/$NAME)

        echo "<script>"
        echo "document.addEventListener('DOMContentLoaded', function() {"
        echo "  var toggleButton$NAME = document.getElementById('toggleButton$NAME');"
        echo "  var firstCharacter = '$fileContent';"
        echo "  if (firstCharacter === '#') {"
        echo "    toggleButton$NAME.classList.add('inactive');"
        echo "  } else {"
        echo "    toggleButton$NAME.classList.add('active');"
        echo "  }"
        echo "});"
        echo "</script>"


        echo "<script>"
        echo "document.getElementById(\"toggleButton$NAME\").addEventListener(\"click\", function(event) {"
        echo "  event.preventDefault();"
        echo "  var toggleButton$NAME = document.getElementById(\"toggleButton$NAME\");"
        echo "  if (toggleButton$NAME.classList.contains(\"active\")) {"
        echo "    window.location.href = \"app/disable.php?file=$NAME\";"
        echo "  } else {"
        echo "    window.location.href = \"app/enable.php?file=$NAME\";"
        echo "  }"
        echo "});"
        echo "</script>"

        echo "<td class='right'><a class='custom-btn btn' href='app/download.php?file=$NAME.ovpn'><svg class='buttons-svg' xmlns=\"http://www.w3.org/2000/svg\" width=\"28\" height=\"100%\" fill=\"currentColor\" class=\"bi bi-download\" viewBox=\"0 0 16 16\"> <path d=\"M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z\"/> <path d=\"M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z\"/> </svg></a>"

	configFile=$(cat /home/$IUSER/ovpns/$NAME.ovpn)
	escapedConfigFile=$(echo "$configFile" | sed 's/</\&lt;/g; s/>/\&gt;/g')
	if [ -z "$escapedConfigFile" ]; then
	  escapedConfigFile="The file $NAME.ovpn does not exist or cannot be read."
	fi
	echo "<div id='divFileOverlay$NAME' class='hidden'></div>"
	echo "<div id='divFile$NAME' class='hidden'><h3 style='text-align: left'>Config File $NAME</h3><pre id='copy$NAME'>$escapedConfigFile</pre><button onclick=\"copyText('$NAME')\">Copy</button><button onclick=\"closeElements('divFile$NAME','divFileOverlay$NAME'); return false;\">Close</button></div>"
	echo "<a class='custom-btn btn' href='#' onclick=\"mostrarElements('divFile$NAME', 'divFileOverlay$NAME'); return false;\"><svg class='buttons-svg' width=\"28\" height=\"100%\" viewBox=\"0 0 24 24\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\" > <path d=\"M7 18H17V16H7V18Z\" fill=\"currentColor\" /> <path d=\"M17 14H7V12H17V14Z\" fill=\"currentColor\" /> <path d=\"M7 10H11V8H7V10Z\" fill=\"currentColor\" /> <path fill-rule=\"evenodd\" clip-rule=\"evenodd\" d=\"M6 2C4.34315 2 3 3.34315 3 5V19C3 20.6569 4.34315 22 6 22H18C19.6569 22 21 20.6569 21 19V9C21 5.13401 17.866 2 14 2H6ZM6 4H13V9H19V19C19 19.5523 18.5523 20 18 20H6C5.44772 20 5 19.5523 5 19V5C5 4.44772 5.44772 4 6 4ZM15 4.10002C16.6113 4.4271 17.9413 5.52906 18.584 7H15V4.10002Z\" fill=\"currentColor\" /> </svg></a>"

        echo "<script>"
        echo "  function copyText(copy) {"
        echo "    var pre = document.getElementById('copy' + copy);"
        echo "    var contingut = pre.innerText;"
        echo "    var tempInput = document.createElement('textarea');"
        echo "    tempInput.value = contingut;"
        echo "    document.body.appendChild(tempInput);"
        echo "    tempInput.select();"
        echo "    tempInput.setSelectionRange(0, 99999);"
        echo "    document.execCommand('copy');"
        echo "    document.body.removeChild(tempInput);"
        echo "    alert('Text copied!');"
        echo "  }"
        echo "</script>"

        echo "<script>"
	echo "function mostrarElements(name, overlay) {"
        echo "  var element = document.getElementById(name);"
	echo "  element.classList.remove('hidden');"
	echo "  var overlayElement = document.getElementById(overlay);"
	echo "  overlayElement.classList.remove('hidden');"
        echo "}"
	echo "function closeElements(close, overlay) {"
	echo "  var close = document.getElementById(close);"
        echo "  close.classList.add('hidden');"
	echo "  var overlayElement = document.getElementById(overlay);"
	echo "  overlayElement.classList.add('hidden');"
        echo "}"
	echo "</script>"

        echo "<a class='custom-btn btn' href='app/revoke.php?name=$NAME' onclick=\"return confirm('Are you sure to remove the user $NAME?')\"><svg class='buttons-svg' xmlns=\"http://www.w3.org/2000/svg\" width=\"28\" height=\"100%\" fill=\"currentColor\" class=\"bi bi-trash\" viewBox=\"0 0 16 16\"> <path d=\"M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z\"/> <path fill-rule=\"evenodd\" d=\"M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z\"/> </svg></a>"

        echo "</td></tr>"

    fi

done
fi
echo "</table>"


sudo cat /etc/openvpn/easy-rsa/pki/index.txt | grep '^V\|^E' | tail -n +2 | while read -r line; do
    NAME=$(echo "$line" | awk -F'/CN=' '{print $2}')
    EXPD=$(echo "$line" | awk '{print $2}' | cut -b 1-6)

    if [ "$EXPD" -lt "$CDATE" ]; then
	if [ "$first_line_printed" != "true" ]; then
            echo "<table><tr class='border-bottom-top'><th>Expired</th></tr>"
            first_line_printed="true"
        fi
        EXPD_FORMATTED=$(date -d "20$EXPD" +"%b %d %Y")
        echo "<tr><td class='border-bottom'>$NAME ($EXPD_FORMATTED)</td>"
        echo "<td class='border-bottom right'><a class='custom-btn btn' href='app/download.php?file=$NAME.ovpn'><svg class='buttons-svg' xmlns=\"http://www.w3.org/2000/svg\" width=\"28\" height=\"100%\" fill=\"currentColor\" class=\"bi bi-download\" viewBox=\"0 0 16 16\"> <path d=\"M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z\"/> <path d=\"M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z\"/> </svg></a>"
        configFile=$(cat /home/$IUSER/ovpns/$NAME.ovpn)
        escapedConfigFile=$(echo "$configFile" | sed 's/</\&lt;/g; s/>/\&gt;/g')
        echo "<div id='divFileOverlay$NAME' class='hidden'></div>"
        echo "<div id='divFile$NAME' class='hidden'><h3 style='text-align: left'>Config File $NAME</h3><pre id='copy$NAME'>$escapedConfigFile</pre><button onclick=\"copyText('$NAME')\">Copy</button><button onclick=\"closeElements('divFile$NAME','divFileOverlay$NAME'); return false;\">Close</button></div>"
        echo "<a class='custom-btn btn' href='#' onclick=\"mostrarElements('divFile$NAME', 'divFileOverlay$NAME'); return false;\"><svg class='buttons-svg' width=\"28\" height=\"100%\" viewBox=\"0 0 24 24\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\" > <path d=\"M7 18H17V16H7V18Z\" fill=\"currentColor\" /> <path d=\"M17 14H7V12H17V14Z\" fill=\"currentColor\" /> <path d=\"M7 10H11V8H7V10Z\" fill=\"currentColor\" /> <path fill-rule=\"evenodd\" clip-rule=\"evenodd\" d=\"M6 2C4.34315 2 3 3.34315 3 5V19C3 20.6569 4.34315 22 6 22H18C19.6569 22 21 20.6569 21 19V9C21 5.13401 17.866 2 14 2H6ZM6 4H13V9H19V19C19 19.5523 18.5523 20 18 20H6C5.44772 20 5 19.5523 5 19V5C5 4.44772 5.44772 4 6 4ZM15 4.10002C16.6113 4.4271 17.9413 5.52906 18.584 7H15V4.10002Z\" fill=\"currentColor\" /> </svg></a>"

        echo "<script>"
        echo "  function copyText(copy) {"
        echo "    var pre = document.getElementById('copy' + copy);"
        echo "    var contingut = pre.innerText;"
        echo "    var tempInput = document.createElement('textarea');"
        echo "    tempInput.value = contingut;"
        echo "    document.body.appendChild(tempInput);"
        echo "    tempInput.select();"
        echo "    tempInput.setSelectionRange(0, 99999);"
        echo "    document.execCommand('copy');"
        echo "    document.body.removeChild(tempInput);"
        echo "    alert('Text copied!');"
        echo "  }"
        echo "</script>"

        echo "<script>"
        echo "function mostrarElements(name, overlay) {"
        echo "  var element = document.getElementById(name);"
        echo "  element.classList.remove('hidden');"
        echo "  var overlayElement = document.getElementById(overlay);"
        echo "  overlayElement.classList.remove('hidden');"
        echo "}"
        echo "function closeElements(close, overlay) {"
        echo "  var close = document.getElementById(close);"
        echo "  close.classList.add('hidden');"
        echo "  var overlayElement = document.getElementById(overlay);"
        echo "  overlayElement.classList.add('hidden');"
        echo "}"
        echo "</script>"
        echo "<a class='custom-btn btn' href='app/revoke.php?name=$NAME' onclick=\"return confirm('Are you sure to remove the user $NAME?')\"><svg class='buttons-svg' xmlns=\"http://www.w3.org/2000/svg\" width=\"28\" height=\"100%\" fill=\"currentColor\" class=\"bi bi-trash\" viewBox=\"0 0 16 16\"> <path d=\"M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z\"/> <path fill-rule=\"evenodd\" d=\"M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z\"/> </svg></a>"
        echo "</td></tr>"
    fi
done

echo "</table>"
