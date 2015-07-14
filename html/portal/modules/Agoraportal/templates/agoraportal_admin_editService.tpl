{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Edita el servei"} <img src="modules/Agoraportal/images/{$services[$client.serviceId].serviceName}.gif" alt="{$services[$client.serviceId].serviceName}" title="{$services[$client.serviceId].serviceName}"/></h3>
<form id="editClientServiceForm" class="form-horizontal" action="{modurl modname='Agoraportal' type='admin' func='updateService'}" method="post" enctype="application/x-www-form-urlencoded">
    <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    <input type="hidden" name="clientServiceId" value="{$client.clientServiceId}" />
    <input type="hidden" name="clientId" value="{$client.clientId}" />
    <div class="panel panel-info">
        <div class="panel-heading">{gt text="Dades del client"}</div>
        <div class="panel-body">
            <div class="form-group">
                <label class="col-sm-4 control-label" for="clientCode">{gt text="Codi"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" disabled id="clientCode" type="text" name="clientCode" size="15" maxlength="15" value="{$client.clientCode}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="clientDNS">{gt text="Nom propi"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="clientDNS" type="text" name="clientDNS" size="15" maxlength="50" value="{$client.clientDNS}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="clientName">{gt text="Nom client"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="clientName" type="text" name="clientName" size="15" maxlength="50" value="{$client.clientName}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="clientAddress">{gt text="Adreça"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="clientAddress" type="text" name="clientAddress" size="30" maxlength="150" value="{$client.clientAddress}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="clientCity">{gt text="Població"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="clientCity" type="text" name="clientCity" size="30" maxlength="50" value="{$client.clientCity}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="clientPC">{gt text="Codi postal"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="clientPC" type="text" name="clientPC" size="5" maxlength="5" value="{$client.clientPC}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="locationId">{gt text="Servei Territorial"}:</label>
                <div class="col-sm-8">
                    <select class="form-control" id="locationId" name="locationId">
                        <option value="0">{gt text="Tria un Servei Territorial..."}</option>
                        {foreach item=location from=$locations}
                        <option {if $client.locationId eq $location.locationId}selected{/if} value="{$location.locationId}">{$location.locationName}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="type">{gt text="Tipus de centre"}:</label>
                <div class="col-sm-8">
                    <select class="form-control" id="type" name="typeId">
                        <option value="0">{gt text="Tria un tipus de centre..."}</option>
                        {foreach item=type from=$types}
                        <option {if $client.typeId eq $type.typeId}selected{/if} value="{$type.typeId}">{$type.typeName}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="extraFunc">{gt text="Funcionalitats addicionals"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="extraFunc" type="text" name="extraFunc" size="15" maxlength="15" value="{$client.extraFunc}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="educat">{gt text="Centre eduCAT 1x1"} <img src="modules/Agoraportal/images/educat.png" alt="educat" title="educat" align="middle"/>:</label>
                <div class="col-sm-8">
                    <input id="educat" type="checkbox" {if $client.educat eq 1}checked{/if} name="educat" value="1"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="noVisible">{gt text="No visible a la llista pública de centres"}:</label>
                <div class="col-sm-8">
                    <input id="noVisible" type="checkbox" {if $client.noVisible eq 1}checked{/if} name="noVisible" value="1"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="clientDescription">{gt text="Descripció"}:</label>
                <div class="col-sm-8">
                    <textarea class="form-control" id="clientDescription" style="width: 90%" rows="5" name="clientDescription">{$client.clientDescription}</textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="clientState">{gt text="Actiu"}:</label>
                <div class="col-sm-8">
                    <input id="clientState" type="checkbox" {if $client.clientState eq 1}checked{/if} name="clientState" value="1"/>
                </div>
            </div>
        </div>
    </div>
    <div class="panel panel-info">
        <div class="panel-heading">{gt text="Dades de contacte"}</div>
        <div class="panel-body">
            <div class="form-group">
                <label class="col-sm-4 control-label" for="contactName">{gt text="Ha Enviat"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="contactName" type="text" name="contactName" size="30" maxlength="150" value="{$client.contactName}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="contactMail">{gt text="Correu electrònic de la persona que ha enviat la sol·licitud"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="contactMail" type="text" name="contactMail" size="30" maxlength="30" value="{$client.contactMail}"/>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="contactProfile">{gt text="Càrrec"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="contactProfile"  type="text" name="contactProfile" size="30" maxlength="50" value="{$client.contactProfile}"/>
                </div>
            </div>
        </div>
    </div>
    <div class="panel panel-info">
        <div class="panel-heading">{gt text="Estat del servei"}</div>
        <div class="panel-body">
            <div class="form-group">
                <label class="col-sm-4 control-label" for="state">{gt text="Estat"}:</label>
                <div class="col-sm-8">
                    <select  class="form-control" id="state" name="state" onchange="javascript:autoActions({$client.serviceId})">
                        <option {if $client.state eq 0}selected{/if} value="0">{gt text="Per revisar"}</option>
                        <option {if $client.state eq 1}selected{/if} value="1">{gt text="Actiu"}</option>
                        <option {if $client.state eq -2}selected{/if} value="-2">{gt text="Denegat"}</option>
                        <option {if $client.state eq -3}selected{/if} value="-3">{gt text="Donat de baixa"}</option>
                        <option {if $client.state eq -4}selected{/if} value="-4">{gt text="Desactivat"}</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="sendMail">{gt text="Envia un correu al centre i a la persona que ha sol·licitat l'ativació en cas de canvis"}:</label>
                <div class="col-sm-8">
                    {if $mailer}
                    <input id="sendMail" type="checkbox" name="sendMail" value="1" />
                    <input type="hidden" name="stateOriginal" value="{$client.state}"/>
                    {else}
                    <span class="denegated">
                        {gt text="El Mailer no està operatiu"}
                    </span>
                    <input id="sendMail" type="checkbox" name="sendMail" value="0"/>
                    {/if}
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="dbHost">{gt text="Servidor de base de dades"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="dbHost" type="text" name="dbHost" size="30" maxlength="30" value="{$client.dbHost}" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="version">{gt text="Versió del programari"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="version" type="text" name="version" size="30" maxlength="30" value="{$client.version}" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="serviceDB">{gt text="Base de dades"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="serviceDB" type="text" name="serviceDB" size="30" maxlength="30" value="{$client.serviceDB}" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="diskSpace">{gt text="Espai disc"}:</label>
                <div class="col-sm-8">
                    <input class="form-control" id="diskSpace" type="text" name="diskSpace" size="7" maxlength="5" value="{$client.diskSpace}" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="observations">{gt text="Observacions (visible per part dels clients)"}:</label>
                <div class="col-sm-8">
                    <textarea class="form-control" id="observations" rows="5" name="observations">{$client.observations}</textarea>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-4 control-label" for="annotations">{gt text="Anotacions (només no veuen els administradors)"}:</label>
                <div class="col-sm-8">
                    <textarea class="form-control" rows="5" id="annotations" name="annotations">{$client.annotations}</textarea>
                </div>
            </div>
        </div>
    </div>
    <div class="text-center">
        <a class="btn btn-success" title="Desa" onclick="editClientService();" href="#">
            <span class="glyphicon glyphicon-ok" aria-hidden="true"></span> {gt text="Desa"}
        </a>
        <a class="btn btn-danger" title="Cancel·la" href="{modurl modname='Agoraportal' type='admin' func='main'}">
            <span class="glyphicon glyphicon-remove" aria-hidden="true"></span> {gt text="Cancel·la"}
        </a>
    </div>
</form>
<script>
    var confirmDischarge = "{{gt text='Estàs a punt de donar de baixa un servei. Aquesta acció no es pot desfer. N\'estàs completament segur/a?'}}";
    var autoAnnotations = "{{$client.annotations}}{{gt text='Deixa la base de dades:'}}" + " {{$client.serviceDB}}";
    var autoObservations = "{{$client.observations}}{{gt text='Baixa automàtica del servei per inactivitat durant més de 12 mesos.'}}";
</script>
