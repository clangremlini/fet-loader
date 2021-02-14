function GetSelectedCheat()
{
    var radioValue = $("input[name='cheat']:checked").val();
    return radioValue;
}
function CheatButtonClicked()
{
    document.getElementById("inject_button").disabled = false;
    GetCheatStatus(GetSelectedCheat());
    GetCheatAbout(GetSelectedCheat());
}
function BypassButtonClicked()
{
    document.getElementById("bypass_button").disabled = true;
    document.getElementById("bypass_button").textContent = "Bypass enabled!";
    ahk.Bypass();
}
function setTheme(bodyColor, cheatButtonsColor, cheatBorderColor, bypassButtonColor, bypassBorderColor, injectButtonColor, injectBorderColor)
{
    $("body").css("background", bodyColor)
    // cheat buttons
    $(".btn-outline-primary").css("border-color", cheatBorderColor)
    $(".btn-outline-primary").css("color", cheatButtonsColor)
    //bypass
    $(".btn-bypass").css("border-color", bypassBorderColor)
    $(".btn-bypass").css("color", bypassButtonColor)
    //inject
    $(".btn-inject").css("border-color", injectBorderColor)
    $(".btn-inject").css("color", injectButtonColor)
}
function toggleTheme() {
    theme = document.body.style.getPropertyValue("background")
    theme_dark = "#333333"
    theme_light = "#fafafa"
    if (theme == "rgb(250, 250, 250)") {
        setTheme(theme_dark, "#FFFFFF", "#9b52be", "#28bca3", "#28bca3", "#9b52be", "#9b52be")
    } 
    else {
        setTheme(theme_light, "#000000", "#9b52be", "#28bca3", "#28bca3", "#9b52be", "#9b52be")
    }
}
function GetCheatStatus(cheat) {
    var status = parseINIString(inifile)["status"][cheat];
    console.log(status);
    if (status == "Use at own risk")
    {
      document.getElementById("shit").textContent = "Use at own risk";
      document.getElementById("cheatstatus").className = "text-warning";
    }
    if (status == "DETECT")
    {
      document.getElementById("shit").textContent = "DETECT";
      document.getElementById("cheatstatus").className = "text-danger";
    }
    if (status == "UNDETECT")
    {
      document.getElementById("shit").textContent = "UNDETECT";
      document.getElementById("cheatstatus").className = "text-success";
    }
    return
}
function GetCheatAbout(zaebalo) 
{
    var status = parseINIString(inifile)["info"][zaebalo];
    console.log(status);
    document.getElementById("shit228").textContent = status;
    return
}
