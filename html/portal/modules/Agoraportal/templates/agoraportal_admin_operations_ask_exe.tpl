{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Operació"} {$actionselect} a {$serviceName}</h3>
<div class="panel panel-info">
    <div class="panel-heading">{gt text="Operació a encuar:"} <strong>{$actionselect}</strong></div>
    <div class="panel-body">
        <div><strong>Prioritat:</strong>
            {if $priority < 0} Nocturna {/if} {$priority}
        </div>
        <div><strong>{gt text="Paràmetres de la operació:"}</strong>
            <ul>
            {foreach key=paramkey item=param from=$params}
                <li><strong>{$paramkey}</strong> = {$param}</li>
            {/foreach}
            </ul>
        </div>
    </div>
</div>
<div class="panel panel-default">
    <div class="panel-heading">
        <img src="modules/Agoraportal/images/{$serviceName}.gif" alt="{$serviceName}" title="{$sserviceName}" />
        {gt text="Espais on s'executa"}
    </div>
    <div class="panel-body">
    {if $which eq "all"}
        {gt text="Tots"}
    {else}
        <ul class="list-unstyled">
        {foreach item=client from=$sqlClients}
            <li>{$client.clientName}, {$client.clientCode}</li>
        {/foreach}
        </ul>
    {/if}
    </div>
</div>
<form action="index.php?module=Agoraportal&type=admin&func=operations" method="POST">
    <div class="hidden">
        <input type="hidden" name="which" value="{$which}">
        <input name="service_sel" type="hidden" value={$service_sel} />
        {if $which eq "selected"}
        <select name="clients_sel[]" multiple="multiple">
            {foreach item=client from=$clients}
            <option value="{$client.clientId}" selected>{$client.clientId}</option>
            {/foreach}
        </select>
        {/if}
        {foreach key=paramkey item=param from=$params}
            <input type="hidden" name="parm_{$paramkey}" value="{$param}">
        {/foreach}
        <input type="hidden" name="priority" value="{$priority}">
        <input type="hidden" name="actionselect" value="{$actionselect}">
    </div>
    <label>{gt text="Esteu segurs?"}</label>
    <input class="btn btn-success" name="confirm" value="{gt text='Sí'}" type="submit" />
    <input class="btn btn-danger" value="{gt text='No'}" type="submit" />
</form>
