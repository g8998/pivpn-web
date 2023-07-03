function checkMobile() {
   var isMobile = false;
   if (navigator.userAgent.match(/Android/i)
      || navigator.userAgent.match(/webOS/i)
      || navigator.userAgent.match(/iPhone/i)
      || navigator.userAgent.match(/iPad/i)
      || navigator.userAgent.match(/iPod/i)
      || navigator.userAgent.match(/BlackBerry/i)
      || navigator.userAgent.match(/Windows Phone/i)) {
      isMobile = true;
   }
   if (isMobile) {
      document.body.classList.add('mobile');
   }
}

checkMobile();
