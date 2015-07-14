{include file="agoraportal_user_menu.tpl"}
<div class="container-fluid">
    <h3>{gt text="Serveis del centre"}&nbsp;{$client.clientName}</h3>
    {if $isAdmin}
    {include file="agoraportal_admin_clientInfo.tpl"}
    {/if}
    {if $managers eq 0}
    <div class="alert alert-warning">
        {gt text="Des del curs 2011/2012, només poden sol·licitar serveis a Àgora i/o gestionar els ja existents (pujada de fitxers grans, consulta de la quota de disc consumida, ...) les persones físiques (gestors) que el centre hagi autoritzat. En aquests moments, el vostre centre encara no disposa de cap gestor, així que cal que en designeu un des de l'apartat <a href=index.php?module=Agoraportal&func=managers>Gestors</a>. Amb el codi de centre, podeu afegir i treure gestors, fins a un màxim de quatre, però no podeu gestionar els serveis d'Àgora."}
    </div>
    {/if}
    {foreach item=client from=$clientArray}
        {assign var="serviceName" value=$services[$client.serviceId].serviceName}
        {assign var="serviceDescription" value=$services[$client.serviceId].description}
        <div class="panel panel-default">
            <div class="panel-heading">
                <img src="modules/Agoraportal/images/{$serviceName}.gif" alt="{$serviceName}" title="{$serviceName}" />
                <strong>{$serviceName}</strong>: {$serviceDescription}
            </div>
            <div class="panel-body">
                <p><strong>{gt text="Ha fet la sol·licitud"}</strong>: {$client.contactName} ({$client.contactMail})</p>
                {if $client.state eq 0}
                <span class="toCheck alert alert-warning">{gt text="Servei pendent d'activació"}</span>
                {elseif $client.state eq -2}
                <span class="denegated alert alert-danger">{gt text="Sol·licitud denegada"}</span>
                {elseif $client.state eq -3 or $client.state eq -4}
                    {if $client.observations neq ''}
                    <div class="denegated alert alert-danger">
                        {$client.observations|nl2br}
                    </div>
                    {/if}
                {elseif $client.state eq 1}
                    {if $serviceName neq 'marsupial'}
                        <p><strong>{gt text="Accés"}</strong>: <a href="{$client.clientDNS|serviceLink:$services[$client.serviceId].serviceName}">{$client.clientDNS|serviceLink:$serviceName}</a>
                        </p>
                    {/if}
                    {if $isAdmin}
                        {if $serviceName neq 'marsupial'}
                            <p><strong>{gt text="Usu"}</strong>: {$client.activedId}</p>
                        {/if}
                    {/if}
                    <p><strong>{gt text="Data d'activació"}</strong>: {$client.timeCreated|dateformat:"%d/%m/%Y"}
                    {if $client.usageArray.maxDiskSpace gt 0}
                    </p>
                    <div class="clearfix">
                        <div class="pull-left"><strong>{gt text="Espai de disc ocupat"}</strong>:&nbsp;</div>
                        <div class="progress pull-left" style="width:200px;">
                          <div class="progress-bar" role="progressbar" aria-valuenow="{$client.usageArray.percentage}" aria-valuemin="0" aria-valuemax="100" style="width: {$client.usageArray.percentage}%;">
                            {$client.usageArray.percentage}%
                          </div>
                        </div>


                        <div class="pull-left">&nbsp;&nbsp;({$client.usageArray.usedDiskSpace}MB / {$client.usageArray.totalDiskSpace}MB) <a href="{modurl modname='Agoraportal' type='user' func='recalcConsume' clientServiceId=$client.clientServiceId}">{gt text="Actualitza"}</a></div>
                        {if $client.usageArray.alert eq 1}
                        <div class="pull-left">&nbsp;&nbsp;
                            <a href="{modurl modname='Agoraportal' type='user' func='requests' clientCode=$client.clientCode}">
                                {gt text="Sol·licita més espai"}
                            </a>
                        </div>
                        {/if}
                    </div>
                {/if}
                {/if}
                {if $isAdmin}
                    <div class="panel panel-info clearfix" id="tools_{$serviceName}">
                        <div class="panel-heading">
                            Eines d'administració
                        </div>
                        <div class="panel-body">
                            <a href="{modurl modname='Agoraportal' type='admin' func='editService' clientServiceId=$client.clientServiceId}">{gt text="Edita el servei"}</a>
                             - <a href="{modurl modname='Agoraportal' type='admin' func='deleteService' clientServiceId=$client.clientServiceId}">{gt text="Esborra el servei"}</a>
                             {include file="agoraportal_admin_serviceTools_aux.tpl"}
                        </div>
                    </div>
                {/if}
            </div>
        </div>
    {foreachelse}
        {if $managers|@count gt 0}
            <div class="alert alert-info">
                {gt text="No s'han trobat serveis."}
                {if $accessLevel neq 'add'}
                    <br/>
                    {gt text="Recordeu que només poden sol·licitar l'alta als serveis d'Àgora els <a href=index.php?module=Agoraportal&func=managers>Gestors</a>."}
                {/if}
            </div>
        {/if}
    {/foreach}

    {if $accessLevel eq 'add' and $notsolicitedServices|@count gt 0}
        <h4>{gt text="Altres serveis disponibles"}</h4>
        <div class="serviceInfo z-form">
        {foreach item=service from=$notsolicitedServices}
            {assign var="serviceName" value=$notsolicitedServices[$service.serviceId].serviceName}
            <div style="margin-bottom: 10px;">
                    <a class="btn btn-default" href="modurl modname='Agoraportal' type='user' func='askServices' serviceId=$service.serviceId clientCode=$clientCode}" role="button" style="padding:10px; line-height:25px;">
                        <div style="float:left; min-width:80px; margin-right: 3px;">
                        <img src="modules/Agoraportal/images/{$serviceName}.gif" alt="{$serviceName|capitalize}" title="{$serviceName|capitalize}" style="height: initial; width: initial;"/></div>
                        Sol·licita'l ara
                    </a>
                <strong>{$serviceName|capitalize}</strong>: {$notsolicitedServices[$service.serviceId].description}
            </div>
        {/foreach}
        </div>
    {/if}

    {if $clientOldDNS neq $clientDNS and $clientDNS neq ''}
    <div class="alert alert-info">
        <form name="changeDNS" id="changeDNS" class="z-adminform" action="{modurl modname='Agoraportal' type='user' func='changeDNS'}" method="post">
            <p>El nom propi del vostre centre ha canviat, però els serveis d'Àgora encara utilitzen el nom propi antic.
            L'actual és <strong>{$clientOldDNS}</strong> i el nom nou és <strong>{$clientDNS}</strong>.</p>
            <p>No cal que feu el canvi de nom propi ara però, si el voleu fer, heu de tenir en compte que pot afectar a alguns enllaços interns, tant en el cas del Moodle com en el del Nodes, i no es pot desfer.
            Un cop fet el canvi, si passats 30 minuts detecteu alguna anomalia us recomanem que contacteu amb l'equip d'Àgora, <a target="_blank" href="http://agora.xtec.cat/">via fòrum</a>, per tal de que corregim els enllaços.</p>
            <p>Voleu fer aquest canvi?</p>
            <input type="hidden" name="clientCode" value="{$clientCode}" />
            <input type="hidden" name="clientDNS" value="{$clientDNS}" />
            <input type="hidden" name="clientOldDNS" value="{$clientOldDNS}" />
            <input type="submit" value="{gt text='Sí, vull fer el canvi ara'}" />
        </form>
    </div>
    {/if}
</div>