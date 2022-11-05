var moneyTimeout = null;
var AddedBlood = false;

Show = function(data) {
    if(data.type == "cash") {
        $(".money-cash").fadeIn(150);
        $("#cash").html(data.cash);
        setTimeout(function() {
            $(".money-cash").fadeOut(750);
        }, 3500)
    }
};

Update = function(data) {
    if(data.type == "cash") {
        $(".money-cash").css("display", "block");
        $("#cash").html(data.cash);
        if (data.minus) {
            $(".money-cash").append('<p class="moneyupdate minus">-<span id="cash-symbol">&euro;&nbsp;</span><span><span id="minus-changeamount">' + data.amount + '</span></span></p>')
            $(".minus").css("display", "block");
            setTimeout(function() {
                $(".minus").fadeOut(750, function() {
                    $(".minus").remove();
                    $(".money-cash").fadeOut(750);
                });
            }, 3500)
        } else {
            $(".money-cash").append('<p class="moneyupdate plus">+<span id="cash-symbol">&euro;&nbsp;</span><span><span id="plus-changeamount">' + data.amount + '</span></span></p>')
            $(".plus").css("display", "block");
            setTimeout(function() {
                $(".plus").fadeOut(750, function() {
                    $(".plus").remove();
                    $(".money-cash").fadeOut(750);
                });
            }, 3500)
        }
    }
};

UpdateHud = function(data){
    if (!data.show) {
      $(".ui-container").css("display", "block");
    } else {
      $(".ui-container").css("display", "none");
      return;
    }

    $(".ui-healthbar").find('.hud-barfill').css("height", data.health - 100 + "%");
    $(".ui-armorbar").find('.hud-barfill').css("height", data.armor + "%");
    $(".ui-foodbar").find('.hud-barfill').css("height", data.hunger + "%");
    $(".ui-waterbar").find('.hud-barfill').css("height", data.thirst + "%");
    $(".ui-stressbar").find('.hud-barfill').css("height", data.stress + "%");

    $(".VehicleInfo-Street").html(data.street);
    $(".VehicleInfo-Zone").html(data.zone);

    if (data.health - 100 <= 35) {
        $(".ui-healthbar").find('.hud-barfill').addClass("Low");
        if (!AddedBlood) {
            AddedBlood = true
            $.post('http://turbo-hud/SetBlood', JSON.stringify({
                Bool: true
            }));
        }
    } else {
        $(".ui-healthbar").find('.hud-barfill').removeClass("Low");
        if (AddedBlood) {
            AddedBlood = false
            $.post('http://turbo-hud/SetBlood', JSON.stringify({
                Bool: false
            }));
        }
    }

    if (data.armor <= 35) {
        $(".ui-armorbar").find('.hud-barfill').addClass("Low");
    } else {
        $(".ui-armorbar").find('.hud-barfill').removeClass("Low");
    }

    if (data.hunger <= 35) {
        $(".ui-foodbar").find('.hud-barfill').addClass("Low");
    } else {
        $(".ui-foodbar").find('.hud-barfill').removeClass("Low");

    }

    if (data.thirst <= 35) {
        $(".ui-waterbar").find('.hud-barfill').addClass("Low");
    } else {
        $(".ui-waterbar").find('.hud-barfill').removeClass("Low");

    }

    if (data.talking && data.radio) {
        $(".voice-block").css({"background-color": "#c56127"}); 
    } else if (data.talking) {
        $(".voice-block").css({"background-color": "#bace4e"}); 
    } else {
        $(".voice-block").css({"background-color": "rgb(138, 138, 138)"}); 
    }

    if (data.seatbelt) {
        $(".Car-Belt img").fadeOut(750);
    } else {
        $(".Car-Belt img").fadeIn(750);
    }

    $("#Speed-Number").html(data.speed);
    $("#Fuel-Number").html(data.fuel);
    $('.time-text').html(data.hour + ':' + data.minute);
}

UpdateProximity = function(data) {
    if (data.prox == 1) {
        $("[data-voicetype='1']").fadeIn(150);
        $("[data-voicetype='2']").fadeOut(150);
        $("[data-voicetype='3']").fadeOut(150);
    } else if (data.prox == 2) {
        $("[data-voicetype='1']").fadeIn(150);
        $("[data-voicetype='2']").fadeIn(150);
        $("[data-voicetype='3']").fadeOut(150);
    } else if (data.prox == 3) {
        $("[data-voicetype='1']").fadeIn(150);
        $("[data-voicetype='2']").fadeIn(150);
        $("[data-voicetype='3']").fadeIn(150);
    }
}

ToggleMapBorder = function(data) {
    if (data.bool) {
        $('.hud-container').animate({"bottom": "20vh"}, 450, function() {
            $('.MapBorder').fadeIn(350)
            $('.VehicleContainer').fadeIn(350)
        });
    } else {
        $('.MapBorder').fadeOut(350, function() {
            $('.VehicleContainer').fadeOut(350)
            $('.hud-container').animate({"bottom": ".2vh"});
        });
    }
};

window.addEventListener('message', function(event) {
 switch(event.data.action) {
     case "update":
         Update(event.data);
         break;
     case "show":
         Show(event.data);
         break;
     case "carhud":
         ToggleMapBorder(event.data);
         break;
     case "UpdateProximity":
         UpdateProximity(event.data);
         break;
     case "UpdateHud":
         UpdateHud(event.data);
         break;
 }
});

window.onload = function(e) {
    $('.MapBorder').fadeOut(450)
    $('.VehicleContainer').fadeOut(350)
}