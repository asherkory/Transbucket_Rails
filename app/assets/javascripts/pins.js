$(document).ready(function() {
    $("#scope").multiSelect({
        afterSelect: function() {
            $("#submit-filter").trigger("click");
        }
    });

    $("#surgeon").multiSelect({
        afterSelect: function() {
            $("#submit-filter").trigger("click");
        }
    });

    $("#procedure").multiSelect({
        afterSelect: function() {
            $("#submit-filter").trigger("click");
        }
    });

    $('.label-with-popover').popover();
});