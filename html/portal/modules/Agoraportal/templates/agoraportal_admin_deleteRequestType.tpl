{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Esborra el tipus de sol·licitud"}</h3>
<form  class="z-form" enctype="application/x-www-form-urlencoded" method="post" id="deleteRequestType" action="{modurl modname='Agoraportal' type='admin' func='deleteRequestType'}">
    <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    <input type="hidden" name="requestTypeId" value="{$requestType.requestTypeId}" />
    <input type="hidden" name="confirmation" value="1" />
    {gt text="Confirma que vols esborrar el tipus de sol·licitud"}: <strong>{$requestType.name}</strong>
    <div class="z-center">
        <div class="z-buttons">
            <a title="{gt text='Esborra'}" onClick="javascript:sendDeleteRequestType()">
                {img modname='core' src='button_ok.png' set='icons/small'}
                {gt text="Esborra"}
            </a>
        </div>
    </div>
</form>
