{include file="agoraportal_user_menu.tpl" clientCode=$client.clientCode}
{ajaxheader modname=Agoraportal filename=Agoraportal.js}
{pageaddvar name='stylesheet' value='system/Admin/style/admin.css'}

<h3>{gt text="Sol·licituds del centre"}&nbsp;{$client.clientName}</h3>
<div class="panel panel-default">
    <div class="panel-heading">{gt text='Sol·licituds disponibles'}</div>
    <div class="panel-body">
        <form id="addRequest" name="addRequest" class="form-inline" action="{modurl modname='Agoraportal' type='user' func='addRequest'}" method="post" enctype="application/x-www-form-urlencoded">
            <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
            <input type="hidden" id="clientId" name="clientId" value="{$client.clientId}" />
            <input type="hidden" id="clientCode" name="clientCode" value="{$client.clientCode}" />

            <div class="form-group">
                <label for="requestFilter">{gt text="Sol·licitud"}</label>
                <select class="form-control" id="requestFilter" name="requestFilter" onchange="showServices($('requestFilter').value);">
                    <option value="0">{gt text="Tria una sol·licitud"}</option>
                    {foreach item=type from=$types}
                    <option value="{$type.requestTypeId}">{$type.name}</option>
                    {/foreach}
                </select>
            </div>

            <div id="menuservices" class="form-group"></div>

            <div id="usermessage" style="margin-top:10px;"></div>
    </form>
    </div>
</div>

{if not empty($requests)}
<table class="table table-hover table-striped">
    <thead>
        <tr>
            <th>{gt text="Ha enviat"}</th>
            <th>{gt text="Data"}</th>
            <th>{gt text="Estat"}</th>
            <th>{gt text="Tipus"}</th>
            <th>{gt text="Servei"}</th>
            <th>{gt text="Resposta dels administradors"}</th>
            <th>{gt text="Darrera modificació"}</th>
        </tr>
    </thead>
    <tbody>
        {foreach item=client from=$requests}
        <tr id="formRow_{$client.clientId}">
            <td>{$client.username}</td>
            <td>{$client.timeCreated|dateformat:"%d/%m/%Y"}</td>
            <td>{$client.state}</td>
            <td>{$client.type}</td>
            <td><img src="modules/Agoraportal/images/{$client.serviceName}.gif" alt="{$client.serviceName}" title="{$client.serviceName}"/></td>
            <td>{$client.adminComments}</td>
            <td>{$client.timeClosed|dateformat:"%d/%m/%Y"}</td>
        </tr>
        {/foreach}
    </tbody>
</table>
{/if}
