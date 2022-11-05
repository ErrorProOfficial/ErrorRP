$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            //Inventory.Close();
            break;
    }
});

var moneyTimeout = null;
var CurrentProx = 0;

(() => {
    QBHud = {};

    QBHud.Open = function(data) {
        $(".money-cash").css("display", "block");
        // $(".money-bank").css("display", "block");
        $("#cash").html(data.cash);
        // $("#bank").html(data.bank);
    };

    QBHud.Close = function() {

    };

    QBHud.Show = function(data) {
        if(data.type == "cash") {
            $(".money-cash").fadeIn(150);
            $("#cash").html(data.cash);
            setTimeout(function() {
                $(".money-cash").fadeOut(750);
            }, 3500)
        } 
    };

    QBHud.ToggleSeatbelt = function(data) {
        if (data.seatbelt) {
            //$(".car-seatbelt-info img").attr('src', './seatbelt-on.png');
        } else {
            //$(".car-seatbelt-info img").attr('src', './seatbelt.png');
        }
    };

    QBHud.ToggleHarness = function(data) {
        if (data.harness) {
            //$(".car-seatbelt-info").html('&nbsp;&nbsp;&nbsp;&nbsp;<span class="seatbelt-text">Колани</div>');
        } else {
            //$(".car-seatbelt-info").html('&nbsp;&nbsp;&nbsp;&nbsp;<img src="./seatbelt-on.png">');
        }
    }

    QBHud.CarHud = function(data) {
        if (data.show) {
            $(".ui-car-container").fadeIn();
            // $(".hnitrous").fadeIn(3000);
            //$("[data-voicetype='1']").animate({"top": "13.6vh"});
            //$("[data-voicetype='2']").animate({"top": "14vh"});
            //$("[data-voicetype='3']").animate({"top": "14.8vh"});
            //$("[data-voicetype='1']").animate({"left": "3.8vh"});
            //$("[data-voicetype='2']").animate({"left": "2.8vh"});
            //$("[data-voicetype='3']").animate({"left": "2vh"});

            //$('.hp-circle').animate({"top": "17.6vh"});
            //$('.armor-circle').animate({"top": "20.5vh"});
            //$('.food-circle').animate({"top": "14vh"});
            //$('.thirst-circle').animate({"top": "17.5vh"});
            //$('.stress-circle').animate({"top": "20.5vh"});

            //$('.hp-circle').animate({"left": "30.21vh"});
            //$('.armor-circle').animate({"left": "27.5vh"});
            //$('.food-circle').animate({"left": "2.9vh"});
            //$('.thirst-circle').animate({"left": "4.8vh"});
            //$('.stress-circle').animate({"left": "7.5vh"});

            //$(".ui-car-container").fadeOut();
            //$("[data-voicetype='1']").animate({"top": "2.4vh"});
           // $("[data-voicetype='2']").animate({"top": "2vh"});
            //$("[data-voicetype='3']").animate({"top": "2.4vh"});
            //$("[data-voicetype='1']").animate({"left": "2.5vh"});
            //$("[data-voicetype='2']").animate({"left": "1.35vh"});
            //$("[data-voicetype='3']").animate({"left": ".2vh"});

            //$('.food-circle').animate({"top": "22vh"});
            //$('.thirst-circle').animate({"top": "22vh"});
            //$('.stress-circle').animate({"top": "22vh"});

            //$('.hp-circle').animate({"left": "-2vh"});
            //$('.armor-circle').animate({"margin-left": "3.5vh"});
            //$('.food-circle').animate({"margin-left": "9vh"});
            //$('.thirst-circle').animate({"margin-left": "14.5vh"});
            //$('.stress-circle').animate({"margin-left": "20vh"});

            //$('.hp-circle').animate({"top": "22vh"});
            //$('.armor-circle').animate({"top": "22vh"});
        } else {
            $(".ui-car-container").fadeOut();
            //if (data.on) {
            // $('.hnitrous').fadeOut(3000);
            //}
            //$("[data-voicetype='1']").animate({ "top": "22vh"});
            //$("[data-voicetype='2']").animate({ "top": "22vh"});
            //$("[data-voicetype='3']").animate({ "top": "22vh"});
            //$("[data-voicetype='1']").animate({"left": "2.5vh"});
            //$("[data-voicetype='2']").animate({"left": "1.35vh"});
            //$("[data-voicetype='3']").animate({"left": ".2vh"});

            //$('.food-circle').animate({ "top": "22vh"});
            //$('.thirst-circle').animate({ "top": "22vh"});
            //$('.stress-circle').animate({ "top": "22vh"});

            //$('.hp-circle').animate({"left": "-2vh"});
            //$('.armor-circle').animate({"margin-left": "3.5vh"});
            //$('.food-circle').animate({"margin-left": "9vh"});
            //$('.thirst-circle').animate({"margin-left": "14.5vh"});
            //$('.stress-circle').animate({"margin-left": "20vh"});

            //$('.hp-circle').animate({ "top": "22vh"});
            //$('.armor-circle').animate({ "top": "22vh"});
        }
    };

    QBHud.UpdateHud = function(data) {
        var Show = "block";
        if (data.show) {
            Show = "none";
            $(".ui-container").css("display", Show);
            return;
        }
        $(".ui-container").css("display", Show);

        // HP Bar
        if (data.talking) {
            // if (data.onRadio) {
            //     $('.mic').css("stroke", '# #bb0000');
            // } else {
            //     $('.mic').css("stroke", '#ff8000');
            // }
            $('.mic').css("stroke", '#ff8000');
            ProgressVoip(data.talking, ".mic");
        } else {
            $('.mic').css("stroke", '#F5F5F5');
            let data = {'proxmity' : CurrentProx}
            QBHud.UpdateProximity(data)
        }
        Progress(data.health - 100, ".hp");
        if (data.health <= 195) {
            $('.hvida').fadeIn(3000);
        }
        if (data.health >= 196) {
            $('.hvida').fadeOut(3000);
        }
        if (data.health <= 145) {
            $('.vida').css("stroke", "red");
        } else {
            $('.vida').css("stroke", "#498949");
        }
        Progress(data.armor, ".armor");
        if (data.armor <= 95) {
            $('.harmor').fadeIn(3000);
        }
        if (data.armor >= 96) {
            $('.harmor').fadeOut(3000);
        }
        if (data.armor <= 45) {
            $('.amr').css("stroke", "lightblue");
        } else {
            $('.amr').css("stroke", "#248bbe");
        }
        Progress(data.hunger, ".hunger");
        if (data.hunger <= 95) {
            $('.hhunger').fadeIn(3000);
        }
        if (data.hunger >= 96) {
            $('.hhunger').fadeOut(3000);
        }
        if (data.hunger <= 45) {
            $('.fome').css("stroke", "red");
        } else {
            $('.fome').css("stroke", "#f0932b");
        }
        Progress(data.thirst, ".thirst");
        if (data.thirst <= 95) {
            $('.hthirst').fadeIn(3000);
        }
        if (data.thirst >= 96) {
            $('.hthirst').fadeOut(3000);
        }
        if (data.thirst <= 45) {
            $('.cede').css("stroke", "red");
        } else {
            $('.cede').css("stroke", "#3467d4");
        }
        Progress(data.stress, ".stress");
        if (data.stress >= 3) {
            $('.hstress').fadeIn(3000);
        }
        if (data.stress <= 2) {
            $('.hstress').fadeOut(3000);
        }
        // Progress(data.nivel, ".nitrous");
        // if (data.activo) {
        // $(".nitrous").css({"stroke":"#fcb80a"});
        // } else {
        // $(".nitrous").css({"stroke":"rgb(241, 71, 185)"});
        // }  
        
        let realOxygen = Math.floor(data.oxygen)
        Progress(realOxygen, ".oxygen");
        if (realOxygen <= 90) {
            $('.hoxygen').fadeIn(1000);
        }
        if (realOxygen >= 91) {
            $('.hoxygen').fadeOut(1000);
        }
        
        setProgressSpeed(data.speed, ".progress-speed");
        setProgressFuel(data.fuel, ".progress-fuel");
        //$('fuel').fadeIn(450);
        //Progress(data.fuel.toFixed(0), ".fuel");
        //$("#speed-amount").html(data.speed);

        if (data.seatbelt) {
            $(".car-seatbelt-info img").fadeOut(750);
        } else {
            $(".car-seatbelt-info img").fadeIn(750);
        }
    };

    QBHud.UpdateProximity = function(data) {
        let state = 100
        CurrentProx = data.proxmity
        switch(data.proxmity) {
            case 1:
                state = 33
                break;
            case 2:
                state = 66
                break;
            case 3:
                state = 100
                break;
            default:
                state = 100;
                break;
        }
        Progress(state, '.mic')
    }

    QBHud.SetTalkingState = function(data) {
        if (!data.IsTalking) {
            $(".voice-block").animate({"background-color": "#fc4e03"}, 150);
        } else {
            $(".voice-block").animate({"background-color": "rgb(255, 255, 255)"}, 150);
        }
    }

    QBHud.Update = function(data) {
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

    function ProgressVoip(percent, element) {
        var circle = document.querySelector(element);
        var radius = circle.r.baseVal.value;
        var circumference = radius * 200 * Math.PI;
      
        circle.style.strokeDasharray = `${circumference} ${circumference}`;
        circle.style.strokeDashoffset = `${circumference}`;
      
        const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
        circle.style.strokeDashoffset = -offset;
        
    }

    function Progress(percent, element) {
        var circle = document.querySelector(element);
        var radius = circle.r.baseVal.value;
        var circumference = radius * 2 * Math.PI;
      
        circle.style.strokeDasharray = `${circumference} ${circumference}`;
        circle.style.strokeDashoffset = `${circumference}`;
      
        const offset = circumference - ((-percent * 100) / 100 / 100) * circumference;
        circle.style.strokeDashoffset = -offset;
    }

    function setProgressSpeed(value, element){
        var circle = document.querySelector(element);
        var radius = circle.r.baseVal.value;
        var circumference = radius * 2 * Math.PI;
        var html = $(element).parent().parent().find('span');
        var percent = value*100/450;
    
        circle.style.strokeDasharray = `${circumference} ${circumference}`;
        circle.style.strokeDashoffset = `${circumference}`;
    
        const offset = circumference - ((-percent*73)/100) / 100 * circumference;
        circle.style.strokeDashoffset = -offset;
    
        html.text(value);
      }
      
      function setProgressFuel(percent, element) {
        var circle = document.querySelector(element);
        var radius = circle.r.baseVal.value;
        var circumference = radius * 2 * Math.PI;
        var html = $(element).parent().parent().find("span");
      
        circle.style.strokeDasharray = `${circumference} ${circumference}`;
        circle.style.strokeDashoffset = `${circumference}`;
      
        const offset = circumference - ((-percent * 73) / 100 / 100) * circumference;
        circle.style.strokeDashoffset = -offset;
      
        html.text(Math.round(percent));
      }

    window.onload = function(e) {
        $('.hnitrous').hide();
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case "open":
                    QBHud.Open(event.data);
                    break;
                case "close":
                    QBHud.Close();
                    break;
                case "update":
                    QBHud.Update(event.data);
                    break;
                case "show":
                    QBHud.Show(event.data);
                    break;
                case "hudtick":
                    QBHud.UpdateHud(event.data);
                    break;
                case "car":
                    QBHud.CarHud(event.data);
                    break;
                case "seatbelt":
                    QBHud.ToggleSeatbelt(event.data);
                    break;
                case "harness":
                    QBHud.ToggleHarness(event.data);
                    break;
                // case "nitrous":
                //     QBHud.UpdateNitrous(event.data);
                //     break;
                case "UpdateProximity":
                    QBHud.UpdateProximity(event.data);
                    break;
                case "talking":
                    QBHud.SetTalkingState(event.data);
                    break;
            }
        })
    }

})();


