{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Configura"}</h3>
<form  class="form-horizontal" enctype="application/x-www-form-urlencoded" method="post" name="config" id="config" action="{modurl modname='Agoraportal' type='admin' func='updateConfig'}">
    <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    <div class="form-group">
        <label class="col-sm-4 control-label" for="siteBaseURL">{gt text="Adreça base"}</label>
        <div class="col-sm-8">
            <input class="form-control" type="text" id="siteBaseURL" name="siteBaseURL" size="50" maxlength="150" value="{$siteBaseURL}" />
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-4 control-label" for="warningMailsTo">{gt text="Adreces de correu a on s'han d'enviar els missatges relatius al consum del disc"}</label>
        <div class="col-sm-8">
            <textarea class="form-control" id="warningMailsTo" ="warningMailsTo" rows="3">{$warningMailsTo}</textarea>
            <div class="alert alert-info">
                {gt text="Separeu la llista d'IP per comes."}
            </div>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-4 control-label" for="requestMailsTo">{gt text="Adreces de correu on s'ha d'avisar en cas de sol·licituds d'augment d'espai de disc"}</label>
        <div class="col-sm-8">
            <textarea class="form-control" id="requestMailsTo" name="requestMailsTo" rows="3">{$requestMailsTo}</textarea>
            <div class="alert alert-info">
                {gt text="Separeu la llista d'IP per comes."}
            </div>
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-4 control-label" for="diskRequestThreshold">{gt text="Ocupació a partir de la qual es pot demanar ampliació de quota (%)"}</label>
        <div class="col-sm-8">
            <input class="form-control" type="text" id="diskRequestThreshold" name="diskRequestThreshold" size="10" maxlength="50" value="{$diskRequestThreshold}" />
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-4 control-label" for="maxFreeQuotaForRequest">{gt text="Quota lliure màxima per poder demanar ampliació de quota (MB)"}</label>
        <div class="col-sm-8">
            <input class="form-control" type="text" id="maxFreeQuotaForRequest" name="maxFreeQuotaForRequest" size="10" maxlength="50" value="{$maxFreeQuotaForRequest}" />
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-4 control-label" for="clientsMailThreshold">{gt text="Ocupació a partir de la qual s'avisa per correu electrònic als clients (%)"}</label>
        <div class="col-sm-8">
            <input class="form-control" type="text" id="clientsMailThreshold" name="clientsMailThreshold" size="10" maxlength="50" value="{$clientsMailThreshold}" />
        </div>
    </div>

    <div class="form-group">
        <label class="col-sm-4 control-label" for="maxAbsFreeQuota">{gt text="Quota lliure màxima per a que s'avisi per correu electrònic als clients (MB)"}</label>
        <div class="col-sm-8">
            <input class="form-control" type="text" id="maxAbsFreeQuota" name="maxAbsFreeQuota" size="10" maxlength="50" value="{$maxAbsFreeQuota}" />
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-4 control-label" for="createDB">{gt text="En fer una alta de Nodes, intenta crear la base de dades MySQL si no existeix"}</label>
        <div class="col-sm-8">
            <input type="checkbox" id="createDB" name="createDB" {if $createDB}checked="checked"{/if} />
        </div>
    </div>

    <div class="text-center">
        <a class="btn btn-success" title="Modifica la configuració" onclick="sendConfig();" href="#">
            <span class="glyphicon glyphicon-ok" aria-hidden="true"></span> {gt text="Modifica la configuració"}
        </a>
    </div>
</form>

<br/>
<div class="panel panel-primary">
    <div class="panel-heading">{gt text="Tipus de serveis disponibles"}</div>
    <div class="panel-body">
        <form name="servicesList" id="servicesList">
            <table class="table table-hover table-striped">
                <thead>
                    <tr>
                        <th>{gt text="Id"}</th>
                        <th>{gt text="Nom"}</th>
                        <th>{gt text="URL"}</th>
                        <th>{gt text="Descripció"}</th>
                        <th>{gt text="Versió"}</th>
                        <th>{gt text="Té base de dades"}</th>
                        <th>{gt text="Prefix de la base de dades"}</th>
                        <th>{gt text="Clients permesos *"}</th>
                        <th>{gt text="Directori base"}</th>
                        <th>{gt text="Espai disc"}</th>
                        <th>{gt text="Opcions"}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach item=service from=$services}
                    <tr id="service{$service.serviceId}">
                        <td>{$service.serviceId}</td>
                        <td><img src="modules/Agoraportal/images/{$service.serviceName}.gif" alt="{$service.serviceName}" title="{$service.serviceName}"/></td>
                        <td>{$service.URL}</td>
                        <td>{$service.description}</td>
                        <td>{$service.version}</td>
                        <td>{$service.hasDB}</td>
                        <td>{$service.tablesPrefix}</td>
                        <td>{$service.allowedClients}</td>
                        <td {if $service.serverFolder neq ''}class="{if $service.validFolder}bg-success{else}bg-danger{/if}"{/if}>
                            {$service.serverFolder}
                        </td>
                        <td>{$service.defaultDiskSpace}</td>
                        <td>
                            <a class="btn btn-info" href="#servicesList" onclick="editService({$service.serviceId});" title="Edita">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                <span class="sr-only">Edita</span>
                            </a>
                        </td>
                    </tr>
                    {foreachelse}
                    <tr>
                        <td colspan="11">
                            <div class="alert alert-warning">
                                {gt text="No s'han trobat serveis"}
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </form>
        <div class="alert alert-info">
            {gt text="* Codi dels clients separats per coma. En blanc no hi ha restriccions"}
        </div>
    </div>
