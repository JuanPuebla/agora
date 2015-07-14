{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Executa una SQL a "}{$serviceName}</h3>

<div class="panel panel-info">
    <div class="panel-heading clearfix">{gt text="Funció a executar"}
        <form class="pull-right" name="sqlForm" id="sqlForm" action="index.php?module=Agoraportal&type=admin&func=sql" method="POST">
        <div class="hidden">
            <input type="hidden" name="which" value="{$which}">
            <input name="service_sel" type="hidden" value={$service_sel} />
            {if $which eq "selected"}
            <select name="clients_sel[]" multiple="multiple">
                {foreach item=client from=$sqlClients}
                <option value="{$client.clientId}" SELECTED>{$client.clientName}</option>
                {/foreach}
            </select>
            {/if}
            <textarea name="sqlfunction">{$sqlfunc}</textarea>
        </div>
        <input class="btn btn-info" value="{gt text='Modifica la consulta'}" type="submit" />
        </form>
    </div>
    <img src="modules/Agoraportal/images/{$serviceName}.gif" alt="{$serviceName}" title="{$sserviceName}" />
    <div class="panel-body" style="white-space: pre;">{$sqlfunc}</div>
</div>

{if $which eq "all"}
<div class="alert alert-info">{gt text="S'executa a Tots"}</div>
{/if}

<label>{gt text="Resultat:"}</label>
{if $messages_recount|@count}
<table class="table table-hover table-striped">
    <thead>
        <tr><th>{gt text="Missatge"}</th><th>{gt text="Recompte"}</th></tr>
    </thead>
    <tbody>
        {foreach item=number key=name from=$messages_recount}
        <tr><td>{$name}</td><td>{$number}</td></tr>
        {/foreach}
    </tbody>
</table>
{/if}

<table class="table table-hover table-striped">
    <thead>
        <tr>
            <th>{gt text="BD"}</th>
            <th>{gt text="Client"}</th>
            <th>{gt text="Missatge/Línies"}</th>
        </tr>
    </thead>
    <tbody>
        {foreach item=client key=id from=$sqlClients}
        {if $success[$id]}
            <tr class="success">
        {else}
            <tr class="danger">
        {/if}
            <td><a href="#{$prefix}{$client.activedId}">{$prefix}{$client.activedId}</a></td>
            <td><a href="{$client.clientDNS|serviceLink:$serviceName}" target="_blank">{$client.clientName}</a></td>
            <td>{$messages[$id]}</td>
        </tr>
        {/foreach}
    </tbody>
</table>

{foreach item=result key=id from=$results}
    <h4>
        <a name="{$prefix}{$sqlClients[$id].activedId}" target="_blank" href="{$sqlClients[$id].clientDNS|serviceLink:$serviceName}">{$prefix}{$sqlClients[$id].activedId}  {$sqlClients[$id].clientName}</a>
    </h4>
    <table class="table table-hover table-striped"><thead>
            {foreach item=line key=columna from=$result}
            <tr>
                {foreach item=field key=camp from=$line}
                {if $columna eq 0}<th>{else}<td>{/if}
                    {$field}
                    {if $columna eq 0}</th>{else}</td>{/if}
                {/foreach}
            </tr>
            {if $columna eq 0}</thead><tbody>{/if}
            {/foreach}
    </tbody></table>
{/foreach}
