$(function () {
	$("#fileTree")
		.bind("select_node.jstree", function (event, data) {
			viewFile(data.rslt.obj);
		})
		.jstree({
			plugins: ["themes", "json_data", "ui", "types", "hotkeys", "contextmenu"],
			animation: 0,

			json_data: {
				ajax: {
					url: getFilesPath,
					data: function (n) {
						return {
							'appName': appName,
							'instanceIndex': instanceIndex,
							'path': n.attr ? n.attr('path') : '__ROOT__'
						};
					}
				}
			},

			types: {
				max_depth: -2,
				max_children: -2,
				valid_children: ["drive"],
				types: {
					default: {
						valid_children: "none",
						icon: { image: fileImagePath }
					},
					folder: {
						valid_children: ["default", "folder"],
						icon: { image: folderImagePath }
					},
					drive: {
						valid_children: ["default", "folder"],
						icon: { image: rootImagePath },
						start_drag: false,
						move_node: false,
						delete_node: false,
						remove: false
					}
				}
			},
			core: {
				initially_open: ["ROOT"]
			},
			contextmenu : {
				items : {
               create: false,
               rename: false,
               remove: false,
               ccp: false,
               download : {
						label : 'Download',
						action : function(node) { download(node); }
					}
				}
			}
		})
});

function viewFile(node) {
	if (node.attr('rel') != 'default') {
		return;
	}
	var path = getFilePath + '?appName=' + appName + '&instanceIndex=' + instanceIndex +
			'&path=' + node.attr('path');
	$.get(path, function(data) {
		$('#fileContents').html('<pre>' + data + '</pre>');
	});
}

function download(node) {
	window.location = downloadFilePath + '?appName=' + appName + '&instanceIndex=' + instanceIndex +
			'&path=' + node.attr('path');
}
