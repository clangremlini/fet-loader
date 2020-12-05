function getText() {    
    var xmlHttp = new XMLHttpRequest();
    var linktomainfile = "https://github.com/clangremlini/fetloader-dll-repo/raw/main/cheats.ini";
    xmlHttp.open("GET", linktomainfile, false);
    xmlHttp.send(null);
    return xmlHttp.responseText;
  }
  
function parseINIString(data) {
  var regex = {
    section: /^\s*\[\s*([^\]]*)\s*\]\s*$/,
    param: /^\s*([\w\.\-\_]+)\s*=\s*(.*?)\s*$/,
    comment: /^\s*;.*$/
  };
  var value = {};
  var lines = data.split(/\r\n|\r|\n/);
  var section = null;
  for (x = 0; x < lines.length; x++) {
    if (regex.comment.test(lines[x])) {
      return;
    } else if (regex.param.test(lines[x])) {
      var match = lines[x].match(regex.param);
      if (section) {
        value[section][match[1]] = match[2];
      } else {
        value[match[1]] = match[2];
      }
    } else if (regex.section.test(lines[x])) {
      var match = lines[x].match(regex.section);
      value[match[1]] = {};
      section = match[1];
    } else if (lines.length == 0 && section) {//changed line to lines to fix bug.
      section = null;
    };
  }
  return value;
}