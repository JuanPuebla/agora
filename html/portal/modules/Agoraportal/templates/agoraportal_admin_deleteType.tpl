{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Esborra la tipologia de client"}</h3>
<form  class="z-form" enctype="application/x-www-form-urlencoded" method="post" id="deleteType" action="{modurl modname='Agoraportal' type='admin' func='deleteType'}">
    <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    <input type="hidden" name="typeId" value="{$type.typeId}" />
    <input type="hidden" name="confirmation" value="1" />
    {gt text="Confirma que vols esborrar la tipologia de client"}: <strong>{$type.typeName}</strong>
    <div class="z-center">
        <div class="z-buttons">
        <a title="{gt text='Esborra'}" onClick="javascript:sendDeleteType()">
            {img modname='core' src='button_ok.png' set='icons/small'}
            {gt text="Esborra"}
        </a>
        </div>
    </div>
</form>
