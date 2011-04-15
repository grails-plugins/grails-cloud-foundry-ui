			<div id="instance${instanceStats.id}TableHolder" class="tabPane">
			<table id="instance${instanceStats.id}Table" cellpadding="0" cellspacing="0" border="0" class="display">
				<thead>
				<tr>
				<th>Files</th>
				<th>State</th>
				<th>Uptime</th>
				<th>Host</th>
				<th>Port</th>
				<th>Cores</th>
				<th>Disk Quota</th>
				<th>Fds Quota</th>
				<th>Memory Quota</th>
				</tr>
				</thead>
				<tbody>
				<tr>
				<td><a href="${createLink(action: 'files')}/${app.name}/${instanceStats.id}">View</a></td>
				<td>${instanceStats.state}</td>
				<td>${grails.plugin.cloudfoundry.CloudFoundryUtils.uptimeString(instanceStats.uptime)}</td>
				<td>${instanceStats.host}</td>
				<td>${instanceStats.port}</td>
				<td>${instanceStats.cores}</td>
				<td>${instanceStats.diskQuota / 1024 / 1024 / 1024}GB</td>
				<td>${instanceStats.fdsQuota}</td>
				<td>${instanceStats.memQuota / 1024 / 1024}MB</td>
				</tr>

				<tr><th colspan='9'>Usage (as of <span id='usageSince${instanceStats.id}'><g:formatDate date="${instanceStats.usage.time}" format="yyyy-MM-dd hh:mma"/></span>)</th></tr>
				<tr><td colspan='9'>
					<table>
						<tr>
							<td><div id='memoryGraph${instanceStats.id}' class='usageGraph'></div></td>
							<td><div id='diskGraph${instanceStats.id}' class='usageGraph'></div></td>
							<td><div id='cpuGraph${instanceStats.id}' class='usageGraph'></div></td>
						</tr>
					</table>
				</td></tr>

				</tbody>
			</table>
			</div>

<g:javascript>
var diskUsageGraph${instanceStats.id};
var memoryUsageGraph${instanceStats.id};
var cpuUsageGraph${instanceStats.id};

$(document).ready(function() {
	diskUsageGraph${instanceStats.id} = createDiskUsageGraph(${instanceStats.id}, ${instanceStats.diskQuota}, ${instanceStats.usage.disk});
	memoryUsageGraph${instanceStats.id} = createMemoryUsageGraph(${instanceStats.id}, ${instanceStats.memQuota}, ${instanceStats.usage.mem.toLong()});
	cpuUsageGraph${instanceStats.id} = createCpuUsageGraph(${instanceStats.id}, ${instanceStats.usage.cpu});
});
</g:javascript>
