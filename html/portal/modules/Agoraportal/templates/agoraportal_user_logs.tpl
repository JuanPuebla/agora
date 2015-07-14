<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/jscal2.css" />
<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/border-radius.css" />
<link rel="stylesheet" type="text/css" href="modules/Agoraportal/javascript/calendar/css/agora/agora.css" />
<script type="text/javascript" src="modules/Agoraportal/javascript/calendar/jscal2.js"></script>
<script type="text/javascript" src="modules/Agoraportal/javascript/calendar/lang/ca.js"></script>

{include file="agoraportal_user_menu.tpl" clientCode=$client.clientCode}
<h3>{gt text="Registre d'accions fetes"}</h3>
{if $isAdmin}
    {include file="agoraportal_admin_clientInfo.tpl"}
{/if}
<div class="panel panel-default">
    <div class="panel-heading">{gt text="Filtra"}<span id="reload"></span></div>
    <div class="panel-body">
        <form class="form-inline" name="filterForm" id="filterForm">
            <div class="form-group">
                <label for="actionCode">{gt text="Filtra per tipus d'acció"}</label>
                <select class="form-control" name="actionCode" id="actionCode">
                    <option value="0">{gt text="Totes les accions"}</option>
                    <option value="1">{gt text="Afegir"}</option>
                    <option value="2">{gt text="Modificar"}</option>
                    <option value="3">{gt text="Eliminar"}</option>
                </select>
            </div>
            <div class="form-group">
                <label for="from_inpt">{gt text="Filtra per data"}</label>
                {gt text="des de: "}
                <input class="form-control" size="15" id="from_inpt" />
                <input class="btn btn-default" type="button" id="from_btn" value="..." />
                {gt text="fins a: "}
                <input class="form-control" size="15" id="to_inpt" />
                <input class="btn btn-default" type="button" id="to_btn" value="..." />
            </div>
            {if $isAdmin}
                <div class="form-group">
                    <label for="uname">{gt text="Filtra per nom d'usuari/ària"}</label>
                    <input class="form-control" type="text" name="uname" id="uname" size="20"/>
                </div>
            {else}
                <input type="hidden" name="uname" id="uname"/>
            {/if}
            <button class="btn btn-primary" type="button" onclick="logs(0,document.filterForm.actionCode.value,document.filterForm.from_inpt.value,document.filterForm.to_inpt.value,document.filterForm.uname.value,1)">
            <span class="glyphicon glyphicon-filter" aria-hidden="true"></span> Filtra
            </button>
        </form>
    </div>
</div>
<div id="logsContent" name="logsContent">
    {$logsContent}
</div>

<script type="text/javascript">
    var cal = Calendar.setup({
        onSelect	   : 	function(cal) { cal.hide() }
    });

    cal.manageFields("from_btn", "from_inpt", "%d-%m-%Y");
    cal.manageFields("to_btn", "to_inpt", "%d-%m-%Y");
</script>