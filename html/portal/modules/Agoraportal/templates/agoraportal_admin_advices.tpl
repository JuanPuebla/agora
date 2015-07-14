<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/jscal2.css" />
<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/border-radius.css" />
<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/agora/agora.css" />
<script type="text/javascript" src="modules/Agoraportal/javascript/calendar/jscal2.js"></script>
<script type="text/javascript" src="modules/Agoraportal/javascript/calendar/lang/ca.js"></script>
{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Envia avisos"}</h3>
    <form name="advicesForm" id="advicesForm" action="{modurl modname='Agoraportal' type='admin' func='advices'}" method="POST">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-8">
                    <div class="form-group">
                        <label for="message">{gt text="Missatge"}</label>
                        <textarea class="form-control" id="message" name="message" rows="18" width="100%">{$message}</textarea>
                    </div>
                    <div class="form-group">
                        <input type="checkbox" name="only_admins" id="only_admins" value="1" {if $only_admins eq "1"}checked{/if}>
                        <label for="only_admins">{gt text="Mostra només als administradors"}</label>
                    </div>
                    <div class="form-inline">
                        <div class="form-group">
                            <label for="date_start">{gt text="Des de: "}</label>
                            <input class="form-control" size="15" id="date_start" name="date_start"  value="{$date_start}"/>
                            <input class="btn btn-default" type="button" id="from_btn" value="..." /> {gt text="Format YYYYmmdd"}
                        </div>
                    </div>
                    <div class="form-inline">
                        <div class="form-group">
                            <label for="date_stop">{gt text="Fins a: "}</label>
                            <input class="form-control" size="15" id="date_stop" name="date_stop" value="{$date_stop}"/>
                            <input class="btn btn-default" type="button" id="to_btn" value="..." /> {gt text="Format YYYYmmdd"}
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    {include file="agoraportal_admin_service_filter.tpl"}
                </div>
            </div>
            <div class="row text-center">
                <input name="ask" type="hidden" value="Envia" />
                <button type="submit" class="btn btn-primary" name="queue">
                <span class="glyphicon glyphicon-send" aria-hidden="true"></span> {gt text='Envia'}</button>
            </div>
        </div>
</form>

<script type="text/javascript">
    var cal = Calendar.setup({
        onSelect	   : 	function(cal) { cal.hide() }
    });

    cal.manageFields("from_btn", "date_start", "%Y%m%d");
    cal.manageFields("to_btn", "date_stop", "%Y%m%d");
</script>

