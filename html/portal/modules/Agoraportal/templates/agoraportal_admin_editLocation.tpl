{include file="agoraportal_admin_menu.tpl"}
<h3>{gt text="Edita el nom del Servei Territorial"}</h3>
<form  class="z-form" enctype="application/x-www-form-urlencoded" method="post" id="editLocation" action="{modurl modname='Agoraportal' type='admin' func='editLocation'}">
    <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
    <input type="hidden" name="locationId" value="{$location.locationId}" />
    <input type="hidden" name="confirmation" value="1" />
    <div class="z-formrow">
        <label for="locationName">{gt text="Nom del Servei Territorial"}</label>
        <input type="text" name="locationName" size="30" maxlength="150" value="{$location.locationName}" />
    </div>
    <div class="z-center">
        <div class="z-buttons">
            <a title="{gt text='Modifica el Servei Territorial'}" onClick="javascript:sendEditLocation()">
                {img modname='core' src='button_ok.png' set='icons/small'}
                {gt text="Modifica el Servei Territorial"}
            </a>
        </div>
    </div>
</form>
<script>
    var noLocationName = "{{gt text="No has escrit el nom del Servei Territorial"}}";
</script>