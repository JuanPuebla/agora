{include file="agoraportal_user_menu.tpl" clientCode=$client.clientCode}
<h3>{gt text="Gestors del centre"}&nbsp;{$client.clientName}</h3>
{if $isAdmin}
{include file="agoraportal_admin_clientInfo.tpl"}
{/if}
{if $accessLevel eq 'comment'}
<div class="alert alert-info">
        {gt text='Els centres docents poden designar fins a <strong>quatre persones</strong> com a gestores dels serveis d\'Àgora del centre. En tot moment podran consultar la llista de gestors, així com l\'estat dels serveis sol·licitats.'}
    <br />
</div>
{/if}

{if $managers|@count gt 0}
<div class="form-horizontal">
    <h4>{gt text='Gestors dels serveis del centre'}</h4>
    <table class="table table-hover table-striped">
    <thead>
        <tr>
            <th>{gt text='Usuari'}</th>
            <th>{gt text='Esborra'}</th>
        </tr>
    </thead>
    <tbody>
        {foreach item="manager" from=$managers}
        <tr>
            <td width="120" class="actived">{$manager.managerUName}</td>
            {if $canDelegate || ($managers|@count eq 1 && $manager.state lt 1 && $accessLevel eq 'comment') || $accessLevel == 'add'}
            <td>
                {if $uname neq $manager.managerUName}
                {assign var='managerName' value=$manager.managerUName}
                <form id="deleteManager_{$manager.managerId}" action="{modurl modname='Agoraportal' type='user' func='deleteManager'}"  method="post" enctype="application/x-www-form-urlencoded">
                    <a onclick="deleteManager({$manager.managerId})" >
                        {img modname='core' src='14_layer_deletelayer.png' set='icons/extrasmall' __alt="Esborra" __title="Si cliqueu aquí $managerName deixarà de ser gestor/a"}
                    </a>
                    <input type="hidden" name="managerId" value="{$manager.managerId}" />
                </form>
                {else}
                &nbsp;
                {/if}
            </td>
            {/if}
        </tr>
        {/foreach}
        </tbody>
    </table>
</div>
{/if}

{if $canDelegate && $managers|@count lt 4}
<form id="addManager" class="z-form" action="{modurl modname='Agoraportal' type='user' func='addManager'}" method="post" enctype="application/x-www-form-urlencoded">
    <fieldset>
        <legend>{gt text='Afegeix un gestor'}</legend>
        <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
        <input type="hidden" name="clientCode" value="{$client.clientCode}" />
        <div class="z-formrow">
            <label for="managerUName">{gt text="Nom d'usuari <strong>XTEC</strong> del gestor"}:</label>
            <input name="managerUName" type="text" name="managerUName" />
        </div>
        <div class="z-formrow">
            <div class="z-warningmsg z-formnote">
                {gt text="Aviseu a l'usuari designat que a partir d'ara podrà gestionar els serveis del centre des d'aquest portal."}
            </div>
        </div>
        <div class="z-center">
            <span class="z-buttons">
                <a href="javascript:addManager();">
                    {img modname='core' src='button_ok.png' set='icons/small' __alt="Modifica" __title="Afegeix"}
                    {gt text="Afegeix"}
                </a>
            </span>
            <span class="z-buttons">
                {if $isAdmin}
                <a href="{modurl modname='Agoraportal' type='user' func='myAgora' clientCode=$client.clientCode}">
                    {img modname='core' src='button_cancel.png' set='icons/small' __alt="Cancel·la" __title="Cancel·la"}
                    {gt text="Cancel·la"}
                </a>
                {else}
                <a href="{modurl modname='Agoraportal' type='user' func='myAgora'}">
                    {img modname='core' src='button_cancel.png' set='icons/small' __alt="Cancel·la" __title="Cancel·la"}
                    {gt text="Cancel·la"}
                </a>
                {/if}
            </span>
        </div>
    </fieldset>
</form>
{/if}

<script>
    var _AGORAPORTALCONFIRMMANAGERDELETION = "{{gt text='Confirmeu que voleu esborrar el gestor.'}}";
    var _AGORAPORTALNOTUSERNAME = "{{gt text='No heu escrit el nom d\'usuari XTEC.'}}";
    var _AGORAPORTALUSERNAMENOTVALID = "{{gt text='No heu escrit un nom d\'usuari XTEC vàlid.'}}";
</script>
