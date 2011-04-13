function Graph(title, id, value, max) {
	this.title = title;
	this.id = id;
	this.max = max;

	this.dataTable = new google.visualization.DataTable();
	this.dataTable.addColumn('number', title);
	this.dataTable.addRows(1);
	this.dataTable.setCell(0, 0, Math.round(value * 10) / 10);

	this.chart = new google.visualization.Gauge(document.getElementById(id));

	this.options = {
		min: 0,
		max: max
	};
}

Graph.prototype.draw = function() {
	this.chart.draw(this.dataTable, this.options);
};

Graph.prototype.update = function(newValue) {
	this.dataTable.setValue(0, 0, Math.round(newValue * 10) / 10);
	this.chart.draw(this.dataTable, this.options);
};

function createGraph(title, id, value, max) {
	var graph = new Graph(title, id, value, max);
	graph.draw();
	return graph;
}

function createDiskUsageGraph(id, diskQuota, diskUsage) {
	return createGraph('Disk (MB)', 'diskGraph' + id, diskUsage / 1024 / 1024, diskQuota / 1024 / 1024);
}

function createMemoryUsageGraph(id, memQuota, memUsage) {
	return createGraph('Memory (MB)', 'memoryGraph' + id, memUsage / 1024, memQuota / 1024 / 1024);
}

function createCpuUsageGraph(id, cpuUsage) {
	return createGraph('CPU (%)', 'cpuGraph' + id, cpuUsage, 100);
}

function formatDate(millis) {
	var date = new Date(millis);
	var hours = date.getHours();
	var ampm = hours > 11 ? 'PM' : 'AM';
	if (hours > 12) hours -= 12;
	hours = padWithZero(hours.toString());
	return date.getFullYear() + '-' + padWithZero((date.getMonth() + 1).toString()) +
		'-' + padWithZero(date.getDate().toString()) + ' ' + hours + ':' +
		padWithZero(date.getMinutes().toString()) + ampm;
}

function padWithZero(value) {
	return value.length == 2 ? value : '0' + value;
}
