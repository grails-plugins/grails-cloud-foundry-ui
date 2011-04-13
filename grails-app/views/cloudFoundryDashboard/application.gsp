<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Applications</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name='layout' content='cloudFoundry'/>
<g:javascript src='graph.js' />
<g:javascript>
$(document).ready(function() {
	$('ul.tabs').tabs('div.panes > div')
});
</g:javascript>
</head>

<body>

<script type='text/javascript' src='http://www.google.com/jsapi'></script>
<script>
google.load('visualization', '1', {'packages':['gauge']});
</script>

	<div class="body">

	<table>
		<tr>
			<th>Name</th>
			<th>State</th>
			<th>Running Instances</th>
			<th>Memory</th>
			<th>URIs</th>
			<th>Staging Model</th>
			<th>Staging Stack</th>
			<th>Version</th>
			<th>Created</th>
			<th>Services</th>
		</tr>
		<tr>
			<td>${app.name}</td>
			<td>${app.state}</td>
			<td>${app.runningInstances}</td>
			<td>${app.memory}MB</td>
			<td>${app.uris}</td>
			<td>${app.staging.model}</td>
			<td>${app.staging.stack}</td>
			<td>${app.meta.version}</td>
			<td><g:formatDate date="${new Date(app.meta.created.toLong() * 1000)}" format="yyyy-MM-dd hh:mma"/></td>
			<td>
				<ul>
					<g:each in='${app.services}' var='service'>
					<li><a href="${createLink(action: 'service')}/${service}">${service}</a></li>
					</g:each>
				</ul>
			</td>
		</tr>

		<tr>
			<th>Instances</th>
			<th colspan='9'><a href='javascript:void(0);' onclick='toggleGraphUpdate()' id='toggleGraphUpdate'>Disable auto-refresh</a></th>
		</tr>

		<tr>
			<th colspan='10'>
			<ul class="tabs">
				<g:each var='instanceStats' in='${stats.records}'>
				<li><a href="#">Instance ${instanceStats.id}</a></li>
				</g:each>
			</ul>
			</th>
		</tr>

		<tr>
			<td colspan='10'>
			<div class='panes'>
			<g:each var='instanceStats' in='${stats.records}'>
<g:render template='instance' model="[instanceStats: instanceStats, app: app]" />
			</g:each>
			</div>
			</td>
		</tr>
	</table>

	</div>

<g:javascript>
var redrawGraphsTimerId = setInterval('redrawGraphs()', 5000);
//clearInterval(redrawGraphsTimerId);
var updatingGraphs = true;

function toggleGraphUpdate() {
	if (updatingGraphs) {
		$('#toggleGraphUpdate').text('Enable auto-refresh');
	}
	else {
		$('#toggleGraphUpdate').text('Disable auto-refresh');
	}
	updatingGraphs = !updatingGraphs;
}

function redrawGraphs() {
	if (!updatingGraphs) {
		return;
	}
<g:each var='instanceStats' in='${stats.records}'>
	$.getJSON('${createLink(action: 'usageData')}?appName=${app.name}&instanceId=${instanceStats.id}', function(data) {
		if (data.error) {
			return;
		}
		try {
			diskUsageGraph${instanceStats.id}.update(data.diskUsage / 1024 / 1024);
		}
		catch(e) {}
		try {
			memoryUsageGraph${instanceStats.id}.update(data.memUsage / 1024);
		}
		catch(e) {}
		try {
			cpuUsageGraph${instanceStats.id}.update(data.cpuUsage);
		}
		catch(e) {}

		$('#usageSince${instanceStats.id}').text(formatDate(data.since));
	});
</g:each>
}

</g:javascript>

</body>
</html>
