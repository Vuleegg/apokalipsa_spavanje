$(function(){
	$('body').hide()
	window.onload = (e) => {
        /* 'links' the js with the Nui message from main.lua */
		window.addEventListener('message', (event) => {
            //document.querySelector("#logo").innerHTML = " "
			var item = event.data;
			item.type == "ui" ? $('body').show() : $('body').hide()
			if (item !== undefined && item.type === "ui") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#container").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#container").hide();
                }
			}
			item.type == "ui2" ? $('body').show() : $('body').hide()
				if (item !== undefined && item.type === "ui2") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#container2").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#container2").hide();
                }
			}
			item.type == "ui3" ? $('body').show() : $('body').hide()
			if (item !== undefined && item.type === "ui3") {
                /* if the display is true, it will show */
				if (item.display === true) {
					$("#sleeptime").text(item.data);
                    $("#container3").show();
                     /* if the display is false, it will hide */
				} else{
                    $("#container3").hide();
                }
			}
		});
	};
});