</div>


<div class="panel panel-info">
    <div class="panel-heading clearfix">{gt text="Plantilles de Nodes"}
    <a class="btn btn-default pull-right" href="{modurl modname='Agoraportal' type='admin' func='addNewModelType'}">
        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
        {gt text="Afegeix un tipus de maqueta nou"}
    </a></div>
    <div class="panel-body">
        <table class="table table-hover table-striped">
            <thead>
                <tr>
                    <th>{gt text="Codi curt (nom fitxer)"}</th>
                    <th>{gt text="Paraula clau (extraFunc)"}</th>
                    <th>{gt text="Descripció (askServices)"}</th>
                    <th>{gt text="URL (per replace)"}</th>
                    <th>{gt text="Base de dades (per replace)"}</th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody>
                {foreach item=type from=$modeltypes}
                <tr>
                    <td>{$type.shortcode}</td>
                    <td>{$type.keyword}</td>
                    <td>{$type.description}</td>
                    <td>{$type.url}</td>
                    <td>{$type.dbHost}</td>
                    <td>
                        <a class="btn btn-danger" href="{modurl modname='Agoraportal' type='admin' func='deleteModelType' modelTypeId=$type.modelTypeId}" title="Esborra">
                            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                            <span class="sr-only">Esborra</span>
                        </a>
                    </td>
                </tr>
                {foreachelse}
                <tr><td colspan="4">{gt text="No s'ha trobat cap tipus de maqueta"}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>

<div class="panel panel-info">
    <div class="panel-heading clearfix">{gt text="Tipus de sol·licituds"}
        <a class="btn btn-default pull-right" href="{modurl modname='Agoraportal' type='admin' func='addNewRequestType'}">
            <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
            {gt text="Afegeix un tipus de sol·licitud nou"}
        </a></div>
    <div class="panel-body">
        <table class="table table-hover table-striped">
            <tbody>
                {foreach item=type from=$requesttypes}
                <tr>
                    <td>{$type.name}</td>
                    <td>
                        <div class="btn-group" role="group">
                            <a class="btn btn-info" href="{modurl modname='Agoraportal' type='admin' func='editRequestType' requestTypeId=$type.requestTypeId}" title="Edita">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                <span class="sr-only">Edita</span>
                            </a>
                            <a class="btn btn-danger" href="{modurl modname='Agoraportal' type='admin' func='deleteRequestType' requestTypeId=$type.requestTypeId}" title="Esborra">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                <span class="sr-only">Esborra</span>
                            </a>
                        </div>
                    </td>
                </tr>
                {foreachelse}
                <tr><td colspan="2">{gt text="No s'han trobat tipus de Sol·licituds"}</td></tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>


