$(function () {
	window.addEventListener("message", function (event) {
        if (event.data.action == "Status"){
            let Health = event.data.Health
            let Armor = event.data.Armor
            if (Health < 0){
                Health = 0
            }
            if (Armor < 0){
                Armor = 0
            }
            $(".health filter").attr("width", Health+"%")
            $(".armor filter").attr("width", Armor+"%")
            $(".health .text span").text(Health);
            $(".armor .text span").text(Armor);
            $(".ammo span").text(event.data.Ammo)
            if (!event.data.Armed){
                $(".ammo").fadeOut()
            }else if (event.data.Armed){
                $(".ammo").fadeIn()
            }

        }
    });
});

