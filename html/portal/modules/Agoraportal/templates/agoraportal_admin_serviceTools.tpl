{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Eines d'administració"}</h3>
<div>{gt text="Nom client"}: <strong>{$client.clientName}</strong></div>
<div>{gt text="Servei"}: <strong>{$services[$client.serviceId].serviceName}</strong></div>
<div><a href="{modurl modname='Agoraportal' type='user' func='myAgora' clientCode=$client.clientCode}">{gt text="Edita el client"}</a></div>
<div class="serviceImgAdmin">
    <img src="modules/Agoraportal/images/{$services[$client.serviceId].serviceName}.gif" />
</div>
{include file="agoraportal_admin_serviceTools_aux.tpl"}