<div class="panel panel-info">
    <div class="panel-heading clearfix">{gt text="Serveis de les sol·licituds"}
    <a class="btn btn-default pull-right" href="{modurl modname='Agoraportal' type='admin' func='addNewRequestTypeService'}">
            <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
            {gt text="Afegeix un servei nou al tipus de sol·licitud"}
        </a></div>
    <div class="panel-body">
        <table class="table table-hover table-striped">
                <thead>
                <tr>
                    <th>{gt text="Tipus de sol·licitud"}</th>
                    <th>{gt text="Servei"}</th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody>
                {foreach item=types from=$requesttypesservices}
                <tr>
                    <td>{$types.type}</td>
                    <td><img src="modules/Agoraportal/images/{$types.serviceName}.gif" alt="{$types.serviceName}" title="{$types.serviceName}"/></td>
                    <td>
                        <a class="btn btn-danger" href="{modurl modname='Agoraportal' type='admin' func='deleteRequestTypeService' requestTypeId=$types.requestTypeId serviceId=$types.serviceId}" title="Esborra">
                            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                            <span class="sr-only">Esborra</span>
                        </a>
                    </td>
                </tr>
                {foreachelse}
                <tr><td colspan="3">{gt text="No s'ha trobat cap servei assignat a cap tipus de sol·licitud"}</td></tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>


<div class="panel panel-info">
    <div class="panel-heading clearfix">{gt text="Serveis Territorials"}
    <a class="btn btn-default pull-right" href="{modurl modname='Agoraportal' type='admin' func='addNewLocation'}">
            <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
            {gt text="Afegeix un Servei Territorial nou"}
        </a></div>
    <div class="panel-body">
        <table class="table table-hover table-striped">
            <tbody>
                {foreach item=location from=$locations}
                <tr class="{cycle values="z-odd,z-even"}">
                    <td>{$location.locationName}</td>
                    <td>
                        <div class="btn-group" role="group">
                            <a class="btn btn-info" href="{modurl modname='Agoraportal' type='admin' func='editLocation' locationId=$location.locationId}" title="Edita">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                <span class="sr-only">Edita</span>
                            </a>
                            <a class="btn btn-danger" href="{modurl modname='Agoraportal' type='admin' func='deleteLocation' locationId=$location.locationId}" title="Esborra">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                <span class="sr-only">Esborra</span>
                            </a>
                        </div>
                    </td>
                </tr>
                {foreachelse}
                <tr><td colspan="2">{gt text="No s'han trobat SSTT"}</td></tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>


<div class="panel panel-info">
    <div class="panel-heading clearfix">{gt text="Tipologies de centres"}
     <a class="btn btn-default pull-right" href="{modurl modname='Agoraportal' type='admin' func='addNewType'}">
            <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
            {gt text="Afegeix una tipologia de centre nova"}
        </a></div>
    <div class="panel-body">
        <table class="table table-hover table-striped">
            <tbody>
                {foreach item=schooltype from=$schooltypes}
                <tr id="formRow_{$schooltype.typeId}">
                    <td>{$schooltype.typeName}</td>
                    <td>
                        <div class="btn-group" role="group">
                            <a class="btn btn-info" href="{modurl modname='Agoraportal' type='admin' func='editType' typeId=$schooltype.typeId}" title="Edita">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                <span class="sr-only">Edita</span>
                            </a>
                            <a class="btn btn-danger" href="{modurl modname='Agoraportal' type='admin' func='deleteType' typeId=$schooltype.typeId}" title="Esborra">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                <span class="sr-only">Esborra</span>
                            </a>
                        </div>
                    </td>
                </tr>
                {foreachelse}
                <tr><td colspan="2">{gt text="No s'han trobat tipologies de centres"}</td></tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>
