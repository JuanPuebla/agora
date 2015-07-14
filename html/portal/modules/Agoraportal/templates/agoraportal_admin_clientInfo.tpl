<div class="panel panel-default">
    <div class="panel-heading">{gt text="Informació del client"}</div>
    <div class="panel-body">
        <p><strong>{gt text="Nom client"}</strong>: {$client.clientName}</p>
        <p><strong>{gt text="Codi"}</strong>: {$client.clientCode}</p>
        <p><strong>{gt text="Nom propi"}</strong>: {$client.clientDNS}</p>
        <p><strong>{gt text="Nom propi antic"}</strong>: {$client.clientOldDNS}</p>
        <p><strong>{gt text="Adreça"}</strong>: {$client.clientAddress}, {$client.clientPC} - {$client.clientCity} ({$client.clientCountry})</p>
        <p><strong>{gt text="Descripció"}</strong>: {$client.clientDescription}</p>
        <p><strong>{gt text="Xarxa educat"}</strong>: {$client.educat}</p>
    </div>
</div>