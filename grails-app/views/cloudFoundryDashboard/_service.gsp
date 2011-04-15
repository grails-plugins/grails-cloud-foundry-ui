<table>

<tr><td>
	<table>
		<thead>
		<tr>
			<th>Name</th>
			<th>Tier</th>
			<th>Type</th>
			<th>Vendor</th>
			<th>Version</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td>${service.name}</td>
			<td>${service.tier}</td>
			<td>${service.type}</td>
			<td>${service.vendor}</td>
			<td>${service.version}</td>
		</tr>
		</tbody>
	</table>
</td></tr>

<tr><td>
	<table>
		<caption>Meta</caption>
		<thead>
		<tr>
			<th>Created</th>
			<th>Version</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td>${service.meta.created}</td>
			<td>${service.meta.version}</td>
		</tr>
		</tbody>
	</table>
</td></tr>

<tr><td>
	<table>
		<caption>Options</caption>
		<thead>
		<tr>
		<g:each in='${service.options.keySet()}'>
			<th>${it}</th>
		</g:each>
		</tr>
		</thead>
		<tbody>
		<tr>
		<g:each in='${service.options.values()}'>
			<td>${it}</td>
		</g:each>
		</tr>
		</tbody>
	</table>
</td></tr>

</table>
